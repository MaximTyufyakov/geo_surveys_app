import 'dart:collection';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:geo_surveys_app/common/api.dart';
import 'package:geo_surveys_app/features/task/controllers/task.repository.dart';
import 'package:geo_surveys_app/features/task/models/point.model.dart';
import 'package:geo_surveys_app/features/task/models/task.model.dart';
import 'package:geo_surveys_app/features/task/models/video.model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

/// A provider of the task page.
class TaskProvider extends ChangeNotifier {
  TaskProvider({
    required this.taskid,
    required this.unsavedDialog,
    required this.goBack,
    required this.saveDialog,
    required this.goAuth,
    required this.errorDialog,
    required this.geolocationDialog,
    required this.openVideoShootPage,
    required this.videoDeleteDialog,
    required this.openMapPage,
  }) {
    task = _repository.get(taskid: taskid);
  }

  /// Task identifier.
  final int taskid;

  /// The task repository.
  final TaskRepository _repository = TaskRepository();

  /// Model with task.
  late Future<TaskModel> task;

  /// Show unsaved dialog.
  final ValueGetter<Future<bool?>> unsavedDialog;

  /// Go to previous page.
  final ValueSetter<bool?> goBack;

  /// Show saving dialog.
  final Future<void> Function(Future<List<String>>) saveDialog;

  /// Logout page open.
  VoidCallback goAuth;

  /// Show error.
  final ValueSetter<List<String>> errorDialog;

  /// Open camera page.
  final ValueGetter<Future<File?>> openVideoShootPage;

  /// Show geolocation dialog.
  final Future<void> Function(Future<List<String>>) geolocationDialog;

  /// Video delete dialog.
  final ValueGetter<Future<bool?>> videoDeleteDialog;

  /// Open map page.
  final ValueSetter<List<LatLng>> openMapPage;

  @override
  Future<void> dispose() async {
    /// Delete unsaved in db videos.
    await task
        .then((value) async {
          // Delete unsaved videofiles (without id).
          for (final VideoModel video in value.videos.where(
            (v) => v.videoid == null,
          )) {
            await _deleteVideoFileLocal(file: video.file);
          }
        })
        .catchError((Object err) {
          if (kDebugMode) {
            debugPrint('TaskModel не получена: $err');
          }
        });
    super.dispose();
  }

  /// Template for unsave dialog.
  ///
  /// Param [action] parameter is target activity after dialog.
  Future<void> _unsaveTemplate({required VoidCallback action}) async {
    await task
        .then((value) async {
          if (!value.saved) {
            final bool? ret = await unsavedDialog();

            /// Save = true;
            /// Unsave = false;
            /// Close = null.
            if (ret == true) {
              await onSave();
              if (value.saved) {
                action();
              }
            } else if (ret == false) {
              action();
            }
          } else {
            action();
          }
        })
        .catchError((err) {
          action();
        });
  }

  /// Exit to previous page.
  Future<void> toPrevPage() async => await _unsaveTemplate(
    action: () async => goBack(
      await task
          .then<bool?>((value) => value.completed)
          .catchError((err) => null),
    ),
  );

  /// Exit to login page.
  Future<void> logout() async => await _unsaveTemplate(
    action: () {
      clearToken();
      goAuth();
    },
  );

  /// Reload the task page if the model is saved.
  Future<void> reloadPage() async => await _unsaveTemplate(
    action: () {
      task = _repository.get(taskid: taskid);
      notifyListeners();
    },
  );

  /// Save task data with dialog.
  Future<void> onSave() async {
    /// Open dialog.
    await saveDialog(
      task
          .then<List<String>>((value) {
            /// Delete report spaces.
            value.report = value.report.trim();
            return value.saved
                /// Saved.
                ? ['Нет изменений.', _completedCheck(task: value)]
                /// Not saved.
                : _repository
                      .save(
                        task: value,
                        updatedPoints: value.points,

                        /// If local file exist.
                        createdVideos: value.videos
                            .where((video) => video.file != null)
                            .toList(),
                      )
                      .then((sValue) async {
                        // Delete local files of saved videos.
                        for (final VideoModel video in value.videos) {
                          await _deleteVideoFileLocal(file: video.file);
                        }
                        // Update task object.
                        value.copyWith(copy: sValue);
                        return ['Успешно.', _completedCheck(task: sValue)];
                      })
                      .catchError((Object err) => [err.toString()]);
          })
          .catchError((Object err) => [err.toString()]),
    );
    notifyListeners();
  }

  /// Check task completed (all points completed, add video).
  ///
  /// Returns a true if task completed else false and message.
  String _completedCheck({required TaskModel task}) {
    for (final PointModel point in task.points) {
      if (!point.completed) {
        return 'Для завершения задания окончите все пункты.';
      }
    }
    if (task.videos.isEmpty) {
      return 'Для завершения задания прикрепите видео.';
    }
    return 'Задание завершено.';
  }

  /// Delete video file from local storage.
  Future<String> _deleteVideoFileLocal({required File? file}) async {
    /// File exists.
    if (file != null) {
      try {
        await file.delete();
        file = null;
        return 'Успешно.';
      } catch (e) {
        return Future.error(
          'Ошибка при удалении видео из локального хранилища.',
        );
      }
    } else {
      return 'Локальный файл уже удалён.';
    }
  }

  /// Tap on the point CheckBox.
  void onPointTap({required TaskModel task, required PointModel point}) {
    point.completed = !point.completed;
    task.saved = false;

    notifyListeners();
  }

  /// On report text change.
  void onReportChange({required TaskModel task, required String report}) {
    task
      ..report = report
      ..saved = false;
  }

  /// Open page with camera and add new video in the list.
  Future<void> onVideoAdd({
    required TaskModel task,
    required String newTitle,
  }) async {
    // Without front and back spaces.
    final String title = newTitle.trim();

    // The title does not exist.
    if (title == '') {
      errorDialog(const ['Название видео пустое.']);
      return;

      // The title > 100.
    } else if (title.length > 100) {
      errorDialog(const ['Название видео не должно превышать 100 символов.']);
      return;

      // The title does not unique.
    } else if (!_uniqueTitle(title: title, task: task)) {
      errorDialog(const ['Название видео не уникально.']);
      return;

      // The title exist and unique.
    } else {
      final Future<Position> coordinates = _getGeolocation();
      await geolocationDialog(
        coordinates.then(
          (coordinates) => [
            'Успешно.',
            '''Ваши координаты: ${coordinates.latitude}, ${coordinates.longitude}.''',
          ],
        ),
      );

      await coordinates
          .then((coordinates) async {
            final File? videoFile = await openVideoShootPage();

            /// The video returned.
            if (videoFile != null) {
              /// Add.
              task.videos.add(
                VideoModel(
                  videoid: null,
                  title: title,
                  file: videoFile,
                  latitude: coordinates.latitude,
                  longitude: coordinates.longitude,
                ),
              );
              task.saved = false;

              notifyListeners();
            }
          })
          .catchError((Object err) {
            if (kDebugMode) {
              debugPrint('Ошибка получение геопозиции: $err');
            }
          });
    }
  }

  /// Check unique video title.
  ///
  /// Param [title] is new title.
  /// Returns true if unique.
  bool _uniqueTitle({required String title, required TaskModel task}) {
    final HashSet<String> hashSet = HashSet<String>()
      ..addAll(task.videos.map((video) => video.title).toSet());
    return !hashSet.contains(title);
  }

  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  Future<Position> _getGeolocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      /// Location services are not enabled don't continue
      /// accessing the position and request users of the
      /// App to enable the location services.
      return Future.error('Службы определения местоположения выключены.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error(
          'Отказано в разрешениях на определение местоположения',
        );
      }
    }

    if (permission == LocationPermission.deniedForever) {
      /// Permissions are denied forever, handle appropriately.
      return Future.error(
        'Навсегда отказано в разрешениях на определение местоположения',
      );
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  /// When video delete button click.
  Future<void> onVideoDelete({
    required TaskModel task,
    required VideoModel video,
  }) async {
    await videoDeleteDialog().then((del) async {
      if (del == true) {
        /// Delete video model.
        task.videos.remove(video);
        if (video.videoid != null) {
          task.deletedVideosId.add(video.videoid!);
        }
        task.saved = false;

        /// Delete file.
        await _deleteVideoFileLocal(file: video.file);
        notifyListeners();
      }
    });
  }

  // /// Rename video file, delete from tmpDir and save in docDir.
  // Future<String> _saveFileLocal() async {
  //   /// Video created.
  //   if (file != null) {
  //     final Directory docDir = await getApplicationDocumentsDirectory();
  //     final Directory videosDir = Directory('${docDir.path}/videos');
  //     await videosDir.create(recursive: true);
  //     final String videoPath =
  //         '${videosDir.path}/${DateTime.now().millisecondsSinceEpoch}.$format';
  //     file = await file!.rename(videoPath);
  //     return ('Успешно.');
  //   } else {
  //     return Future.error('Ошибка. Файл не найден.');
  //   }
  // }

  /// Open map page with task markers.
  Future<void> openMap() async {
    await task
        .then((value) {
          openMapPage([value.coordinates]);
        })
        .catchError((Object err) {
          errorDialog([err.toString()]);
        });
  }
}

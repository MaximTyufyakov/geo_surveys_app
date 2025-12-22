import 'dart:collection';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geo_surveys_app/features/task/models/task.model.dart';
import 'package:geo_surveys_app/features/task/models/video.model.dart';
import 'package:geolocator/geolocator.dart';

/// A ViewModel of the video.
class VideosViewModel extends ChangeNotifier {
  VideosViewModel({
    required this.model,
    required this.errorDialog,
    required this.openVideoShootPage,
    required this.geolocationDialog,
  });

  /// Task model.
  final TaskModel model;

  /// New title controller.
  final TextEditingController newTitleController = TextEditingController(
    text: '',
  );

  /// Show error.
  final ValueSetter<List<String>> errorDialog;

  /// Open camera page.
  final ValueGetter<Future<File?>> openVideoShootPage;

  /// Show geolocation.
  final Future<void> Function(Future<List<String>>) geolocationDialog;

  @override
  void notifyListeners() {
    super.notifyListeners();
  }

  /// Open page with camera and add new video in the list.
  Future<void> videoCreate() async {
    // Without front and back spaces.
    final String title = newTitleController.text.trim();

    // The title does not exist.
    if (title == '') {
      errorDialog(const ['Название видео пустое.']);
      return;

      // The title > 100.
    } else if (title.length > 100) {
      errorDialog(const ['Название видео не должно превышать 100 символов.']);
      return;

      // The title does not unique.
    } else if (!uniqueTitle(title)) {
      errorDialog(const ['Название видео не уникально.']);
      return;

      // The title exist and unique.
    } else {
      final Future<Position> coordinates = getGeolocation();
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

            // The video returned.
            if (videoFile != null) {
              model.addVideo(
                VideoModel(
                  videoid: null,
                  title: title,
                  file: videoFile,
                  latitude: coordinates.latitude,
                  longitude: coordinates.longitude,
                ),
              );

              // Clear title.
              newTitleController.text = '';
              notifyListeners();
            }
          })
          .catchError((err) {});
    }
  }

  /// Check unique video title.
  ///
  /// Param [title] is new title.
  /// Returns true if unique.
  bool uniqueTitle(String title) {
    final HashSet<String> hashSet = HashSet<String>()
      ..addAll(model.videos.map((video) => video.title).toSet());
    return !hashSet.contains(title);
  }

  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  Future<Position> getGeolocation() async {
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
}

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:geo_surveys_app/common/models/api.model.dart';
import 'package:geo_surveys_app/features/task/models/point.model.dart';
import 'package:geo_surveys_app/features/task/models/report.model.dart';
import 'package:geo_surveys_app/features/task/models/video.model.dart';

/// The task model.
///
/// The [taskid] parameter is the task identifier.
/// The [title] parameter is the task name.
/// The [description] parameter is the text task description.
/// The [coordinates] parameter is the task geographic coordinates.
/// The [completed] parameter is the completed flag.
/// The [report] parameter is the report model.
/// The [points] parameter is the list of points that need to be completed.
/// The [saved] parameter is the saved flag.
class TaskModel {
  /// Parse task from Response to TaskModel.
  ///
  /// The [response] parameter is the task response.
  /// Returns a [TaskModel].
  factory TaskModel.parseTask(Response<Map<String, dynamic>> response) {
    final Map<String, dynamic> taskResponse =
        response.data!['task'] as Map<String, dynamic>;

    // Create task model.
    return TaskModel._create(
      taskid: taskResponse['task_id'] as int,
      title: taskResponse['title'] as String,
      description: taskResponse['description'] as String?,
      latitude: (taskResponse['latitude'] as num?)?.toDouble(),
      longitude: (taskResponse['longitude'] as num?)?.toDouble(),
      completed: taskResponse['completed'] as bool,
      report: ReportModel(text: taskResponse['report'] as String? ?? ''),
      saved: true,
      points: (response.data!['points'] as List<dynamic>).map((pointResponse) {
        final point = pointResponse as Map<String, dynamic>;
        return PointModel(
          pointid: point['point_id'] as int,
          number: point['number'] as int,
          description: point['description'] as String,
          completed: point['completed'] as bool,
        );
      }).toList(),
      videos: (response.data!['videos'] as List<dynamic>).map((videoResponse) {
        final video = videoResponse as Map<String, dynamic>;
        return VideoModel(
          videoid: video['video_id'] as int,
          title: video['title'] as String,
          file: null,
          latitude: (video['latitude'] as num).toDouble(),
          longitude: (video['longitude'] as num).toDouble(),
        );
      }).toList(),
    ).._setParent();
  }

  /// Private constructor.
  TaskModel._create({
    required this.taskid,
    required this.title,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.completed,
    required this.points,
    required this.saved,
    required this.report,
    required this.videos,
  });

  /// The task identifier.
  final int taskid;

  /// The task name.
  String title;

  /// The text task description.
  String? description;

  /// The task geographic coordinates.
  double? latitude;
  double? longitude;

  /// The completed flag.
  bool completed;

  /// The text that the user writes (optional).
  ReportModel report;

  /// The list of points that need to be completed.
  final List<PointModel> points;

  /// The list of videos.
  final List<VideoModel> videos;

  /// The list of deleted videos id.
  final List<int> deletedVideosId = [];

  /// The saved flag.
  bool saved;

  /// Public factory.
  /// Retrieves task from the database.
  ///
  /// Returns a [Future] that completes when the response is successful.
  /// Throws a [Future.error] with [String] message if database fails.
  static Future<TaskModel> create({required int taskid}) async {
    try {
      // Api response.
      final Response<Map<String, dynamic>> response = await dio.get(
        '/tasks/$taskid',
        options: Options(
          validateStatus: (status) => status == 200 || status == 403,
        ),
      );

      switch (response.statusCode) {
        // Ok.
        case 200:
          return TaskModel.parseTask(response);

        // Forbidden
        case 403:
          return Future.error('Нет доступа.');

        default:
          return Future.error('Ошибка при обращении к серверу.');
      }
    } on DioException {
      return Future.error('Ошибка при обращении к серверу.');
    }
  }

  void _copyWith(TaskModel copy) {
    title = copy.title;
    description = copy.description;
    latitude = copy.latitude;
    longitude = copy.longitude;
    completed = copy.completed;
    report = copy.report;

    // 1. Обновляем существующие объекты вместо замены
    _updatePoints(copy.points);
    _updateVideos(copy.videos);

    deletedVideosId.clear();

    saved = copy.saved;
  }

  void _updatePoints(List<PointModel> newPoints) {
    final Map<int, PointModel> newPointsMap = {
      for (final p in newPoints) p.pointid: p,
    };

    // Обновляем существующие
    for (final point in points) {
      final updatedPoint = newPointsMap[point.pointid];
      if (updatedPoint != null) {
        point
          ..number = updatedPoint.number
          ..description = updatedPoint.description
          ..completed = updatedPoint.completed;
        newPointsMap.remove(point.pointid);
      }
    }

    // Добавляем новые
    points.addAll(newPointsMap.values);

    // Удаляем те, которых нет в новых данных
    final newPointIds = newPoints.map((p) => p.pointid).toSet();
    points.removeWhere((p) => !newPointIds.contains(p.pointid));
  }

  void _updateVideos(List<VideoModel> newVideos) {
    final Map<int?, VideoModel> newVideosMap = {
      for (final v in newVideos) v.videoid: v,
    };

    // Сохраняем локальные файлы
    final Map<int?, File?> localFiles = {
      for (final v in videos.where((v) => v.file != null)) v.videoid: v.file,
    };

    // Обновляем существующие
    for (final video in videos) {
      final updatedVideo = newVideosMap[video.videoid];
      if (updatedVideo != null) {
        video
          ..title = updatedVideo.title
          ..latitude = updatedVideo.latitude
          ..longitude = updatedVideo.longitude
          ..file = localFiles[video.videoid]; // Сохраняем локальный файл
        newVideosMap.remove(video.videoid);
      }
    }

    // Добавляем новые
    final newVideoList = newVideosMap.values.map((v) {
      // Если у нового видео есть локальный файл, сохраняем его
      if (localFiles.containsKey(v.videoid)) {
        return VideoModel(
          videoid: v.videoid,
          title: v.title,
          file: localFiles[v.videoid],
          latitude: v.latitude,
          longitude: v.longitude,
        )..parent = this;
      }
      return v..parent = this;
    }).toList();

    videos.addAll(newVideoList);

    // Удаляем те, которых нет в новых данных
    final newVideoIds = newVideos.map((v) => v.videoid).toSet();
    videos.removeWhere((v) => !newVideoIds.contains(v.videoid));
  }

  /// Set task as a parent for childs.
  void _setParent() {
    report.parent = this;
    for (final PointModel point in points) {
      point.parent = this;
    }
    for (final VideoModel video in videos) {
      video.parent = this;
    }
  }

  /// Marks the task as unsaved.
  /// Run when widgets change.
  void makeUnsaved() {
    saved = false;
  }

  /// Add new video in the list.
  void addVideo(VideoModel video) {
    video.parent = this;
    videos.add(video);
    makeUnsaved();
  }

  /// Delete a video from the main list and add in the deleted list.
  void deleteVideo(VideoModel video) {
    videos.remove(video);
    if (video.videoid != null) {
      deletedVideosId.add(video.videoid!);
    }
    makeUnsaved();
  }

  /// Save task progress (points, report, videos).
  ///
  /// Returns a [Future] that completes when the response is successful.
  /// Throws a [Future.error] with [String] message if database fails or
  /// no update.
  Future<void> save() async {
    if (!saved) {
      try {
        // Api response.
        final Response<Map<String, dynamic>> response = await dio.put(
          '/tasks/save',
          data: {
            'task_id': taskid,
            // All points.
            'updatedPoints': points
                .map(
                  (point) => {
                    'point_id': point.pointid,
                    'completed': point.completed,
                  },
                )
                .toList(),
            'report': report.text,
            // Videos with file.
            'createdVideos': videos
                .where((video) => video.file != null)
                .map(
                  (video) => {
                    'title': video.title,
                    'file': base64Encode(video.file!.readAsBytesSync()),
                    'format': video.format,
                    'latitude': video.latitude,
                    'longitude': video.longitude,
                  },
                )
                .toList(),
            // Deleted videos id.
            'deletedVideos': deletedVideosId,
          },
          options: Options(
            validateStatus: (status) => status == 201 || status == 403,
          ),
        );

        switch (response.statusCode) {
          // Update.
          case 201:
            // Clean deletedVideos list.
            deletedVideosId.clear();
            // Delete files of saved videos.
            for (final VideoModel video in videos) {
              await video.deleteFileLocal();
            }
            // Update task object.
            _copyWith(TaskModel.parseTask(response));
            // saved = true;
            return;

          // Forbidden
          case 403:
            return Future.error('Нет доступа.');

          default:
            return Future.error('Ошибка при обращении к серверу.');
        }
      } on DioException {
        return Future.error('Ошибка при обращении к серверу.');
      }
    } else {
      return Future.error('Нет изменений. ${completedCheck().$2}');
    }
  }

  /// Check task completed (all points completed, add video).
  ///
  /// Returns a true if task completed else false and message.
  (bool, String) completedCheck() {
    for (final PointModel point in points) {
      if (!point.completed) {
        return (false, 'Для завершения задания окончите все пункты.');
      }
    }
    if (videos.isEmpty) {
      return (false, 'Для завершения задания прикрепите видео.');
    }
    return (true, 'Задание завершено.');
  }

  /// Delete videofiles from local storage.
  /// If it not saved.
  Future<void> deleteUnsavedVideoFiles() async {
    for (final VideoModel video in videos.where((v) => v.videoid == null)) {
      await video.deleteFileLocal();
    }
  }
}

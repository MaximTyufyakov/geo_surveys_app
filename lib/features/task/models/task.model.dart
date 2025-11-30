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
  final String title;

  /// The text task description.
  final String? description;

  /// The task geographic coordinates.
  final double? latitude;
  final double? longitude;

  /// The completed flag.
  bool completed;

  /// The text that the user writes (optional).
  ReportModel report;

  /// The list of points that need to be completed.
  final List<PointModel> points;

  /// The list of videos.
  final List<VideoModel> videos;

  /// The list of deleted videos.
  final List<VideoModel> deletedVideos = [];

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
      Response<Map<String, String>> response = await ApiModel.dio.get(
        '/tasks/$taskid',
      );

      // Ok.
      if (response.statusCode == 200) {
        return parseTask(response);

        // Forbidden
      } else if (response.statusCode == 403) {
        return Future.error('Нет доступа.');

        // Error.
      } else {
        return Future.error('Ошибка при обращении к серверу.');
      }
    } on SocketException {
      return Future.error('Ошибка: нет соеденинения с базой данных.');
    } on TimeoutException {
      return Future.error(
          'Ошибка: время ожидания подключения к базе данных истекло.');
    } on TypeError {
      return Future.error(
          'Ошибка: из базы данных получен неправильный тип данных.');
    } catch (e) {
      return Future.error('Неизвестная ошибка при обращении к базе данных.');
    }
  }

  /// Parse task from Response to TaskModel.
  ///
  /// The [response] parameter is the task response.
  /// Returns a [TaskModel].
  static TaskModel parseTask(Response<Map<String, String>> response) {
    Map<String, String> taskResponse =
        response.data!['task'] as Map<String, String>;

    // Create task model.
    TaskModel component = TaskModel._create(
      taskid: taskResponse['task_id'] as int,
      title: taskResponse['title'] as String,
      description: taskResponse['description'],
      latitude: taskResponse['latitude'] as double?,
      longitude: taskResponse['longitude'] as double?,
      completed: taskResponse['completed'] as bool,
      report: ReportModel(text: taskResponse['report'] ?? ''),
      saved: true,
      points: (taskResponse['points'] as List<Map<String, String>>)
          .map((pointResponse) => PointModel(
                pointid: pointResponse['point_id'] as int,
                number: pointResponse['number'] as int,
                description: pointResponse['description'] as String,
                completed: pointResponse['completed'] as bool,
              ))
          .toList(),
      videos: (taskResponse['videos'] as List<Map<String, String>>)
          .map((videoResponse) => VideoModel(
                videoid: videoResponse['video_id'] as int,
                title: videoResponse['title'] as String,
                file: null,
              ))
          .toList(),
    ).._setParent();

    return component;
  }

  /// Set task as a parent for childs.
  void _setParent() {
    report.parent = this;
    for (PointModel point in points) {
      point.parent = this;
    }
    for (VideoModel video in videos) {
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
    deletedVideos.add(video);
    makeUnsaved();
  }

  /// Save task progress (points, report, videos).
  ///
  /// Returns a [Future] that completes when the response is successful.
  /// Throws a [Future.error] with [String] message if database fails or
  /// no update.
  Future<String> save() async {
    if (!saved) {
      try {
        // Api response.
        Response<Map<String, String>> response = await ApiModel.dio.put(
          '/tasks/save',
          data: {
            'task_id': taskid,
            // All points.
            'updatedPoints': points
                .map((point) => {
                      'point_id': point.pointid,
                      'completed': point.completed,
                    })
                .toList(),
            'report': report.text,
            // Videos with file.
            'createdVideos': videos
                .where((video) => video.file != null)
                .map((video) async => {
                      'title': video,
                      'file': base64Encode(await video.file!.readAsBytes()),
                      'format': video.format
                    })
                .toList(),
            // Deleted videos id.
            'deletedVideos':
                deletedVideos.map((video) => video.videoid).toList(),
          },
        );

        // Clean deletedVideos list.
        deletedVideos.clear();

        // Ok.
        if (response.statusCode == 200) {
          return 'Успешно. ${_completedCheck().$2}';

          // Forbidden
        } else if (response.statusCode == 403) {
          return Future.error('Нет доступа.');

          // Error.
        } else {
          return Future.error('Ошибка при обращении к серверу.');
        }
      } on SocketException {
        return Future.error('Ошибка: нет соеденинения с базой данных.');
      } on TimeoutException {
        return Future.error(
            'Ошибка: время ожидания подключения к базе данных истекло.');
      } on TypeError {
        return Future.error(
            'Ошибка: из базы данных получен неправильный тип данных.');
      } catch (e) {
        return Future.error('Неизвестная ошибка при обращении к базе данных.');
      }
    } else {
      return 'Нет изменений. ${_completedCheck().$2}';
    }
  }

  /// Check task completed (all points completed, add video).
  ///
  /// Returns a true if task completed else false and message.
  (bool, String) _completedCheck() {
    for (PointModel point in points) {
      if (!point.completed) {
        return (false, 'Для завершения задания окончите все пункты.');
      }
    }
    if (videos.isEmpty) {
      return (false, 'Для завершения задания прикрепите видео.');
    }
    return (true, 'Задание завершено.');
  }
}

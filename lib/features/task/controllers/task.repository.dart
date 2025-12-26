import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:geo_surveys_app/common/api.dart';
import 'package:geo_surveys_app/features/task/models/point.model.dart';
import 'package:geo_surveys_app/features/task/models/task.model.dart';
import 'package:geo_surveys_app/features/task/models/video.model.dart';

/// A repository of task endpoints.
class TaskRepository {
  /// Retrieves task from api.
  ///
  /// Returns a [Future] that completes when the response is successful.
  /// Throws a [Future.error] with [String] message if database fails.
  Future<TaskModel> get({required int taskid}) async {
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
          return TaskModel.fromJson(response.data!);

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

  /// Save task progress (points, report, videos).
  ///
  /// Returns a [Future] that completes when the response is successful.
  /// Throws a [Future.error] with [String] message if database fails or
  /// no update.
  Future<TaskModel> save({
    required TaskModel task,
    required List<PointModel> updatedPoints,
    required List<VideoModel> createdVideos,
  }) async {
    try {
      // Api response.
      final Response<Map<String, dynamic>> response = await dio.put(
        '/tasks/save',
        data: {
          'task_id': task.taskid,
          // Changed points.
          'updatedPoints': updatedPoints
              .map(
                (point) => {
                  'point_id': point.pointid,
                  'completed': point.completed,
                },
              )
              .toList(),
          'report': task.report,
          // Videos with file.
          'createdVideos': createdVideos
              .map(
                (video) => {
                  'title': video.title,
                  'file': video.file != null
                      ? base64Encode(video.file!.readAsBytesSync())
                      : null,
                  'format': video.format,
                  'latitude': video.latitude,
                  'longitude': video.longitude,
                },
              )
              .toList(),
          // Deleted videos id.
          'deletedVideos': task.deletedVideosId,
        },
        options: Options(
          validateStatus: (status) => status == 201 || status == 403,
        ),
      );

      switch (response.statusCode) {
        // Update.
        case 201:
          return TaskModel.fromJson(response.data!);

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
}

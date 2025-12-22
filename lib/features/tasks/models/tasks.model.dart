import 'dart:async';
import 'package:dio/dio.dart';
import 'package:geo_surveys_app/common/models/api.model.dart';
import 'package:geo_surveys_app/features/tasks/models/base_task.model.dart';

/// A model with all tasks.
///
/// The [tasks] parameter is the list of tasks from database.
class TasksModel {
  /// Private constructor
  TasksModel._create({required this.tasks});

  /// The list of tasks from database.
  final List<BaseTaskModel> tasks;

  /// Public factory.
  /// Retrieves all tasks from the database.
  ///
  /// Returns a [Future] that completes when the response is successful.
  /// Throws a [Future.error] with [String] message if database fails.
  static Future<TasksModel> create() async {
    try {
      // Api response.
      final Response<Map<String, dynamic>> response = await dio.get(
        '/tasks/all',
        options: Options(
          validateStatus: (status) => status == 200 || status == 403,
        ),
      );

      switch (response.statusCode) {
        // Ok.
        case 200:
          // Create list.
          return TasksModel._create(
            tasks: (response.data!['tasks'] as List<dynamic>).map((task) {
              final taskMap = task as Map<String, dynamic>;
              return BaseTaskModel(
                taskid: taskMap['task_id'] as int,
                title: taskMap['title'] as String,
                completed: taskMap['completed'] as bool,
              );
            }).toList(),
          );

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

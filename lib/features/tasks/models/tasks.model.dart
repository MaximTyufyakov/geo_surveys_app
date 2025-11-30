import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:geo_surveys_app/common/models/api.model.dart';
import 'package:geo_surveys_app/features/tasks/models/base_task.model.dart';

/// A model with all tasks.
///
/// The [tasks] parameter is the list of tasks from database.
class TasksModel {
  /// Private constructor
  TasksModel._create({
    required this.tasks,
  });

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
      Response<Map<String, String>> response = await ApiModel.dio.get(
        '/tasks/all',
      );

      // Ok.
      if (response.statusCode == 200) {
        // Create list.
        List<BaseTaskModel> tasksList = [];
        for (Map<String, String> task
            in response.data!['tasks'] as List<Map<String, String>>) {
          tasksList.add(BaseTaskModel(
            taskid: task['task_id'] as int,
            title: task['title'] as String,
            completed: task['completed'] as bool,
          ));
        }

        return TasksModel._create(
          tasks: tasksList,
        );

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
}

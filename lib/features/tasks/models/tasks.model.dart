import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:geo_surveys_app/common/models/databases.model.dart';
import 'package:geo_surveys_app/features/tasks/models/base_task.model.dart';
import 'package:postgres/postgres.dart';

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
  /// The [userid] parameter is the user ID.
  ///
  /// Returns a [Future] that completes when the response is successful.
  /// Throws a [Future.error] with [String] message if database fails.
  static Future<TasksModel> create(int userid) async {
    try {
      final conn = await Connection.open(
        GeosurveysDB.endpoint,
        settings: GeosurveysDB.settings,
      );

      Result utResponse = await conn.execute(
        Sql.named(
          ''' SELECT task_id
              FROM user_task
              WHERE user_id = @userid;''',
        ),
        parameters: {
          'userid': userid,
        },
      );

      List<BaseTaskModel> tasksList = [];
      for (List<dynamic> d in utResponse) {
        Result tResponse = await conn.execute(
          Sql.named(
            ''' SELECT task_id, title, completed
              FROM task
              WHERE task_id = @taskid;''',
          ),
          parameters: {
            'taskid': d[0] as int,
          },
        );

        tasksList.add(BaseTaskModel(
          taskid: tResponse[0][0] as int,
          title: tResponse[0][1] as String,
          completed: tResponse[0][2] as bool,
          userid: userid,
        ));
      }

      await conn.close();

      TasksModel component = TasksModel._create(
        tasks: tasksList,
      );

      return component;
    } on SocketException {
      return Future.error('Ошибка: нет соеденинения с базой данных.');
    } on TimeoutException {
      return Future.error(
          'Ошибка: время ожидания подключения к базе данных истекло.');
    } on TypeError {
      return Future.error(
          'Ошибка: из базы данных получен неправильный тип данных.');
    } catch (e) {
      if (e is ServerException) {
        log(e.message);
        return Future.error('Ошибка: запрос к базе данных отклонён.');
      }
      return Future.error('Неизвестная ошибка при обращении к базе данных.');
    }
  }
}

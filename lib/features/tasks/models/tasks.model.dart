import 'dart:async';
import 'dart:io';

import 'package:geo_surveys_app/common/models/databases.model.dart';
import 'package:geo_surveys_app/features/tasks/models/base_task.model.dart';
import 'package:postgres_dart/postgres_dart.dart';

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
      if (Databases.geosurveys.db.isClosed) {
        await Databases.geosurveys.open();
      }

      DbResponse utResponse =
          await Databases.geosurveys.table('user_task').select(
        columns: [
          Column('taskid'),
        ],
        where: Where(
          'userid',
          WhereOperator.isEqual,
          userid,
        ),
      );
      List<BaseTaskModel> tasksList = [];
      for (List<dynamic> d in utResponse.data) {
        DbResponse tResponse = await Databases.geosurveys.table('task').select(
          columns: [
            Column('taskid'),
            Column('title'),
            Column('completed'),
          ],
          where: Where(
            'taskid',
            WhereOperator.isEqual,
            d[0] as int,
          ),
        );
        tasksList.add(BaseTaskModel(
          taskid: tResponse.data[0][0] as int,
          title: tResponse.data[0][1] as String,
          completed: tResponse.data[0][2] as bool,
          userid: userid,
        ));
      }

      TasksModel component = TasksModel._create(
        tasks: tasksList,
      );

      return component;
    } on PostgreSQLException {
      return Future.error('Ошибка: запрос к базе данных отклонён.');
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

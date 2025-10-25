import 'dart:async';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geo_surveys_app/features/task/models/task.model.dart';
import 'package:postgres_dart/postgres_dart.dart';

/// The task point model.
///
/// The [parent] parameter is the task.
/// The [pointid] parameter is the point identifier.
/// The [number] parameter is the point number in the task.
/// The [description] parameter is the text point description.
/// The [completed] parameter is the completed flag.
class PointModel {
  PointModel({
    required this.pointid,
    required this.number,
    required this.description,
    required this.completed,
  });

  /// Parent model.
  late TaskModel parent;

  /// The point identifier.
  int pointid;

  /// The point number in the task.
  int number;

  /// The text point description.
  String description;

  /// The completed flag.
  bool completed;

  Future<String> comletedUpdate() async {
    try {
      PostgresDb geosurveysDb = PostgresDb(
        host: dotenv.env['DB_HOST'] as String,
        databaseName: dotenv.env['DB_NAME'] as String,
        username: dotenv.env['DB_USERNAME'] as String,
        password: dotenv.env['DB_PASSWORD'] as String,
        queryTimeoutInSeconds:
            int.parse(dotenv.env['DB_QUERY_TIMEOUT'] as String),
        timeoutInSeconds: int.parse(dotenv.env['DB_TIMEOUT'] as String),
      );
      if (geosurveysDb.db.isClosed) {
        await geosurveysDb.open();
      }
      await geosurveysDb.table('point').update(
        update: {
          'completed': completed,
        },
        where: Where(
          'pointid',
          WhereOperator.isEqual,
          pointid,
        ),
      );
      return ('Успешно');
    } on PostgreSQLException {
      return Future.error('Ошибка: запрос к базе данных отклонён.');
    } on SocketException {
      return Future.error('Ошибка: нет соеденинения с базой данных.');
    } on TimeoutException {
      return Future.error(
          'Ошибка: время ожидания подключения к базе данных истекло.');
    } catch (e) {
      return Future.error('Неизвестная ошибка при обращении к базе данных.');
    }
  }

  /// Inverse completed field.
  void comletedInverse() {
    completed = !completed;
    _makeUnsaved();
  }

  /// Marks the task as unsaved.
  /// Run when widgets change.
  void _makeUnsaved() {
    parent.makeUnsaved();
  }
}

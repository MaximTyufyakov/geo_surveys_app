import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:geo_surveys_app/features/task/models/task.model.dart';
import 'package:postgres/postgres.dart';

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
      final conn = await Connection.open(
        GeosurveysDB.endpoint,
        settings: GeosurveysDB.settings,
      );

      await conn.execute(
        Sql.named(
          ''' UPDATE point
              SET completed = @completed
              WHERE point_id = @pointid;''',
        ),
        parameters: {
          'completed': completed,
          'pointid': pointid,
        },
      );

      await conn.close();

      return ('Успешно');
    } on SocketException {
      return Future.error('Ошибка: нет соеденинения с базой данных.');
    } on TimeoutException {
      return Future.error(
          'Ошибка: время ожидания подключения к базе данных истекло.');
    } catch (e) {
      if (e is ServerException) {
        log(e.message);
        return Future.error('Ошибка: запрос к базе данных отклонён.');
      }
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

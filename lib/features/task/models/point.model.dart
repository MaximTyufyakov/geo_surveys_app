import 'dart:async';
import 'dart:io';

import 'package:geo_surveys_app/common/models/databases.model.dart';
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
      if (Databases.geosurveys.db.isClosed) {
        await Databases.geosurveys.open();
      }
      await Databases.geosurveys.table('point').update(
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

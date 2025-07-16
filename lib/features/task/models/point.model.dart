import 'package:geo_surveys_app/common/models/db.model.dart';
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
      if (DbModel.geosurveysDb.db.isClosed) {
        await DbModel.geosurveysDb.open();
      }
      await DbModel.geosurveysDb.table('point').update(
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
    } catch (e) {
      return Future.error('Ошибка при обращении к базе данных.');
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

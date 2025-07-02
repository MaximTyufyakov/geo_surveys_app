import 'package:geo_surveys_app/common/models/db.model.dart';
import 'package:geo_surveys_app/features/tasks/models/point.model.dart';
import 'package:postgres_dart/postgres_dart.dart';

/// The task model.
///
/// {@category Models}
class Task {
  Task(
      {required this.taskid,
      required this.title,
      required this.description,
      required this.coordinates,
      required this.completed,
      required this.report,
      required this.points});
  int taskid;
  String title;
  String description;
  PgPoint coordinates;
  bool completed;
  String? report;
  List<Point> points;

  /// Retrieves all points for task from the database.
  ///
  /// Returns a [Future] that completes when the response is successful.
  Future<List<Task>> getPoints() async {
    try {
      if (DbModel.geosurveysDb.db.isClosed) {
        await DbModel.geosurveysDb.open();
      }
      DbResponse response =
          await DbModel.geosurveysDb.table('point').select(columns: [
        Column('pointid'),
        Column('taskid'),
        Column('number'),
        Column('description'),
        Column('completed'),
      ]);
      List<Task> result = [];
      for (List<dynamic> d in response.data) {
        result.add(Task(
          taskid: d[0] as int,
          title: d[1] as String,
          description: d[2] as String,
          coordinates: d[3] as PgPoint,
          completed: d[4] as bool,
          report: d[5] as String?,
          points: [],
        ));
      }
      return result;
    } catch (e) {
      return Future.error('Ошибка при обращении к базе данных.');
    }
  }
}

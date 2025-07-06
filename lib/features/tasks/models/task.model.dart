import 'package:geo_surveys_app/common/models/db.model.dart';
import 'package:geo_surveys_app/features/tasks/models/point.model.dart';
import 'package:postgres_dart/postgres_dart.dart';

/// The task model.
///
/// The [taskid] parameter is the task identifier.
/// The [title] parameter is the task name.
/// The [description] parameter is the text task description.
/// The [coordinates] parameter is the task geographic coordinates.
/// The [completed] parameter is the completed flag.
/// The [report] parameter is the text that the user writes (optional).
/// The [points] parameter is the list of points that need to be completed.
/// The [saved] parameter is the saved flag.
class Task {
  Task({
    required this.taskid,
    required this.title,
    required this.description,
    required this.coordinates,
    required this.completed,
    required this.report,
    required this.saved,
  }) {
    points = _getPoints();
  }

  /// The task identifier.
  int taskid;

  /// The task name.
  String title;

  /// The text task description.
  String description;

  /// The task geographic coordinates.
  PgPoint coordinates;

  /// The completed flag.
  bool completed;

  /// The text that the user writes (optional).
  String? report;

  /// The list of points that need to be completed.
  late Future<List<Point>> points;

  /// The saved flag.
  bool saved;

  /// Retrieves all points for task from the database.
  ///
  /// Returns a [Future] that completes when the response is successful.
  /// Throws a [Future.error] with [String] message if database fails.
  Future<List<Point>> _getPoints() async {
    try {
      if (DbModel.geosurveysDb.db.isClosed) {
        await DbModel.geosurveysDb.open();
      }
      DbResponse response = await DbModel.geosurveysDb.table('point').select(
        columns: [
          Column('pointid'),
          Column('taskid'),
          Column('number'),
          Column('description'),
          Column('completed'),
        ],
        where: Where(
          'taskid',
          WhereOperator.isEqual,
          taskid,
        ),
        orderBy: OrderBy(
          'number',
          ascending: true,
        ),
      );
      List<Point> result = [];
      for (List<dynamic> d in response.data) {
        result.add(Point(
          pointid: d[0] as int,
          taskid: d[1] as int,
          number: d[2] as int,
          description: d[3] as String,
          completed: d[4] as bool,
        ));
      }
      return result;
    } catch (e) {
      return Future.error('Ошибка при обращении к базе данных.');
    }
  }

  Future<String> save() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!saved) {
      saved = true;
      return 'Успешно.';
    } else {
      return Future.error('Нет изменений.');
    }
  }
}

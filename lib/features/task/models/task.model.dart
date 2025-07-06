import 'package:geo_surveys_app/common/models/db.model.dart';
import 'package:geo_surveys_app/features/task/models/point.model.dart';
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
class TaskModel {
  /// Private constructor
  TaskModel._create({
    required this.taskid,
    required this.title,
    required this.description,
    required this.coordinates,
    required this.completed,
    required this.report,
    required this.points,
    required this.saved,
  });

  /// The task identifier.
  final int taskid;

  /// The task name.
  final String title;

  /// The text task description.
  final String description;

  /// The task geographic coordinates.
  final PgPoint coordinates;

  /// The completed flag.
  bool completed;

  /// The text that the user writes (optional).
  String? report;

  /// The list of points that need to be completed.
  final List<PointModel> points;

  /// The saved flag.
  bool saved;

  /// Public factory.
  /// Retrieves task from the database.
  ///
  /// Returns a [Future] that completes when the response is successful.
  /// Throws a [Future.error] with [String] message if database fails.
  static Future<TaskModel> create({required int taskid}) async {
    try {
      if (DbModel.geosurveysDb.db.isClosed) {
        await DbModel.geosurveysDb.open();
      }
      DbResponse response = await DbModel.geosurveysDb.table('task').select(
        columns: [
          Column('taskid'),
          Column('title'),
          Column('description'),
          Column('coordinates'),
          Column('completed'),
          Column('report')
        ],
        where: Where(
          'taskid',
          WhereOperator.isEqual,
          taskid,
        ),
      );

      /// Call the private constructor
      TaskModel result = TaskModel._create(
        taskid: response.data[0][0] as int,
        title: response.data[0][1] as String,
        description: response.data[0][2] as String,
        coordinates: response.data[0][3] as PgPoint,
        completed: response.data[0][4] as bool,
        report: response.data[0][5] as String?,
        saved: true,
        points: await _getPoints(taskid: taskid),
      );

      return result;
    } catch (e) {
      return Future.error('Ошибка при обращении к базе данных.');
    }
  }

  /// Retrieves all points for task from the database.
  ///
  /// Returns a [Future] that completes when the response is successful.
  /// Throws a [Future.error] with [String] message if database fails.
  static Future<List<PointModel>> _getPoints({required int taskid}) async {
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
      List<PointModel> result = [];
      for (List<dynamic> d in response.data) {
        result.add(PointModel(
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

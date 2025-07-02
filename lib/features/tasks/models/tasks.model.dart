import 'package:geo_surveys_app/common/models/db.model.dart';
import 'package:geo_surveys_app/features/tasks/models/task.model.dart';
import 'package:postgres_dart/postgres_dart.dart';

/// The model with all tasks.
///
/// {@category Models}
class TasksModel {
  TasksModel() {
    tasks = getTasks();
  }
  late Future<List<Task>> tasks;

  /// Retrieves all tasks from the database.
  ///
  /// Returns a [Future] that completes when the response is successful.
  Future<List<Task>> getTasks() async {
    try {
      if (DbModel.geosurveysDb.db.isClosed) {
        await DbModel.geosurveysDb.open();
      }
      DbResponse response =
          await DbModel.geosurveysDb.table('task').select(columns: [
        Column('taskid'),
        Column('title'),
        Column('description'),
        Column('coordinates'),
        Column('completed'),
        Column('report')
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

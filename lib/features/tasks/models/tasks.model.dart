import 'package:geo_surveys_app/common/models/db.model.dart';
import 'package:postgres_dart/postgres_dart.dart';

/// A class with basic information of the task.
///
/// The [taskid] parameter is the task identifier.
/// The [title] parameter is the task name.
/// The [completed] parameter is the completed flag.
class Task {
  Task({
    required this.taskid,
    required this.title,
    required this.completed,
  });

  /// The task identifier.
  int taskid;

  /// The task name.
  String title;

  /// The completed flag.
  bool completed;
}

/// A model with all tasks.
///
/// The [tasks] parameter is the list of tasks from database.
class TasksModel {
  TasksModel() : tasks = _getTasks();

  /// The list of tasks from database.
  Future<List<Task>> tasks;

  /// Retrieves all tasks from the database.
  ///
  /// Returns a [Future] that completes when the response is successful.
  /// Throws a [Future.error] with [String] message if database fails.
  static Future<List<Task>> _getTasks() async {
    try {
      if (DbModel.geosurveysDb.db.isClosed) {
        await DbModel.geosurveysDb.open();
      }

      DbResponse response =
          await DbModel.geosurveysDb.table('task').select(columns: [
        Column('taskid'),
        Column('title'),
        Column('completed'),
      ]);
      List<Task> result = [];
      for (List<dynamic> d in response.data) {
        result.add(Task(
          taskid: d[0] as int,
          title: d[1] as String,
          completed: d[2] as bool,
        ));
      }
      return result;
    } catch (e) {
      return Future.error('Ошибка при обращении к базе данных.');
    }
  }
}

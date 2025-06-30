import 'package:postgres_dart/postgres_dart.dart' as pg;

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
      required this.report});
  int taskid;
  String title;
  String description;
  pg.PgPoint coordinates;
  bool completed;
  String? report;
}

/// The model with all tasks.
///
/// @param [db] is the geosurveys database.
/// {@category Models}
class TasksModel {
  TasksModel({required this.db}) {
    tasks = getTasks();
  }
  final pg.PostgresDb db;
  late Future<List<Task>> tasks;

  Future<List<Task>> getTasks() async {
    pg.DbResponse response;
    try {
      response = await db.table('task').select(columns: [
        pg.Column('taskid'),
        pg.Column('title'),
        pg.Column('description'),
        pg.Column('coordinates'),
        pg.Column('completed'),
        pg.Column('report')
      ]);
    } catch (e) {
      return Future.error('Ошибка при обращении к базе данных.');
    }

    List<Task> result = [];
    for (List<dynamic> d in response.data) {
      result.add(Task(
          taskid: d[0] as int,
          title: d[1] as String,
          description: d[2] as String,
          coordinates: d[3] as pg.PgPoint,
          completed: d[4] as bool,
          report: d[5] as String?));
    }

    return result;
  }
}

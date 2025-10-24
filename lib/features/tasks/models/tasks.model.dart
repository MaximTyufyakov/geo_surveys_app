import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geo_surveys_app/features/tasks/models/base_task.model.dart';
import 'package:postgres_dart/postgres_dart.dart';

/// A model with all tasks.
///
/// The [tasks] parameter is the list of tasks from database.
class TasksModel {
  /// Private constructor
  TasksModel._create({
    required this.tasks,
  });

  /// The list of tasks from database.
  final List<BaseTaskModel> tasks;

  /// Public factory.
  /// Retrieves all tasks from the database.
  ///
  /// The [userid] parameter is the user ID.
  ///
  /// Returns a [Future] that completes when the response is successful.
  /// Throws a [Future.error] with [String] message if database fails.
  static Future<TasksModel> create(int userid) async {
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

      DbResponse utResponse = await geosurveysDb.table('user_task').select(
        columns: [
          Column('taskid'),
        ],
        where: Where(
          'userid',
          WhereOperator.isEqual,
          userid,
        ),
      );
      List<BaseTaskModel> tasksList = [];
      for (List<dynamic> d in utResponse.data) {
        DbResponse tResponse = await geosurveysDb.table('task').select(
          columns: [
            Column('taskid'),
            Column('title'),
            Column('completed'),
          ],
          where: Where(
            'taskid',
            WhereOperator.isEqual,
            d[0] as int,
          ),
        );
        tasksList.add(BaseTaskModel(
          taskid: tResponse.data[0][0] as int,
          title: tResponse.data[0][1] as String,
          completed: tResponse.data[0][2] as bool,
          userid: userid,
        ));
      }

      TasksModel component = TasksModel._create(
        tasks: tasksList,
      );

      return component;
    } catch (e) {
      return Future.error('Ошибка при обращении к базе данных.');
    }
  }
}

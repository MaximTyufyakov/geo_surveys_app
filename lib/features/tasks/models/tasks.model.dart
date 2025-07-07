import 'package:geo_surveys_app/common/models/db.model.dart';
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
  /// Returns a [Future] that completes when the response is successful.
  /// Throws a [Future.error] with [String] message if database fails.
  static Future<TasksModel> create(int userid) async {
    try {
      if (DbModel.geosurveysDb.db.isClosed) {
        await DbModel.geosurveysDb.open();
      }

      DbResponse utResponse =
          await DbModel.geosurveysDb.table('user_task').select(
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
        DbResponse tResponse = await DbModel.geosurveysDb.table('task').select(
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

// class Task{
//   Task({required this.taskid});
//   BigInt taskid;
//   String title;
//   String desription;
//   Po coordinates
// }

import 'package:postgres_dart/postgres_dart.dart' as pg;

/// The model with all tasks.
///
/// @param [db] is the geosurveys database.
/// {@category Models}
class AllTasksModel {
  const AllTasksModel({required this.db});
  final pg.PostgresDb db;
}

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

/// The task's point model.
///
/// {@category Models}
class Point {
  Point({
    required this.pointid,
    required this.taskid,
    required this.number,
    required this.description,
    required this.completed,
  });
  int pointid;
  int taskid;
  int number;
  String description;
  bool completed;
}

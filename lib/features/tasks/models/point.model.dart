/// The task point model.
///
/// The [pointid] parameter is the point identifier.
/// The [taskid] parameter is the task identifier (parent element).
/// The [number] parameter is the point number in the task.
/// The [description] parameter is the text point description.
/// The [completed] parameter is the completed flag.
class Point {
  Point({
    required this.pointid,
    required this.taskid,
    required this.number,
    required this.description,
    required this.completed,
  });

  /// The point identifier.
  int pointid;

  /// The task identifier (parent element).
  int taskid;

  /// The point number in the task.
  int number;

  /// The text point description.
  String description;

  /// The completed flag.
  bool completed;
}

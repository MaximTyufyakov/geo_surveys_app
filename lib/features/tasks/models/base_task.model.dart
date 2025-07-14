/// A class with basic information of the task.
///
/// The [taskid] parameter is the task identifier.
/// The [title] parameter is the task name.
/// The [completed] parameter is the completed flag.
class BaseTaskModel {
  BaseTaskModel({
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

  /// Update completed flag if it is not null.
  ///
  /// The [flag] parameter is the completed flag.
  void completedUpdate(bool? flag) {
    flag == null ? null : completed = completed;
  }
}

/// A class with basic information of the task.
///
/// The [taskid] parameter is the task identifier.
/// The [title] parameter is the task name.
/// The [completed] parameter is the completed flag.
class BaseTaskModel {
  BaseTaskModel._({
    required this.taskid,
    required this.title,
    required this.completed,
  });

  /// Constructor with parse from json.
  ///
  /// Param [json] is target object.
  factory BaseTaskModel.fromJson(Map<String, dynamic> json) => BaseTaskModel._(
    taskid: json['task_id'] as int,
    title: json['title'] as String,
    completed: json['completed'] as bool,
  );

  /// The task identifier.
  int taskid;

  /// The task name.
  String title;

  /// The completed flag.
  bool completed;
}

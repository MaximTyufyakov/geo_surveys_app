/// The task point model.
///
/// The [parent] parameter is the task.
/// The [pointid] parameter is the point identifier.
/// The [number] parameter is the point number in the task.
/// The [description] parameter is the text point description.
/// The [completed] parameter is the completed flag.
class PointModel {
  PointModel._({
    required this.pointid,
    required this.number,
    required this.description,
    required this.completed,
  });

  factory PointModel.fromJson(Map<String, dynamic> json) => PointModel._(
    pointid: json['point_id'] as int,
    number: json['number'] as int,
    description: json['description'] as String,
    completed: json['completed'] as bool,
  );

  /// The point identifier.
  int pointid;

  /// The point number in the task.
  int number;

  /// The text point description.
  String description;

  /// The completed flag.
  bool completed;

  Map<String, dynamic> toJson() => {
    'point_id': pointid,
    'number': number,
    'description': description,
    'completed': completed,
  };

  /// Update this point.
  ///
  /// Param [copy] is new model.
  void copyWith({required PointModel copy}) {
    number = copy.number;
    description = copy.description;
    completed = copy.completed;
  }
}

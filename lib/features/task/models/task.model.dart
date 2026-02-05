import 'package:geo_surveys_app/common/models/base_task.model.dart';
import 'package:geo_surveys_app/features/task/models/point.model.dart';
import 'package:geo_surveys_app/features/task/models/video.model.dart';

/// The task model.
///
/// The [taskid] parameter is the task identifier.
/// The [title] parameter is the task name.
/// The [description] parameter is the text task description.
/// The [completed] parameter is the completed flag.
/// The [report] parameter is the report model.
/// The [points] parameter is the list of points that need to be completed.
/// The [saved] parameter is the saved flag.
class TaskModel extends BaseTaskModel {
  /// Private constructor.
  TaskModel._({
    required super.taskid,
    required super.title,
    required this.description,
    required super.coordinates,
    required super.completed,
    required this.points,
    required this.saved,
    required this.report,
    required this.videos,
  });

  /// Parse task from json to TaskModel.
  ///
  /// The [json] parameter is the target object.
  /// Returns a [TaskModel].
  factory TaskModel.fromJson(Map<String, dynamic> json) {
    /// Base part.
    final baseTask = BaseTaskModel.fromJson(json);
    return TaskModel._(
      taskid: baseTask.taskid,
      completed: baseTask.completed,
      coordinates: baseTask.coordinates,
      title: baseTask.title,
      description: json['description'] as String?,
      report: json['report'] as String? ?? '',
      saved: true,
      points: (json['points'] as List<dynamic>)
          .map((point) => PointModel.fromJson(point as Map<String, dynamic>))
          .toList(),
      videos: (json['videos'] as List<dynamic>)
          .map((video) => VideoModel.fromJson(video as Map<String, dynamic>))
          .toList(),
    );
  }

  /// The text task description.
  String? description;

  /// The text that the user writes (optional).
  String report;

  /// The list of points that need to be completed.
  final List<PointModel> points;

  /// The list of videos.
  final List<VideoModel> videos;

  /// The list of deleted videos id.
  final List<int> deletedVideosId = [];

  /// The saved flag.
  bool saved;

  /// Update this task.
  ///
  /// Param [copy] is new model.
  void copyWith({required TaskModel copy}) {
    title = copy.title;
    description = copy.description;
    coordinates = copy.coordinates;
    completed = copy.completed;
    report = copy.report;

    _updatePoints(newPoints: copy.points);
    _updateVideos(newVideos: copy.videos);

    deletedVideosId
      ..clear()
      ..addAll(copy.deletedVideosId);

    saved = copy.saved;
  }

  /// Update points list.
  void _updatePoints({required List<PointModel> newPoints}) {
    /// Create map {pointid: point}.
    final Map<int, PointModel> newPointsMap = {
      for (final point in newPoints) point.pointid: point,
    };

    /// Update exist.
    for (final point in points) {
      final updatedPoint = newPointsMap[point.pointid];
      if (updatedPoint != null) {
        point.copyWith(copy: updatedPoint);
        newPointsMap.remove(point.pointid);
      }
    }

    /// Add new.
    points.addAll(newPointsMap.values);

    /// Delete.
    final newPointIds = newPoints.map((p) => p.pointid).toSet();
    points.removeWhere((p) => !newPointIds.contains(p.pointid));
  }

  /// Update videos list.
  void _updateVideos({required List<VideoModel> newVideos}) {
    /// Create map {videoid: video}.
    final Map<int?, VideoModel> newVideosMap = {
      for (final video in newVideos) video.videoid: video,
    };

    // Обновляем существующие
    for (final video in videos) {
      final updatedVideo = newVideosMap[video.videoid];
      if (updatedVideo != null) {
        video.copyWith(updatedVideo);
        newVideosMap.remove(video.videoid);
      }
    }

    for (final newVideo in newVideosMap.values) {
      videos.add(newVideo);
    }

    // Удаляем те, которых нет в новых данных
    final newVideoIds = newVideos.map((v) => v.videoid).toSet();
    videos.removeWhere((v) => !newVideoIds.contains(v.videoid));
  }
}

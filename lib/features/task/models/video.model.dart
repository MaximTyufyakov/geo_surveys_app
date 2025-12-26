import 'dart:io';

/// The video model.
///
/// The [parent] parameter is the task.
/// The [videoid] parameter is the video identifier.
/// The [title] parameter is the video name.
/// The [url] parameter is the video url in cloud.
class VideoModel {
  VideoModel({
    required this.videoid,
    required this.title,
    required this.file,
    required this.latitude,
    required this.longitude,
  }) : format = file?.path.split('.').last;

  factory VideoModel.fromJson(Map<String, dynamic> json) => VideoModel(
    videoid: json['video_id'] as int,
    title: json['title'] as String,
    file: null,
    latitude: (json['latitude'] as num).toDouble(),
    longitude: (json['longitude'] as num).toDouble(),
  );

  /// The video identifier.
  final int? videoid;

  /// The video name.
  String title;

  /// The video format.
  final String? format;

  /// Local video file.
  File? file;

  /// Start geographic latitude.
  double latitude;

  /// Start geographic longitude.
  double longitude;

  /// Update this video.
  ///
  /// Param [copy] is new model.
  void copyWith(VideoModel copy) {
    title = copy.title;
    latitude = copy.latitude;
    longitude = copy.longitude;
    file = copy.file;
  }
}

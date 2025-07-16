import 'package:flutter/material.dart';
import 'package:geo_surveys_app/features/task/models/video.model.dart';

/// A ViewModel of the video.
class VideoCardViewModel extends ChangeNotifier {
  VideoCardViewModel({
    required this.model,
    required this.videosUpd,
  });

  /// Model with video.
  final VideoModel model;

  /// Update VideosWiddget.
  final void Function() videosUpd;

  /// When delete button click
  void delete() {
    model.deleteFromTask();
    videosUpd();
  }
}

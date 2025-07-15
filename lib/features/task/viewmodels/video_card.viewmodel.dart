import 'package:flutter/material.dart';
import 'package:geo_surveys_app/features/task/models/video.model.dart';

/// A ViewModel of the video.
class VideoCardViewModel extends ChangeNotifier {
  VideoCardViewModel({
    required this.model,
  });

  /// Model with video.
  final VideoModel model;
}

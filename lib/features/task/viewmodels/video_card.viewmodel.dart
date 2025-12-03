import 'package:flutter/material.dart';
import 'package:geo_surveys_app/features/task/models/video.model.dart';

/// A ViewModel of the video.
class VideoCardViewModel extends ChangeNotifier {
  VideoCardViewModel({
    required this.model,
    required this.videosUpd,
    required this.deleteDialog,
  });

  /// Model with video.
  final VideoModel model;

  final ValueGetter<Future<bool?>> deleteDialog;

  /// Update VideosWiddget.
  final void Function() videosUpd;

  /// When delete button click
  void delete() async {
    await deleteDialog().then((del) {
      if (del == true) {
        model.deleteFromTask();
        videosUpd();
      }
    });
  }
}

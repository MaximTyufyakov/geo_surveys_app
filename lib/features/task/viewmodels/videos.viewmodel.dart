import 'dart:collection';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geo_surveys_app/features/task/models/task.model.dart';
import 'package:geo_surveys_app/features/task/models/video.model.dart';

/// A ViewModel of the video.
class VideosViewModel extends ChangeNotifier {
  VideosViewModel({
    required this.model,
    required this.errorDialog,
    required this.openVideoShootPage,
  });

  /// Task model.
  final TaskModel model;

  /// New title controller.
  final TextEditingController newTitleController = TextEditingController(
    text: '',
  );

  /// Show error.
  final ValueSetter<List<String>> errorDialog;

  final ValueGetter<Future<File?>> openVideoShootPage;

  @override
  void notifyListeners() {
    super.notifyListeners();
  }

  /// Open page with camera and add new video in the list.
  void videoCreate() async {
    // Without front and back spaces.
    String title = newTitleController.text.trim();

    // The title does not exist.
    if (title == '') {
      errorDialog(const ['Название видео пустое.']);
      return;

      // The title does not unique.
    } else if (!uniqueTitle(title)) {
      errorDialog(const ['Название видео не уникально.']);
      return;

      // The title exist and unique.
    } else {
      final File? videoFile = await openVideoShootPage();

      // The video returned.
      if (videoFile != null) {
        final VideoModel video = VideoModel(
          videoid: null,
          title: title,
          file: videoFile,
        );
        model.addVideo(video);
        notifyListeners();
      }
    }
  }

  /// Check unique video title.
  ///
  /// Param [title] is new title.
  /// Returns true if unique.
  bool uniqueTitle(String title) {
    HashSet<String> hashSet = HashSet<String>()
      ..addAll(model.videos.map((video) => video.title).toSet());
    return !hashSet.contains(title);
  }
}

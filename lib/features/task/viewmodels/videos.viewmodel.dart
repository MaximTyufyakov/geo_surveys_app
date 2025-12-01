import 'dart:collection';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geo_surveys_app/common/widgets/dialogs/abstract_dialog.widget.dart';
import 'package:geo_surveys_app/features/task/models/task.model.dart';
import 'package:geo_surveys_app/features/task/models/video.model.dart';

/// A ViewModel of the video.
class VideosViewModel extends ChangeNotifier {
  VideosViewModel({
    required this.model,
  });

  /// Task model.
  final TaskModel model;

  /// New title controller.
  final TextEditingController newTitleController = TextEditingController(
    text: '',
  );

  @override
  void notifyListeners() {
    super.notifyListeners();
  }

  /// Open page with camera and add new video in the list.
  void videoCreate(BuildContext context) async {
    // Without front and back spaces.
    String title = newTitleController.text.trim();

    // The title does not exist.
    if (title == '') {
      await showDialog<bool>(
        context: context,
        builder: (context) => AbstractDialog(
          title: 'Ошибка',
          content: const Text('Название видео пустое.'),
          greenTitle: 'Ок',
          redTitle: null,
        ),
      );
      return;

      // The title does not unique.
    } else if (!uniqueTitle(title)) {
      await showDialog<bool>(
        context: context,
        builder: (context) => AbstractDialog(
          title: 'Ошибка',
          content: const Text('Название видео не уникально.'),
          greenTitle: 'Ок',
          redTitle: null,
        ),
      );
      return;

      // The title exist and unique.
    } else {
      final File? videoFile = await Navigator.pushNamed(
        context,
        '/video_shoot',
      ) as File?;

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

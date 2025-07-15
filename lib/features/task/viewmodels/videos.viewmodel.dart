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

  void videoCreate(BuildContext context) async {
    if (newTitleController.text == '') {
      await showDialog<bool>(
        context: context,
        builder: (context) => AbstractDialog(
          title: 'Ошибка',
          content: const Text('Название видео не введено.'),
          greenTitle: 'Ок',
          redTitle: null,
        ),
      );
      return;
    } else {
      final File? video = await Navigator.pushNamed(
        context,
        '/video_shoot',
      ) as File?;
      if (video != null) {
        model.addVideo(
          VideoModel(
              videoid: null,
              title: newTitleController.text,
              url: null,
              file: video),
        );
      }
    }
  }
}

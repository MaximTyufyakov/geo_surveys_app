import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geo_surveys_app/common/widgets/dialogs/text_dialog.widget.dart';
import 'package:geo_surveys_app/features/task/models/task.model.dart';
import 'package:geo_surveys_app/features/task/models/video.model.dart';
import 'package:geo_surveys_app/features/task/viewmodels/videos.viewmodel.dart';
import 'package:geo_surveys_app/features/task/widgets/video_card.widget.dart';
import 'package:geo_surveys_app/features/video_shoot/pages/video_shoot.page.dart';
import 'package:provider/provider.dart';

/// A widget with task videos.
class VideosWidget extends StatelessWidget {
  const VideosWidget({
    super.key,
    required this.task,
  });

  final TaskModel task;

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider<VideosViewModel>(
        create: (BuildContext context) => VideosViewModel(
          model: task,
          errorDialog: (text) async => await showDialog<bool>(
            context: context,
            builder: (context) => TextDialog(
              title: 'Ошибка',
              text: text,
              greenTitle: 'Ок',
              redTitle: null,
            ),
          ),
          openVideoShootPage: () async => await Navigator.of(context).push(
            MaterialPageRoute<VideoShootPage>(
              builder: (context) => const VideoShootPage(),
            ),
          ) as File?,
        ),
        child: Consumer<VideosViewModel>(
          builder: (context, provider, child) {
            /// Video cards.
            final List<Widget> videoCards = [];
            for (VideoModel video in provider.model.videos) {
              videoCards.add(
                VideoCardWidget(
                  video: video,
                  videosUpd: provider.notifyListeners,
                  key: UniqueKey(),
                ),
              );
            }
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: videoCards,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(
                          hintText: 'Название видео',
                        ),
                        controller: provider.newTitleController,
                        maxLines: 1,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        provider.videoCreate();
                      },
                      icon: const Icon(Icons.add_a_photo),
                      color: Colors.lightGreen[500],
                      iconSize: 30,
                    ),
                  ],
                )
              ],
            );
          },
        ),
      );
}

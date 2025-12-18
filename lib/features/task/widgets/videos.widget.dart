import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geo_surveys_app/common/widgets/dialogs/future_dialog.widget.dart';
import 'package:geo_surveys_app/common/widgets/dialogs/text_dialog.widget.dart';
import 'package:geo_surveys_app/common/widgets/message.widget.dart';
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
          errorDialog: (text) => showDialog<bool>(
            context: context,
            builder: (context) => TextDialog(
              title: 'Ошибка',
              text: text,
              greenTitle: 'Ок',
              redTitle: null,
            ),
          ),
          openVideoShootPage: () => Navigator.of(context).push(
            MaterialPageRoute<File>(
              builder: (context) => const VideoShootPage(),
            ),
          ),
          geolocationDialog: (Future<List<String>> futureText) =>
              showDialog<bool>(
            context: context,
            builder: (context) => FutureDialog(
              futureText: futureText,
              title: 'Определение местоположения',
              greenTitle: 'Ок',
              redTitle: null,
            ),
          ),
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
            return Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: videoCards.isEmpty
                            ? [
                                const MessageWidget(
                                  mes: 'Нет видео.',
                                  icon: Icons.video_library,
                                )
                              ]
                            : videoCards,
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
              ),
            );
          },
        ),
      );
}

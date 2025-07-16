import 'package:flutter/material.dart';
import 'package:geo_surveys_app/features/task/models/task.model.dart';
import 'package:geo_surveys_app/features/task/models/video.model.dart';
import 'package:geo_surveys_app/features/task/viewmodels/videos.viewmodel.dart';
import 'package:geo_surveys_app/features/task/widgets/video_card.widget.dart';
import 'package:provider/provider.dart';

/// A widget with task photos.
class VideosWidget extends StatelessWidget {
  VideosWidget({
    super.key,
    required TaskModel task,
  }) : provider = VideosViewModel(model: task);

  /// Videos ViewModel.
  final VideosViewModel provider;

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider<VideosViewModel>(
        create: (BuildContext context) => provider,
        child: Consumer<VideosViewModel>(
          builder: (context, provider, child) {
            /// Video cards.
            final List<Widget> videoCards = [];
            for (VideoModel video in provider.model.videos) {
              videoCards.add(
                VideoCardWidget(
                  video: video,
                  videosUpd: provider.notifyListeners,
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
                        provider.videoCreate(context);
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

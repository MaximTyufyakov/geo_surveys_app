import 'package:flutter/material.dart';
import 'package:geo_surveys_app/common/widgets/scroll_message.widget.dart';
import 'package:geo_surveys_app/features/task/models/video.model.dart';
import 'package:geo_surveys_app/features/task/widgets/video_card.widget.dart';

/// A widget with task videos.
class VideosWidget extends StatelessWidget {
  VideosWidget({
    super.key,
    required this.videos,
    required this.onVideoDelete,
    required this.onVideoAdd,
  });

  /// Model.
  final List<VideoModel> videos;

  /// On video delete action.
  final ValueSetter<VideoModel> onVideoDelete;

  /// On video add action.
  final ValueSetter<String> onVideoAdd;

  final TextEditingController newTitleController = TextEditingController(
    text: '',
  );

  @override
  Widget build(BuildContext context) {
    /// Video cards.
    final List<Widget> videoCards = [];
    for (final VideoModel video in videos) {
      videoCards.add(
        VideoCardWidget(
          video: video,
          onVideoDelete: () => onVideoDelete(video),
          key: UniqueKey(),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Expanded(
            child: videoCards.isEmpty
                ? const ScrollMessageWidget(
                    mes: 'Нет видео.',
                    icon: Icons.video_library,
                  )
                : ListView(children: videoCards),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(hintText: 'Название видео'),
                  controller: newTitleController,

                  /// Unfocus.
                  onTapOutside: (event) => FocusScope.of(context).unfocus(),
                ),
              ),
              IconButton(
                onPressed: () => onVideoAdd(newTitleController.text),
                icon: const Icon(Icons.add_a_photo),
                color: Colors.lightGreen[400],
                iconSize: 30,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

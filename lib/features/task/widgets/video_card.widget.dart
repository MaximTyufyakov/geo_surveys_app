import 'package:flutter/material.dart';
import 'package:geo_surveys_app/features/task/models/video.model.dart';
import 'package:geo_surveys_app/features/task/viewmodels/video_card.viewmodel.dart';
import 'package:provider/provider.dart';

/// A widget with task photo card.
class VideoCardWidget extends StatelessWidget {
  VideoCardWidget({
    super.key,
    required VideoModel video,
    required void Function() videosUpd,
  }) : provider = VideoCardViewModel(
          model: video,
          videosUpd: videosUpd,
        );

  final VideoCardViewModel provider;

  @override
  Widget build(BuildContext context) =>
      ChangeNotifierProvider<VideoCardViewModel>(
        create: (BuildContext context) => provider,
        child: Consumer<VideoCardViewModel>(
          builder: (context, provider, child) => Card(
            child: Row(
              children: [
                Expanded(
                  child: ListTile(
                    title: Text(
                      provider.model.title,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    provider.delete();
                  },
                  icon: const Icon(Icons.delete),
                  color: Colors.red[400],
                ),
              ],
            ),
          ),
        ),
      );
}

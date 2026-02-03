import 'package:flutter/material.dart';
import 'package:geo_surveys_app/features/task/models/video.model.dart';

/// A widget with task photo card.
class VideoCardWidget extends StatelessWidget {
  const VideoCardWidget({
    super.key,
    required this.video,
    required this.onVideoDelete,
  });

  /// Model.
  final VideoModel video;

  /// On video delete action.
  final VoidCallback onVideoDelete;

  @override
  Widget build(BuildContext context) => Card(
    child: Row(
      children: [
        Expanded(
          child: ListTile(
            title: SelectableText(
              video.title,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SelectableText(
                  '''${video.latitude}, ${video.longitude}''',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ),
        IconButton(
          onPressed: onVideoDelete,
          icon: const Icon(Icons.delete),
          color: Colors.red[400],
        ),
      ],
    ),
  );
}

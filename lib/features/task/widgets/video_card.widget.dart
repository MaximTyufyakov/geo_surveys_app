import 'package:flutter/material.dart';
import 'package:geo_surveys_app/common/widgets/dialogs/text_dialog.widget.dart';
import 'package:geo_surveys_app/features/task/models/video.model.dart';
import 'package:geo_surveys_app/features/task/viewmodels/video_card.viewmodel.dart';
import 'package:provider/provider.dart';

/// A widget with task photo card.
class VideoCardWidget extends StatelessWidget {
  const VideoCardWidget({
    super.key,
    required this.video,
    required this.videosUpd,
  });

  final VideoModel video;

  final VoidCallback videosUpd;

  @override
  Widget build(BuildContext context) =>
      ChangeNotifierProvider<VideoCardViewModel>(
        create: (BuildContext context) => VideoCardViewModel(
          model: video,
          videosUpd: videosUpd,
          deleteDialog: () => showDialog<bool>(
            context: context,
            builder: (context) => TextDialog(
                title: 'Удаление видео',
                text: const ['Вы уверены?'],
                greenTitle: 'Да',
                redTitle: 'Нет'),
          ),
        ),
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

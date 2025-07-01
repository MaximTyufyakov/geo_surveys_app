import 'package:flutter/material.dart';
import 'package:geo_surveys_app/common/widgets/message.widget.dart';

/// A widget with task's photos.
///
/// {@category Widgets}
class PhotosWidget extends StatelessWidget {
  const PhotosWidget({super.key});

  @override
  Widget build(BuildContext context) =>
      const MessageWidget(mes: 'Здесь будут фотографии.');
}

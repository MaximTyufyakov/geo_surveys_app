import 'package:flutter/material.dart';
import 'package:geo_surveys_app/common/widgets/dialogs/abstract_dialog.widget.dart';

/// Dialog with message.
///
/// The [text] parameter is the content (Strings) of the dialog.
class TextDialog extends AbstractDialog {
  TextDialog({
    super.key,
    required super.title,
    required this.text,
    required super.greenTitle,
    required super.redTitle,
  }) : super(
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: text.map(Text.new).toList(),
          ),
        );

  final List<String> text;
}

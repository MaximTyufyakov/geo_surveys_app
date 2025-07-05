import 'package:flutter/material.dart';

/// Dialog with a choice between two actions.
/// Returns true when GreenBtn is clicked.
/// Returns false when RedBtn is clicked.
/// If title is null, there will be no button.
///
/// The [title] parameter is a dialog name.
/// The [messages] parameter is the content of the dialog.
/// The [greenTitle] parameter is the title of the green button.
/// The [redTitle] parameter is the title of the red button.
///
/// Throws an ArgumentError when both titles is null.
class ChoiceDialog extends StatelessWidget {
  ChoiceDialog(
      {super.key,
      required this.title,
      required this.messages,
      required this.greenTitle,
      required this.redTitle});

  /// Dialog name.
  final String title;

  /// Content of the dialog.
  final List<String> messages;

  /// Title of the green button.
  final String? greenTitle;

  /// Title of the red button.
  final String? redTitle;

  /// A List with buttons (buttons adds in the widget build).
  final List<FilledButton> buttons = [];

  @override
  Widget build(BuildContext context) {
    if (greenTitle == null && redTitle == null) {
      throw ArgumentError(
        'redTitle and greenTitle cannot be null at the same time',
        'ChoiceDialog Error',
      );
    }
    if (greenTitle != null) {
      buttons.add(
        FilledButton(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(
              Colors.lightGreen[200],
            ),
          ),
          child: Text(greenTitle!),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
      );
    }
    if (redTitle != null) {
      buttons.add(
        FilledButton(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(
              Colors.red[200],
            ),
          ),
          child: Text(redTitle!),
          onPressed: () {
            Navigator.pop(context, false);
          },
        ),
      );
    }
    List<Text> contentList = [];
    for (String text in messages) {
      contentList.add(
        Text(text),
      );
    }

    return AlertDialog(
      title: Text(title),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: contentList,
        ),
      ),
      actions: buttons,
    );
  }
}

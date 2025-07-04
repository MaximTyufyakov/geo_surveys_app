import 'package:flutter/material.dart';

// Диалог с возможностью выбора между двумя действиями
// Возвращает true при нажатии на GreenBtn
// false при нажатии на RedBtn
// Если title == null, кнопки не будет
class ChoiceDialog extends StatelessWidget {
  ChoiceDialog(
      {super.key,
      required this.title,
      required this.contentList,
      required this.greenTitle,
      required this.redTitle});
  final String title;
  final List<Widget> contentList;
  final String? greenTitle;
  final String? redTitle;
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

import 'package:flutter/material.dart';

// Диалог, требующий выбора между двумя действиями
// Возвращает true при нажатии на GreenBtn
// false при нажатии на RedBtn
class ChoiceDialogWidget extends StatelessWidget {
  const ChoiceDialogWidget(
      {super.key,
      required this.title,
      required this.contentList,
      required this.greenTitle,
      required this.redTitle});
  final String title;
  final List<Widget> contentList;
  final String greenTitle;
  final String redTitle;

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: contentList,
          ),
        ),
        actions: <Widget>[
          // Кнопка
          FilledButton(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(
                Colors.lightGreen[300],
              ),
            ),
            child: Text(greenTitle),
            onPressed: () {
              Navigator.pop(context, true);
            },
          ),
          FilledButton(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(
                Colors.red[300],
              ),
            ),
            child: Text(redTitle),
            onPressed: () {
              Navigator.pop(context, false);
            },
          ),
        ],
      );
}

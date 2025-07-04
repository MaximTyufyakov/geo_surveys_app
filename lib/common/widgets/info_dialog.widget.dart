import 'package:flutter/material.dart';

// Информационный диалог с массивом виджетов-сообщений
class InfoDialogWidget extends StatelessWidget {
  const InfoDialogWidget(
      {super.key, required this.title, required this.contentList});

  final String title;
  final List<Widget> contentList;

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
            child: const Text('OK'),
            onPressed: () {
              Navigator.pop(context, true);
            },
          ),
        ],
      );
}

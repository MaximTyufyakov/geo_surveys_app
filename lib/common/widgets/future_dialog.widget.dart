import 'package:flutter/material.dart';

// Информационный диалог с массивом виджетов-сообщений
class FutureDialog extends StatefulWidget {
  const FutureDialog(
      {super.key, required this.title, required this.contentList});
  final String title;
  final Future<List<Widget>> contentList;
  @override
  State<StatefulWidget> createState() => _FutureDialogState();
}

class _FutureDialogState extends State<FutureDialog> {
  onPressed
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

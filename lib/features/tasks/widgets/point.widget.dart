import 'package:flutter/material.dart';
import 'package:geo_surveys_app/features/tasks/models/point.model.dart';

// Один чек бокс с текстом справа
class PointWidget extends StatefulWidget {
  const PointWidget({
    super.key,
    required this.point,
  });

  final Point point;

  @override
  createState() => PointWidgetState();
}

class PointWidgetState extends State<PointWidget> {
  // Контролер поля ввода
  late TextEditingController textController;

  @override
  Widget build(BuildContext context) {
    textController = TextEditingController(text: widget.point.description);
    return Column(
      children: [
        Row(
          children: [
            // Номер вопроса
            Text('${widget.point.number}.',
                style: Theme.of(context).textTheme.bodyMedium),
            // Чек бокс
            Checkbox(
                value: widget.point.completed,
                onChanged: (onChanged) async {
                  // widget.controller.onCheck(widget.answerVariant, onChanged!);
                }),

            // Растягивающийся вариант ответа
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SelectableText(widget.point.description,
                      style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),
          ],
        ),
        const Divider(
          color: Colors.black26,
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:geo_surveys_app/features/task/models/point.model.dart';
import 'package:geo_surveys_app/features/task/models/task.model.dart';
import 'package:geo_surveys_app/features/task/widgets/point.widget.dart';

/// A widget with task information.
/// The [task] parameter is a model with task information.
class TaskWidget extends StatelessWidget {
  const TaskWidget({super.key, required this.task});

  /// Model with task information.
  final TaskModel task;

  @override
  Widget build(BuildContext context) {
    List<Widget> pointsCards = [];
    for (PointModel point in task.points) {
      pointsCards.add(
        PointWidget(
          point: point,
        ),
      );
    }
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
              SelectableText(
                task.title,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                'Описание',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Divider(
                color: Theme.of(context).primaryColorDark,
              ),
              SelectableText(
                task.description,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                'Ход работы',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Divider(
                color: Theme.of(context).primaryColorDark,
              )
            ] +
            pointsCards,
      ),
    );
  }
}

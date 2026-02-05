import 'package:flutter/material.dart';
import 'package:geo_surveys_app/common/models/base_task.model.dart';

/// The task card.
///
/// The [task] parameter is the simple task model.
/// The [onCardTap] parameter is on card tap action.
class TaskCard extends StatelessWidget {
  const TaskCard({super.key, required this.task, required this.onCardTap});

  final BaseTaskModel task;
  final VoidCallback onCardTap;

  @override
  Widget build(BuildContext context) => Card(
    /// To click.
    child: InkWell(
      onTap: onCardTap,

      /// Content.
      /// ListTile with a title and completed text.
      child: ListTile(
        title: Text(task.title, style: Theme.of(context).textTheme.bodyMedium),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (task.completed)
              Text(
                'Завершено',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall!.copyWith(color: Colors.green),
              )
            else
              Text(
                'Не завершено',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall!.copyWith(color: Colors.red),
              ),
          ],
        ),
      ),
    ),
  );
}

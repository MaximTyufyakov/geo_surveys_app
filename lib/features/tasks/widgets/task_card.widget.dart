import 'package:flutter/material.dart';
import 'package:geo_surveys_app/features/tasks/controllers/tasks.provider.dart';
import 'package:geo_surveys_app/features/tasks/models/base_task.model.dart';

/// The task card.
///
/// The [task] parameter is the simple task model.
/// The [provider] parameter is the tasks provider.
class TaskCard extends StatelessWidget {
  const TaskCard({super.key, required this.task, required this.provider});

  final BaseTaskModel task;
  final TasksProvider provider;

  @override
  Widget build(BuildContext context) => Card(
    /// To click.
    child: InkWell(
      onTap: () => provider.openTask(task),

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

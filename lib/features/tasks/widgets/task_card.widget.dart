import 'package:flutter/material.dart';
import 'package:geo_surveys_app/features/tasks/models/base_task.model.dart';
import 'package:geo_surveys_app/features/tasks/viewmodels/task_card.viewmodel.dart';
import 'package:provider/provider.dart';

/// The task card.
///
/// The [provider] parameter is the task card ViewModel.
class TaskCard extends StatelessWidget {
  TaskCard({super.key, required BaseTaskModel task})
      : provider = TaskCardViewModel(model: task);

  final TaskCardViewModel provider;

  @override
  Widget build(BuildContext context) =>
      ChangeNotifierProvider<TaskCardViewModel>(
        create: (BuildContext context) => provider,
        child: Consumer<TaskCardViewModel>(
          builder: (context, provider, child) => Card(
            /// To click.
            child: InkWell(
              onTap: () async {
                provider.openTask(context);
              },

              /// Content.
              /// ListTile with a title and completed text.
              child: ListTile(
                title: Text(
                  provider.model.title,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    provider.model.completed
                        ? Text('Завершено',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  color: Colors.green,
                                ))
                        : Text(
                            'Не завершено',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  color: Colors.red,
                                ),
                          ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}

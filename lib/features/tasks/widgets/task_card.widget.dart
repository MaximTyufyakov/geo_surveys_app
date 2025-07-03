import 'package:flutter/material.dart';
import 'package:geo_surveys_app/features/tasks/viewmodels/tasks.viewmodel.dart';
import 'package:geo_surveys_app/features/tasks/models/task.model.dart';

/// The task card.
///
/// The [task] parameter is the task model.
/// The [viewModel] parameter is the TasksPage ViewModel.
class TaskCard extends StatelessWidget {
  const TaskCard({super.key, required this.task, required this.viewModel});
  final Task task;
  final TasksViewModel viewModel;

  @override
  Widget build(BuildContext context) => Card(
        /// To click.
        child: InkWell(
          onTap: () async {
            viewModel.openTask();
          },

          /// Content.
          /// ListTile with a title and completed text.
          child: ListTile(
            title: Text(task.title),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                task.completed
                    ? Text('Завершено',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: Colors.green,
                            ))
                    : Text(
                        'Не завершено',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: Colors.red,
                            ),
                      ),
              ],
            ),
          ),
        ),
      );
}

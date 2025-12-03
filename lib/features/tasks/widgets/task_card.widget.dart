import 'package:flutter/material.dart';
import 'package:geo_surveys_app/features/task/pages/task.page.dart';
import 'package:geo_surveys_app/features/tasks/models/base_task.model.dart';
import 'package:geo_surveys_app/features/tasks/viewmodels/task_card.viewmodel.dart';
import 'package:provider/provider.dart';

/// The task card.
///
/// The [provider] parameter is the task card ViewModel.
class TaskCard extends StatelessWidget {
  const TaskCard({super.key, required this.task});

  final BaseTaskModel task;

  @override
  Widget build(BuildContext context) =>
      ChangeNotifierProvider<TaskCardViewModel>(
        create: (BuildContext context) => TaskCardViewModel(
          model: task,
          openTaskPage: () => Navigator.of(context).push(
            MaterialPageRoute<bool>(
              builder: (context) => TaskPage(
                taskid: task.taskid,
              ),
            ),
          ),
        ),
        child: Consumer<TaskCardViewModel>(
          builder: (context, provider, child) => Card(
            /// To click.
            child: InkWell(
              onTap: () {
                provider.openTask();
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

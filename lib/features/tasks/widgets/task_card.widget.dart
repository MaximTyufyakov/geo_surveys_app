import 'package:flutter/material.dart';
import 'package:geo_surveys_app/main.dart';
import 'package:geo_surveys_app/features/tasks/controllers/tasks.controller.dart';
import 'package:geo_surveys_app/features/tasks/models/task.model.dart';

/// The task card.
///
/// @param [task] is the task model.
/// @param [controller] is the task controller.
/// {@category Widgets}
class TaskCard extends StatelessWidget {
  const TaskCard({super.key, required this.task, required this.controller});
  final Task task;
  final TasksController controller;

  @override
  Widget build(BuildContext context) => Card(
        /// To click.
        child: InkWell(
          splashColor: MainApp.splashColor,
          onTap: () {
            // controller.editTest(test);
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
                              color: Colors.deepOrange,
                            ),
                      )
              ],
            ),
          ),
        ),
      );
}

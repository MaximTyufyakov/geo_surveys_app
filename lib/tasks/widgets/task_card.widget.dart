import 'package:flutter/material.dart';
import 'package:geo_surveys_app/main.dart';
import 'package:geo_surveys_app/tasks/controllers/tasks.controller.dart';
import 'package:geo_surveys_app/tasks/models/tasks.model.dart';

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
  Widget build(BuildContext context) {
    Text completeText;
    if (task.completed) {
      completeText = Text(
        'Завершено',
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: Colors.green,
            ),
      );
    } else {
      completeText = Text(
        'Не завершено',
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: Colors.deepOrange,
            ),
      );
    }
    return Card(
      child: InkWell(
        splashColor: MainApp.splashColor,
        onTap: () {
          // controller.editTest(test);
        },
        // Content
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ListTile(
              title: Text(task.title),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  completeText,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

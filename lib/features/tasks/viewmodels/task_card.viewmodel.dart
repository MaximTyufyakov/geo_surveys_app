import 'package:flutter/material.dart';
import 'package:geo_surveys_app/features/tasks/models/base_task.model.dart';

/// A ViewModel of the tasks page.
///
/// The [model] parameter is the task model.
class TaskCardViewModel extends ChangeNotifier {
  TaskCardViewModel({required this.model});

  /// Model with task.
  final BaseTaskModel model;

  /// Opens a page with information about task.
  ///
  ///  The [task] parameter is the tapped task.
  ///  The [context] parameter is the widget context.
  void openTask(BuildContext context) async {
    final bool? completed = await Navigator.pushNamed(
      context,
      '/task',
      arguments: {'taskid': model.taskid},
    ) as bool?;
    model.completedUpdate(completed);
    notifyListeners();
  }
}

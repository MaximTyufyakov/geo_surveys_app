import 'package:flutter/material.dart';
import 'package:geo_surveys_app/features/tasks/models/base_task.model.dart';
import 'package:geo_surveys_app/features/tasks/models/tasks.model.dart';

/// A ViewModel of the tasks page.
///
/// The [context] parameter is the context of the tasks page.
class TasksViewModel extends ChangeNotifier {
  TasksViewModel({required this.context}) : model = TasksModel.create();

  /// The context of the tasks page.
  final BuildContext context;

  /// Model with all tasks.
  final Future<TasksModel> model;

  /// Opens a page with information about task.
  ///
  ///  The [task] parameter is the tapped task.
  void openTask(BaseTaskModel task) async {
    final bool? completed = await Navigator.pushNamed(
      context,
      '/task',
      arguments: {'taskid': task.taskid},
    ) as bool?;

    completed == null ? null : task.completed = completed;

    notifyListeners();
  }

  /// Reload the tasks page.
  void reloadPage() async {
    await Navigator.popAndPushNamed(
      context,
      '/tasks',
    );
  }
}

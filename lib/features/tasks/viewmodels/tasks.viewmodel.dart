import 'package:flutter/material.dart';
import 'package:geo_surveys_app/features/tasks/models/task.model.dart';
import 'package:geo_surveys_app/features/tasks/models/tasks.model.dart';

/// A ViewModel of the tasks page.
///
/// The [context] parameter is the context of the tasks page.
class TasksViewModel extends ChangeNotifier {
  TasksViewModel({required this.context}) : model = TasksModel();

  /// The context of the tasks page.
  final BuildContext context;

  /// Model with all tasks.
  final TasksModel model;

  /// Opens a page with information about task.
  ///
  ///  The [task] parameter is the tapped task.
  void openTask(Task task) async {
    await Navigator.pushNamed(
      context,
      '/task',
      arguments: {'model': task},
    );
  }
}

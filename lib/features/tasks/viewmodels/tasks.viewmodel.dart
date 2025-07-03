import 'package:flutter/material.dart';
import 'package:geo_surveys_app/features/tasks/models/tasks.model.dart';

/// The controller of the tasksPage.
///
/// The [context] is the context of the tasks page.
class TasksViewModel extends ChangeNotifier {
  TasksViewModel({required this.context}) : model = TasksModel();

  /// The context of the tasks page.
  final BuildContext context;

  /// Model with all tasks.
  final TasksModel model;

  /// Opens a page with information about task.
  void openTask() async {
    await Navigator.pushNamed(context, '/task');
  }
}

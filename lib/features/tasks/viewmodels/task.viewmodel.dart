import 'package:flutter/material.dart';
import 'package:geo_surveys_app/features/tasks/models/task.model.dart';

/// The ViewModel of the taskPage.
///
/// The [context] is the context of the  task page.
class TaskViewModel extends ChangeNotifier {
  TaskViewModel({required this.context, required this.model});

  /// The context of the task page.
  final BuildContext context;

  /// Model with task.
  final Task model;

  // /// Opens a page with information about task.
  // void openTask() async {
  //   await Navigator.pushNamed(context, '/task');
  // }
}

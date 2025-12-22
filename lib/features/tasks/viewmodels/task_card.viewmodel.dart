import 'package:flutter/material.dart';
import 'package:geo_surveys_app/features/tasks/models/base_task.model.dart';

/// A ViewModel of the tasks page.
///
/// The [model] parameter is the task model.
class TaskCardViewModel extends ChangeNotifier {
  TaskCardViewModel({required this.model, required this.openTaskPage});

  /// Model with task.
  final BaseTaskModel model;

  /// Open task page.
  final ValueGetter<Future<bool?>> openTaskPage;

  /// Opens a page with information about task.
  Future<void> openTask() async {
    final bool? completed = await openTaskPage();
    model.completedUpdate(completed);
    notifyListeners();
  }
}

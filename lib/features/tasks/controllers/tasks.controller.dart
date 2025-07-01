import 'package:flutter/material.dart';
import 'package:geo_surveys_app/features/tasks/models/tasks.model.dart';

/// The controller of the tasksPage.
///
/// @param [context] is the context of the main page widget.
/// {@category Controllers}
class TasksController extends ChangeNotifier {
  TasksController({required this.context}) : tasksModel = TasksModel();
  final BuildContext context;

  // Models
  final TasksModel tasksModel;

  void openTask() async {
    await Navigator.pushNamed(context, '/task');
  }
}

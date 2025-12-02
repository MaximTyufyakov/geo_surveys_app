import 'package:flutter/material.dart';
import 'package:geo_surveys_app/features/tasks/models/tasks.model.dart';

/// A ViewModel of the tasks page.
class TasksViewModel extends ChangeNotifier {
  TasksViewModel() : model = TasksModel.create();

  /// Model with all tasks.
  final Future<TasksModel> model;
}

import 'package:flutter/material.dart';
import 'package:geo_surveys_app/features/tasks/models/tasks.model.dart';

/// A ViewModel of the tasks page.
class TasksViewModel extends ChangeNotifier {
  TasksViewModel() : model = TasksModel.create();

  /// Model with all tasks.
  Future<TasksModel> model;

  Future<void> reload() async {
    await model;
    model = TasksModel.create();
    notifyListeners();
  }
}

import 'package:flutter/material.dart';
import 'package:geo_surveys_app/common/api.dart';
import 'package:geo_surveys_app/features/tasks/models/tasks.model.dart';

/// A ViewModel of the tasks page.
class TasksViewModel extends ChangeNotifier {
  TasksViewModel({required this.goAuth}) : model = TasksModel.create();

  /// Model with all tasks.
  Future<TasksModel> model;

  /// Logout view.
  VoidCallback goAuth;

  /// Reload page.
  Future<void> reload() async {
    await model;
    model = TasksModel.create();
    notifyListeners();
  }

  /// Go to auth page with logout.
  void logout() {
    clearToken();
    goAuth();
  }
}

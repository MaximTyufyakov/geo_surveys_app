import 'package:flutter/material.dart';
import 'package:geo_surveys_app/features/task/models/task.model.dart';

/// A ViewModel of the task.
class TaskViewModel extends ChangeNotifier {
  TaskViewModel({
    required this.model,
  });

  /// Model with task.
  final TaskModel model;
}

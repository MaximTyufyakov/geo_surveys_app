import 'package:flutter/material.dart';
import 'package:geo_surveys_app/features/tasks/models/task.model.dart';

/// A ViewModel of the task page.
///
/// The [context] is the context of the task page.
class TaskViewModel extends ChangeNotifier {
  TaskViewModel({required this.context, required this.model})
      : reportController = TextEditingController(text: model.report);

  /// The context of the task page.
  final BuildContext context;

  /// Model with task.
  final Task model;

  /// Controller with a text of the report.
  final TextEditingController reportController;
}

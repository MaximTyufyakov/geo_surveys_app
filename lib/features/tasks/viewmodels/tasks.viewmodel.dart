import 'package:flutter/material.dart';
import 'package:geo_surveys_app/features/tasks/models/tasks.model.dart';

/// A ViewModel of the tasks page.
class TasksViewModel extends ChangeNotifier {
  TasksViewModel({required this.userid}) : model = TasksModel.create(userid);

  /// User identifier.
  final int userid;

  /// Model with all tasks.
  final Future<TasksModel> model;

  /// Reload the tasks page.
  ///
  ///  The [context] parameter is the page context.
  void reloadPage(BuildContext context) async {
    await Navigator.popAndPushNamed(
      context,
      '/tasks',
      arguments: {
        'userid': userid,
      },
    );
  }
}

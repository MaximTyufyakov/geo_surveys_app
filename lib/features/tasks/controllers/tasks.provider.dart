import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geo_surveys_app/common/api.dart';
import 'package:geo_surveys_app/features/tasks/controllers/tasks.repository.dart';
import 'package:geo_surveys_app/features/tasks/models/base_task.model.dart';

/// A provider of the tasks page.
class TasksProvider extends ChangeNotifier {
  TasksProvider({required this.goAuth, required this.openTaskPage}) {
    tasks = _repository.get();
  }

  /// The tasks repository.
  final TasksRepository _repository = TasksRepository();

  /// The list of tasks from api.
  late Future<List<BaseTaskModel>> tasks;

  /// Logout view.
  final VoidCallback goAuth;

  /// Open task page.
  final Future<bool?> Function(int taskId) openTaskPage;

  /// Opens a page with information about task.
  ///
  /// The [task] parameter is the target task.
  Future<void> openTask(BaseTaskModel task) async {
    final bool? completed = await openTaskPage(task.taskid);
    if (completed != null) {
      task.completed = completed;
    }
    notifyListeners();
  }

  /// Reload page.
  void reload() {
    tasks = _repository.get();
    notifyListeners();
  }

  /// Go to auth page with logout.
  void logout() {
    clearToken();
    goAuth();
  }
}

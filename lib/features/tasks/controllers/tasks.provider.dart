import 'package:flutter/foundation.dart';
import 'package:geo_surveys_app/common/api.dart';
import 'package:geo_surveys_app/features/tasks/controllers/tasks.repository.dart';
import 'package:geo_surveys_app/common/models/base_task.model.dart';
import 'package:latlong2/latlong.dart';

/// A provider of the tasks page.
class TasksProvider extends ChangeNotifier {
  TasksProvider({
    required this.goAuth,
    required this.openTaskPage,
    required this.openMapPage,
    required this.errorDialog,
    required this.mesDialog,
  }) {
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

  /// Open map page.
  final ValueSetter<List<LatLng>> openMapPage;

  /// Show error.
  final ValueSetter<List<String>> errorDialog;

  /// Show message.
  final ValueSetter<List<String>> mesDialog;

  /// Opens a page with information about task.
  ///
  /// The [task] parameter is the target task.
  Future<void> openTask({required BaseTaskModel task}) async {
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

  /// Open map page with task markers.
  Future<void> openMap() async {
    await tasks
        .then((value) {
          if (value.isNotEmpty) {
            openMapPage(value.map((elem) => elem.coordinates).toList());
          } else {
            mesDialog(['Нет заданий.']);
          }
        })
        .catchError((Object err) {
          errorDialog([err.toString()]);
        });
  }
}

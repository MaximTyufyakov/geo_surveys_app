import 'package:flutter/material.dart';
import 'package:geo_surveys_app/common/models/api.model.dart';
import 'package:geo_surveys_app/features/task/models/task.model.dart';

/// A ViewModel of the task page.
class TaskPageViewModel extends ChangeNotifier {
  TaskPageViewModel({
    required this.taskid,
    required this.unsavedDialog,
    required this.goBack,
    required this.saveDialog,
    required this.goAuth,
  }) : model = TaskModel.create(taskid: taskid);

  /// Model with task.
  Future<TaskModel> model;

  /// Task identifier.
  final int taskid;

  /// Show unsaved dialog.
  final ValueGetter<Future<bool?>> unsavedDialog;

  /// Go to previous page.
  final ValueSetter<bool?> goBack;

  /// Show saving dialog.
  final Future<void> Function(Future<List<String>>) saveDialog;

  /// Logout view.
  VoidCallback goAuth;

  @override
  Future<void> dispose() async {
    /// Delete unsaved in db videos.
    await model
        .then((value) async {
          await value.deleteUnsavedVideoFiles();
        })
        .catchError((err) {});
    super.dispose();
  }

  /// Exit to previous page.
  Future<void> saveAndExit() async {
    await model
        .then((value) async {
          if (!value.saved) {
            final bool? ret = await unsavedDialog();

            /// Save = true;
            /// Unsave = false;
            /// Close = null.
            if (ret == true) {
              await save();
              if (value.saved) {
                goBack(value.completed);
                notifyListeners();
              }
            } else if (ret == false) {
              goBack(value.completed);
              notifyListeners();
            }
          } else {
            goBack(value.completed);
            notifyListeners();
          }
        })
        .catchError((err) {
          goBack(null);
          notifyListeners();
        });
  }

  /// Exit to previous page.
  Future<void> toPrevPage() async {
    await model
        .then((value) async {
          if (!value.saved) {
            final bool? ret = await unsavedDialog();

            /// Save = true;
            /// Unsave = false;
            /// Close = null.
            if (ret == true) {
              await save();
              if (value.saved) {
                goBack(value.completed);
              }
            } else if (ret == false) {
              goBack(value.completed);
            }
          } else {
            goBack(value.completed);
          }
        })
        .catchError((err) {
          goBack(null);
        });
  }

  /// Exit to login page.
  Future<void> logout() async => await model
      .then((value) async {
        if (!value.saved) {
          final bool? ret = await unsavedDialog();

          /// Save = true;
          /// Unsave = false;
          /// Close = null.
          if (ret == true) {
            await save();
            if (value.saved) {
              clearAuthorization();
              return goAuth();
            }
          } else if (ret == false) {
            clearAuthorization();
            return goAuth();
          }
        } else {
          clearAuthorization();
          return goAuth();
        }
      })
      .catchError((err) {
        clearAuthorization();
        goAuth();
      });

  /// Reload the task page if the model is saved.
  Future<void> reloadPage() async {
    await model
        .then((value) async {
          if (!value.saved) {
            final bool? ret = await unsavedDialog();

            /// Save = true;
            /// Unsave = false;
            /// Close = null.
            if (ret == true) {
              await save();
              if (value.saved) {
                model = TaskModel.create(taskid: taskid);
                notifyListeners();
              }
            } else if (ret == false) {
              model = TaskModel.create(taskid: taskid);
              notifyListeners();
            }
          } else {
            model = TaskModel.create(taskid: taskid);
            notifyListeners();
          }
        })
        .catchError((err) {
          model = TaskModel.create(taskid: taskid);
          notifyListeners();
        });
  }

  /// Save task data.
  Future<void> save() async {
    await saveDialog(
      model.then(
        (value) => value
            .save()
            .then((sValue) => ['Успешно.', value.completedCheck().$2])
            .catchError((Object err) => [err.toString()]),
      ),
    );
    notifyListeners();
  }
}

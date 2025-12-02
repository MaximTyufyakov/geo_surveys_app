import 'package:flutter/material.dart';
import 'package:geo_surveys_app/features/task/models/task.model.dart';
import 'package:geo_surveys_app/features/task/models/video.model.dart';

/// A ViewModel of the task page.
class TaskPageViewModel extends ChangeNotifier {
  TaskPageViewModel({
    required this.taskid,
    required this.unsavedDialog,
    required this.goBack,
    required this.saveDialog,
    required this.reopenTask,
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
  final ValueSetter<Future<List<String>>> saveDialog;

  /// Reload page.
  final ValueSetter<int> reopenTask;

  @override
  void dispose() async {
    /// Delete unsaved in db videos.
    await model.then((value) async {
      for (VideoModel video in value.videos + value.deletedVideos) {
        if (video.videoid == null) {
          await video.deleteFileLocal();
        }
      }
    }).catchError((err) {});
    super.dispose();
  }

  /// Exit to previous page.
  void exit() async {
    await model.then((value) async {
      if (!value.saved) {
        bool? ret = await unsavedDialog();

        /// Save = true;
        /// Unsave = false;
        /// Close = null.
        if (ret == true) {
          await save().then((sValue) {
            if (value.saved) {
              goBack(value.completed);
            }
          });
        } else if (ret == false) {
          goBack(value.completed);
        }
      } else {
        goBack(value.completed);
      }
    }).catchError((err) {
      goBack(null);
    });
  }

  /// Reload the task page if the model is saved.
  void reloadPage() async {
    await model.then((value) async {
      if (!value.saved) {
        bool? ret = await unsavedDialog();

        /// Save = true;
        /// Unsave = false;
        /// Close = null.
        if (ret == true) {
          await save().then((sValue) async {
            if (value.saved) {
              reopenTask(taskid);
            }
          });
        } else if (ret == false) {
          reopenTask(taskid);
        }
      } else {
        reopenTask(taskid);
      }
    }).catchError((err) async {
      reopenTask(taskid);
    });
  }

  /// Save task data.
  Future<void> save() async {
    saveDialog(
      model.then(
        (value) => value.save().then((newTask) {
          // Updated task from api.
          model = Future.value(newTask);
          return ['Успешно.', newTask.completedCheck().$2];
        }).catchError((Object err) => [err.toString()]),
      ),
    );
  }
}

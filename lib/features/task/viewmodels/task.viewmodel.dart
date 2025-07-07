import 'package:flutter/material.dart';
import 'package:geo_surveys_app/common/widgets/dialogs/future_dialog.widget.dart';
import 'package:geo_surveys_app/common/widgets/dialogs/unsaved_dialog.widget.dart';
import 'package:geo_surveys_app/features/task/models/point.model.dart';
import 'package:geo_surveys_app/features/task/models/task.model.dart';

/// A ViewModel of the task page.
///
/// The [context] is the context of the task page.
class TaskViewModel extends ChangeNotifier {
  TaskViewModel({required this.context, required this.taskid})
      : model = TaskModel.create(taskid: taskid);

  /// The context of the task page.
  final BuildContext context;

  /// Model with task.
  final Future<TaskModel> model;

  /// Task identifier.
  final int taskid;

  /// Controller with a text of the report.
  TextEditingController? reportController;

  /// Exit to previous page.
  void exit() async {
    await model.then((value) async {
      if (!value.saved) {
        bool? ret = context.mounted
            ? await showDialog<bool>(
                context: context,
                builder: (context) => UnsavedDialog(),
              )
            : null;

        /// Save = true;
        /// Unsave = false;
        /// Close = null.
        if (ret == true) {
          await save().then((sValue) {
            if (value.saved) {
              context.mounted
                  ? Navigator.pop(
                      context,
                      value.completed,
                    )
                  : null;
            }
          });
        } else if (ret == false) {
          context.mounted
              ? Navigator.pop(
                  context,
                  value.completed,
                )
              : null;
        }
      } else {
        context.mounted
            ? Navigator.pop(
                context,
                value.completed,
              )
            : null;
      }
    }).catchError((err) {
      context.mounted
          ? Navigator.pop(
              context,
              null,
            )
          : null;
    });
  }

  /// Reload the task page if the model is saved.
  void reloadPage() async {
    await model.then((value) async {
      if (!value.saved) {
        bool? ret = context.mounted
            ? await showDialog<bool>(
                context: context,
                builder: (context) => UnsavedDialog(),
              )
            : null;

        /// Save = true;
        /// Unsave = false;
        /// Close = null.
        if (ret == true) {
          await save().then((sValue) async {
            if (value.saved) {
              context.mounted
                  ? await Navigator.popAndPushNamed(
                      context,
                      '/task',
                      arguments: {
                        'taskid': taskid,
                      },
                    )
                  : null;
            }
          });
        } else if (ret == false) {
          context.mounted
              ? await Navigator.popAndPushNamed(
                  context,
                  '/task',
                  arguments: {
                    'taskid': taskid,
                  },
                )
              : null;
        }
      } else {
        context.mounted
            ? await Navigator.popAndPushNamed(
                context,
                '/task',
                arguments: {
                  'taskid': taskid,
                },
              )
            : null;
      }
    }).catchError((err) async {
      context.mounted
          ? await Navigator.popAndPushNamed(
              context,
              '/task',
              arguments: {
                'taskid': taskid,
              },
            )
          : null;
    });
  }

  /// Marks the task as unsaved.
  /// Run when widgets change.
  void makeUnsaved() async {
    await model.then((value) {
      value.saved = false;
    });
  }

  /// Save task data.
  Future<void> save() async {
    await showDialog<bool>(
      context: context,
      builder: (context) => FutureDialog(
        futureContent: model.then(
          (value) => value.save(reportController!.text).then(
                Text.new,
              ),
        ),
        title: 'Сохранение',
        greenTitle: 'Ок',
        redTitle: null,
      ),
    );
  }

  /// Tap on the point CheckBox.
  void onPointTap(PointModel point) {
    point.completed = !point.completed;
    makeUnsaved();
    notifyListeners();
  }
}

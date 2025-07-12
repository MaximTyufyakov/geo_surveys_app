import 'package:flutter/material.dart';
import 'package:geo_surveys_app/common/widgets/dialogs/future_dialog.widget.dart';
import 'package:geo_surveys_app/common/widgets/dialogs/unsaved_dialog.widget.dart';
import 'package:geo_surveys_app/features/task/models/task.model.dart';

/// A ViewModel of the task page.
class TaskPageViewModel extends ChangeNotifier {
  TaskPageViewModel({required this.taskid})
      : model = TaskModel.create(taskid: taskid);

  /// Model with task.
  final Future<TaskModel> model;

  /// Task identifier.
  final int taskid;

  /// Exit to previous page.
  void exit(BuildContext context) async {
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
          context.mounted
              ? await save(context).then((sValue) {
                  if (value.saved) {
                    context.mounted
                        ? Navigator.pop(
                            context,
                            value.completed,
                          )
                        : null;
                  }
                })
              : null;
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
  void reloadPage(BuildContext context) async {
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
          context.mounted
              ? await save(context).then((sValue) async {
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
                })
              : null;
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

  /// Save task data.
  Future<void> save(BuildContext context) async {
    await showDialog<bool>(
      context: context,
      builder: (context) => FutureDialog(
        futureContent: model.then(
          (value) => value.save().then(
                Text.new,
              ),
        ),
        title: 'Сохранение',
        greenTitle: 'Ок',
        redTitle: null,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:geo_surveys_app/common/widgets/unsaved_dialog.widget.dart';
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

  /// Reload the task page if the model is saved.
  void reloadPage() async {
    if (!model.saved) {
      if (await showDialog<bool>(
              context: context, builder: (context) => UnsavedDialog()) ==
          true) {
        model.saved = true;
      }
    }
    if (model.saved) {
      if (context.mounted) {
        await Navigator.popAndPushNamed(
          context,
          '/task',
          arguments: {
            'model': model,
          },
        );
      }
    }
  }

  /// Marks the task as unsaved.
  /// Run when widgets change.
  void makeUnsaved() {
    model.saved = false;
  }

  /// Save task data.
  void save() async {
    model.saved = true;
  }
}

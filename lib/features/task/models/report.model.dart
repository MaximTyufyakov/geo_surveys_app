import 'package:geo_surveys_app/features/task/models/task.model.dart';

/// The task model.
///
/// The [parent] parameter is the task.
/// The [text] parameter is the text that the user writes (optional).
class ReportModel {
  ReportModel({
    required this.text,
  });

  /// Parent model.
  late TaskModel parent;

  /// The text that the user writes.
  String text;

  /// On report text change.
  void textChange(String actualText) {
    text = actualText;
    makeUnsaved();
  }

  /// Marks the task as unsaved.
  /// Run when widgets change.
  void makeUnsaved() {
    parent.makeUnsaved();
  }
}

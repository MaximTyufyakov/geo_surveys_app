import 'package:flutter/material.dart';
import 'package:geo_surveys_app/features/task/models/report.model.dart';

/// A ViewModel of the report.
class ReportViewModel extends ChangeNotifier {
  ReportViewModel({
    required this.model,
  }) : reportController = TextEditingController(
          text: model.text,
        );

  /// Model with task.
  final ReportModel model;

  /// Controller with a text of the report.
  final TextEditingController reportController;

  /// On report text change.
  void onTextChange() {
    model.textChange(reportController.text);
  }
}

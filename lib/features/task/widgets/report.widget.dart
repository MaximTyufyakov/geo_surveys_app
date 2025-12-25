import 'package:flutter/material.dart';
import 'package:geo_surveys_app/features/task/controllers/task.provider.dart';

/// A Widget with report text field.
///
/// The [provider] parameter is a report view model.
class ReportWidget extends StatelessWidget {
  ReportWidget({super.key, required this.report, required this.provider})
    : _reportController = TextEditingController(text: report);

  /// Task provider.
  final TaskProvider provider;

  /// Report.
  final String report;

  /// Controller with a text of the report.
  final TextEditingController _reportController;

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(8),
    children: [
      TextField(
        decoration: const InputDecoration(
          hintText: 'Здесь можно написать отчёт о выполненной работе.',
        ),
        controller: _reportController,
        onChanged: (action) =>
            provider.onReportChange(report: _reportController.text),
        maxLines: null,

        /// Unfocus.
        onTapOutside: (event) => FocusScope.of(context).unfocus(),
      ),
    ],
  );
}

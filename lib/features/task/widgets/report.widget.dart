import 'package:flutter/material.dart';

/// A Widget with report text field.
///
/// The [onReportChange] parameter is on report change action.
class ReportWidget extends StatelessWidget {
  ReportWidget({super.key, required this.report, required this.onReportChange})
    : _reportController = TextEditingController(text: report);

  /// On report change action.
  final ValueSetter<String> onReportChange;

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
        onChanged: (action) => onReportChange(_reportController.text),
        maxLines: null,

        /// Unfocus.
        onTapOutside: (event) => FocusScope.of(context).unfocus(),
      ),
    ],
  );
}

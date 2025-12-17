import 'package:flutter/material.dart';
import 'package:geo_surveys_app/features/task/models/report.model.dart';
import 'package:geo_surveys_app/features/task/viewmodels/report.viewmodel.dart';
import 'package:provider/provider.dart';

/// A Widget with report text field.
///
/// The [provider] parameter is a report view model.
class ReportWidget extends StatelessWidget {
  ReportWidget({
    super.key,
    required ReportModel report,
  }) : provider = ReportViewModel(model: report);

  /// Report view model.
  final ReportViewModel provider;

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider<ReportViewModel>(
        create: (BuildContext context) => provider,
        child: Consumer<ReportViewModel>(
          builder: (context, provider, child) => Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Здесь можно написать отчёт о выполненной работе.',
              ),
              controller: provider.reportController,
              onChanged: (action) {
                provider.onTextChange();
              },
              maxLines: 25,
            ),
          ),
        ),
      );
}

import 'package:flutter/material.dart';
import 'package:geo_surveys_app/features/task/viewmodels/task.viewmodel.dart';

class ReportWidget extends StatelessWidget {
  const ReportWidget({
    super.key,
    required this.viewModel,
  });

  final TaskViewModel viewModel;

  @override
  Widget build(BuildContext context) => TextField(
        decoration: const InputDecoration(
          hintText: 'Здесь можно написать отчёт о выполненной работе.',
        ),
        controller: viewModel.reportController,
        onChanged: (action) {
          viewModel.makeUnsaved();
        },
        maxLines: 100,
      );
}

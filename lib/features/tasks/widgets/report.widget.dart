import 'package:flutter/material.dart';
import 'package:geo_surveys_app/common/widgets/message.widget.dart';

/// A widget with task's report.
///
/// {@category Widgets}
class ReportWidget extends StatelessWidget {
  const ReportWidget({super.key});

  @override
  Widget build(BuildContext context) =>
      const MessageWidget(mes: 'Здесь будет отчёт.');
}

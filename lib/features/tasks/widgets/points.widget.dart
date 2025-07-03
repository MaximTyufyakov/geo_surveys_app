import 'package:flutter/material.dart';
import 'package:geo_surveys_app/common/widgets/message.widget.dart';

/// A widget with task points.
class PointsWidget extends StatelessWidget {
  const PointsWidget({super.key});

  @override
  Widget build(BuildContext context) =>
      const MessageWidget(mes: 'Здесь будут пункты задания.');
}

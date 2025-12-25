import 'package:flutter/material.dart';
import 'package:geo_surveys_app/features/task/controllers/task_page.provider.dart';
import 'package:geo_surveys_app/features/task/models/point.model.dart';

/// A Widget with check-box and point information.
///
/// The [provider] parameter is a point view model.
class PointWidget extends StatelessWidget {
  const PointWidget({super.key, required this.point, required this.provider});

  /// Task provider.
  final TaskPageProvider provider;

  /// Point Model.
  final PointModel point;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Row(
        children: [
          /// Number.
          Text(
            '${point.number}.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),

          Checkbox(
            value: point.completed,
            onChanged: (onChanged) => provider.onPointTap(point: point),
          ),

          /// Description.
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SelectableText(
                  point.description,
                  style: Theme.of(context).textTheme.bodyMedium,
                  onTap: () => provider.onPointTap(point: point),
                ),
              ],
            ),
          ),
        ],
      ),
      const Divider(),
    ],
  );
}

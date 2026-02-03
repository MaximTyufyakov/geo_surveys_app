import 'package:flutter/material.dart';
import 'package:geo_surveys_app/features/task/models/point.model.dart';

/// A Widget with check-box and point information.
///
/// The [onPointTap] parameter is on point tap action.
class PointWidget extends StatelessWidget {
  const PointWidget({super.key, required this.point, required this.onPointTap});

  /// On point tap action.
  final VoidCallback onPointTap;

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
            onChanged: (onChanged) => onPointTap(),
          ),

          /// Description.
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SelectableText(
                  point.description,
                  style: Theme.of(context).textTheme.bodyMedium,
                  onTap: onPointTap,
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

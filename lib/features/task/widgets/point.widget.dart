import 'package:flutter/material.dart';
import 'package:geo_surveys_app/features/task/models/point.model.dart';
import 'package:geo_surveys_app/features/task/viewmodels/task.viewmodel.dart';

/// A Widget with check-box and point information.
///
/// The [point] parameter is a point information.
class PointWidget extends StatelessWidget {
  const PointWidget({
    super.key,
    required this.point,
    required this.viewModel,
  });

  final PointModel point;
  final TaskViewModel viewModel;

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Row(
            children: [
              /// Number.
              Text('${point.number}.',
                  style: Theme.of(context).textTheme.bodyMedium),

              Checkbox(
                  value: point.completed,
                  onChanged: (onChanged) async {
                    viewModel.onPointTap(point);
                  }),

              /// Description.
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SelectableText(point.description,
                        style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
              ),
            ],
          ),
          const Divider(
            color: Colors.black26,
          ),
        ],
      );
}

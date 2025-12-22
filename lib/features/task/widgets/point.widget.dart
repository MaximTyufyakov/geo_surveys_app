import 'package:flutter/material.dart';
import 'package:geo_surveys_app/features/task/models/point.model.dart';
import 'package:geo_surveys_app/features/task/viewmodels/point.viewmodel.dart';
import 'package:provider/provider.dart';

/// A Widget with check-box and point information.
///
/// The [provider] parameter is a point view model.
class PointWidget extends StatelessWidget {
  PointWidget({super.key, required PointModel point})
    : provider = PointViewModel(model: point);

  /// Point view model.
  final PointViewModel provider;

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider<PointViewModel>(
    create: (BuildContext context) => provider,
    child: Consumer<PointViewModel>(
      builder: (context, provider, child) => Column(
        children: [
          Row(
            children: [
              /// Number.
              Text(
                '${provider.model.number}.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),

              Checkbox(
                value: provider.model.completed,
                onChanged: (onChanged) => provider.onPointTap(),
              ),

              /// Description.
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SelectableText(
                      provider.model.description,
                      style: Theme.of(context).textTheme.bodyMedium,
                      onTap: () => provider.onPointTap(),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(),
        ],
      ),
    ),
  );
}

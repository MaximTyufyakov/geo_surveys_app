import 'package:flutter/material.dart';
import 'package:geo_surveys_app/features/task/models/point.model.dart';
import 'package:geo_surveys_app/features/task/models/task.model.dart';
import 'package:geo_surveys_app/features/task/viewmodels/task.viewmodel.dart';
import 'package:geo_surveys_app/features/task/widgets/point.widget.dart';
import 'package:provider/provider.dart';

/// A widget with task information.
///
/// The [provider] parameter is a task view model.
class TaskWidget extends StatelessWidget {
  TaskWidget({
    super.key,
    required TaskModel task,
  }) : provider = TaskViewModel(
          model: task,
        );

  /// Task task view model.
  final TaskViewModel provider;

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider<TaskViewModel>(
        create: (BuildContext context) => provider,
        child: Consumer<TaskViewModel>(
          builder: (context, provider, child) {
            /// Points widgets.
            final List<Widget> pointsCards = [];
            for (PointModel point in provider.model.points) {
              pointsCards.add(
                PointWidget(
                  point: point,
                ),
              );
            }
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                      SelectableText(
                        provider.model.title,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Описание',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Divider(
                        color: Theme.of(context).primaryColorDark,
                      ),
                      SelectableText(
                        provider.model.description,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Координаты',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Divider(
                        color: Theme.of(context).primaryColorDark,
                      ),
                      SelectableText(
                        '${provider.model.coordinates.latitude}°, ${provider.model.coordinates.longitude}°',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Ход работы',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Divider(
                        color: Theme.of(context).primaryColorDark,
                      )
                    ] +
                    pointsCards,
              ),
            );
          },
        ),
      );
}

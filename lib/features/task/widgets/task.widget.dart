import 'package:flutter/material.dart';
import 'package:geo_surveys_app/common/widgets/message.widget.dart';
import 'package:geo_surveys_app/features/task/models/point.model.dart';
import 'package:geo_surveys_app/features/task/models/task.model.dart';
import 'package:geo_surveys_app/features/task/widgets/point.widget.dart';
import 'package:geo_surveys_app/features/task/widgets/section.widget.dart';

/// A widget with task information.
///
/// The [onPointTap] parameter is on point tap action.
class TaskWidget extends StatelessWidget {
  const TaskWidget({super.key, required this.task, required this.onPointTap});

  /// On point tap action.
  final ValueSetter<PointModel> onPointTap;

  /// Task model.
  final TaskModel task;

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(8),
    children: [
      SelectableText(
        task.title,
        style: Theme.of(context).textTheme.headlineMedium,
      ),
      const SizedBox(height: 20),
      SectionWidget(
        title: 'Описание',
        content: SelectableText(
          task.description ?? 'Нет данных.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),

      SectionWidget(
        title: 'Координаты',
        content: SelectableText(
          '${task.coordinates.latitude}, ${task.coordinates.longitude}',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),

      SectionWidget(
        title: 'Ход работы',
        content: task.points.isEmpty
            ? const MessageWidget(
                mes: 'Нет пунктов.',
                icon: Icons.format_list_bulleted_rounded,
              )
            : Column(
                children: task.points
                    .map<Widget>(
                      (point) => PointWidget(
                        point: point,
                        onPointTap: () => onPointTap(point),
                      ),
                    )
                    .toList(),
              ),
      ),
    ],
  );
}

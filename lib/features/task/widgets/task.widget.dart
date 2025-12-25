import 'package:flutter/material.dart';
import 'package:geo_surveys_app/common/widgets/message.widget.dart';
import 'package:geo_surveys_app/features/task/controllers/task_page.provider.dart';
import 'package:geo_surveys_app/features/task/models/task.model.dart';
import 'package:geo_surveys_app/features/task/widgets/point.widget.dart';
import 'package:geo_surveys_app/features/task/widgets/section.widget.dart';

/// A widget with task information.
///
/// The [provider] parameter is a task view model.
class TaskWidget extends StatelessWidget {
  const TaskWidget({super.key, required this.task, required this.provider});

  /// Task task provider.
  final TaskPageProvider provider;

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
          '${task.latitude ?? 'н/д'}, ${task.longitude ?? 'н/д'}',
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
                      (point) => PointWidget(point: point, provider: provider),
                    )
                    .toList(),
              ),
      ),
    ],
  );
}

import 'package:flutter/material.dart';
import 'package:geo_surveys_app/common/widgets/message.widget.dart';
import 'package:geo_surveys_app/features/task/models/task.model.dart';
import 'package:geo_surveys_app/features/task/viewmodels/task.viewmodel.dart';
import 'package:geo_surveys_app/features/task/widgets/point.widget.dart';
import 'package:geo_surveys_app/features/task/widgets/section.widget.dart';
import 'package:provider/provider.dart';

/// A widget with task information.
///
/// The [provider] parameter is a task view model.
class TaskWidget extends StatelessWidget {
  TaskWidget({super.key, required TaskModel task})
    : provider = TaskViewModel(model: task);

  /// Task task view model.
  final TaskViewModel provider;

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider<TaskViewModel>(
    create: (BuildContext context) => provider,
    child: Consumer<TaskViewModel>(
      builder: (context, provider, child) => ListView(
        padding: const EdgeInsets.all(8),
        children: [
          SelectableText(
            provider.model.title,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 20),
          SectionWidget(
            title: 'Описание',
            content: SelectableText(
              provider.model.description ?? 'Нет данных.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),

          SectionWidget(
            title: 'Координаты',
            content: SelectableText(
              '''${provider.model.latitude ?? 'н/д'}, ${provider.model.longitude ?? 'н/д'}''',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),

          SectionWidget(
            title: 'Ход работы',
            content: provider.model.points.isEmpty
                ? const MessageWidget(
                    mes: 'Нет пунктов.',
                    icon: Icons.format_list_bulleted_rounded,
                  )
                : Column(
                    children: provider.model.points
                        .map<Widget>((point) => PointWidget(point: point))
                        .toList(),
                  ),
          ),
        ],
      ),
    ),
  );
}

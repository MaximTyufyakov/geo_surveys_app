import 'package:flutter/material.dart';
import 'package:geo_surveys_app/common/widgets/message.widget.dart';
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
          builder: (context, provider, child) => ListView(
            padding: const EdgeInsets.all(8),
            children: [
              SelectableText(
                provider.model.title,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 20),
              _buildTextSection(
                context,
                title: 'Описание',
                content: provider.model.description ?? 'Нет данных.',
              ),
              _buildTextSection(
                context,
                title: 'Координаты',
                content:
                    '''${provider.model.latitude ?? 'н/д'}, ${provider.model.longitude ?? 'н/д'}''',
              ),
              _buildListSection(
                context,
                title: 'Ход работы',
                content: provider.model.points
                    .map<Widget>((point) => PointWidget(point: point))
                    .toList(),
              ),
            ],
          ),
        ),
      );

  Widget _buildSection(BuildContext context,
          {required String title, required Widget content}) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Divider(
            color: Theme.of(context).primaryColorDark,
          ),
          content,
          const SizedBox(
            height: 20,
          ),
        ],
      );

  Widget _buildTextSection(BuildContext context,
          {required String title, required String content}) =>
      _buildSection(
        context,
        title: title,
        content: SelectableText(
          content,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      );

  Widget _buildListSection(BuildContext context,
          {required String title, required List<Widget> content}) =>
      _buildSection(
        context,
        title: title,
        content: content.isEmpty
            ? const MessageWidget(
                mes: 'Нет пунктов.', icon: Icons.format_list_bulleted_rounded)
            : Column(
                children: content,
              ),
      );
}

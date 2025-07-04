import 'package:flutter/material.dart';
import 'package:geo_surveys_app/features/tasks/models/task.model.dart';
import 'package:geo_surveys_app/features/tasks/viewmodels/task.viewmodel.dart';
import 'package:geo_surveys_app/features/tasks/widgets/photos.widget.dart';
import 'package:geo_surveys_app/features/tasks/widgets/points.widget.dart';
import 'package:provider/provider.dart';

/// A page with BottomNavigationBar and task's widgets.
class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

/// A state of task page.
class _TaskPageState extends State<TaskPage> {
  /// The selected index of BottomNavigationBar.
  int _selectedIndex = 0;

  /// The widgets on the page.
  late List<Widget> _widgets;

  /// The arguments from the previous page.
  late Map<String, dynamic> _arguments;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    /// Decoding arguments.
    _arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map<String, dynamic>;

    return ChangeNotifierProvider<TaskViewModel>(
      create: (BuildContext context) => TaskViewModel(
        context: context,
        model: _arguments['model'] as Task,
      ),
      child: Consumer<TaskViewModel>(
        builder: (context, provider, child) {
          /// Initialization of widgets.
          _widgets = <Widget>[
            /// Points.
            const PointsWidget(),

            /// Report.
            TextField(
              decoration: const InputDecoration(
                hintText: 'Здесь можно написать отчёт о выполненной работе.',
              ),
              controller: TextEditingController(text: provider.model.report),
              maxLines: 100,
            ),

            /// Photos.
            const PhotosWidget(),
          ];

          return Scaffold(
            appBar: AppBar(
              title: Text(
                'Задание',
                style: Theme.of(context).textTheme.displaySmall,
              ),
              actions: [
                /// Page reload.
                IconButton(
                  onPressed: () async {
                    await Navigator.popAndPushNamed(context, '/tasks');
                  },
                  icon: const Icon(Icons.replay_outlined),
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(8),
              child: Center(
                child: _widgets.elementAt(_selectedIndex),
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.task_alt),
                  label: 'Пункты',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.edit_document),
                  label: 'Отчёт',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.photo_library_outlined),
                  label: 'Фотографии',
                ),
              ],
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
            ),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:geo_surveys_app/features/tasks/models/task.model.dart';
import 'package:geo_surveys_app/features/tasks/viewmodels/task.viewmodel.dart';
import 'package:geo_surveys_app/features/tasks/widgets/photos.widget.dart';
import 'package:geo_surveys_app/features/tasks/widgets/points.widget.dart';
import 'package:provider/provider.dart';

/// The page with BottomNavigationBar and task's widgets.
///
/// {@category Widgets}
class TaskPage extends StatefulWidget {
  const TaskPage({super.key, required this.model});

  final Task model;

  @override
  State<TaskPage> createState() => _TaskPageState();
}

/// A state of task page.
///
/// {@category Widgets}
class _TaskPageState extends State<TaskPage> {
  /// The selected index of BottomNavigationBar.
  int _selectedIndex = 0;

  /// Widgets on the page.
  late List<Widget> _widgetOptions;

  late TextEditingController reportController;

  @override
  void initState() {
    super.initState();

    reportController = TextEditingController(text: widget.model.report);

    _widgetOptions = <Widget>[
      const PointsWidget(),

      /// Report
      TextField(
        decoration: const InputDecoration(
          hintText: 'Здесь можно написать отчёт о выполненной работе.',
        ),
        controller: reportController,
        maxLines: 100,
        onChanged: (action) {
          // widget.result.visibleValue = valueController.text;
        },
      ),

      const PhotosWidget(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider<TaskViewModel>(
        create: (BuildContext context) => TaskViewModel(
          context: context,
          model: widget.model,
        ),
        child: Consumer<TaskViewModel>(
          builder: (context, provider, child) => Scaffold(
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
                child: _widgetOptions.elementAt(_selectedIndex),
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
          ),
        ),
      );
}

import 'package:flutter/material.dart';
import 'package:geo_surveys_app/features/tasks/widgets/photos.widget.dart';
import 'package:geo_surveys_app/features/tasks/widgets/points.widget.dart';
import 'package:geo_surveys_app/features/tasks/widgets/report.widget.dart';

/// The page with navigation and task's widgets.
///
/// {@category Widgets}
class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  int _selectedIndex = 0;
  late List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();

    _widgetOptions = <Widget>[
      const PointsWidget(),
      const ReportWidget(),
      const PhotosWidget(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColorLight,
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
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Theme.of(context).primaryColorLight,
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
          selectedItemColor: Theme.of(context).primaryColor,
          onTap: _onItemTapped,
        ),
      );
}

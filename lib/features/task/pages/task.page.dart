import 'package:flutter/material.dart';
import 'package:geo_surveys_app/common/widgets/dialogs/future_dialog.widget.dart';
import 'package:geo_surveys_app/common/widgets/dialogs/unsaved_dialog.widget.dart';
import 'package:geo_surveys_app/common/widgets/loading.widget.dart';
import 'package:geo_surveys_app/common/widgets/message.widget.dart';
import 'package:geo_surveys_app/features/task/viewmodels/task_page.viewmodel.dart';
import 'package:geo_surveys_app/features/task/widgets/report.widget.dart';
import 'package:geo_surveys_app/features/task/widgets/task.widget.dart';
import 'package:geo_surveys_app/features/task/widgets/videos.widget.dart';
import 'package:provider/provider.dart';

/// A page with BottomNavigationBar and task's widgets.
class TaskPage extends StatefulWidget {
  const TaskPage({super.key, required this.taskid});

  final int taskid;

  @override
  State<TaskPage> createState() => _TaskPageState();
}

/// A state of task page.
class _TaskPageState extends State<TaskPage> {
  /// The selected index of BottomNavigationBar.
  int _selectedIndex = 0;

  /// The widgets on the page.
  late TaskWidget taskWidget;
  late ReportWidget reportWidget;
  late VideosWidget videosWidget;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) =>
      ChangeNotifierProvider<TaskPageViewModel>(
        create: (BuildContext context) => TaskPageViewModel(
          taskid: widget.taskid,
          unsavedDialog: () async => await showDialog<bool>(
            context: context,
            builder: (context) => UnsavedDialog(),
          ),
          goBack: (bool? completed) => Navigator.of(context).pop(
            completed,
          ),
          saveDialog: (Future<List<String>> futureText) async =>
              await showDialog<bool>(
            context: context,
            builder: (context) => FutureDialog(
              futureText: futureText,
              title: 'Сохранение',
              greenTitle: 'Ок',
              redTitle: null,
            ),
          ),
          reopenTask: (int taskid) {
            Navigator.of(context).pop();
            Navigator.of(context).push(
              MaterialPageRoute<TaskPage>(
                builder: (context) => TaskPage(
                  taskid: taskid,
                ),
              ),
            );
          },
        ),
        child: Consumer<TaskPageViewModel>(
          builder: (context, provider, child) => Scaffold(
            appBar: AppBar(
              title: Text(
                'Задание',
                style: Theme.of(context).textTheme.displayMedium,
              ),
              leading: BackButton(
                onPressed: () {
                  provider.exit();
                },
              ),
              actions: [
                /// Page reload.
                IconButton(
                  onPressed: () async {
                    provider.reloadPage();
                  },
                  icon: const Icon(Icons.replay_outlined),
                ),

                /// Save.
                IconButton(
                  onPressed: () async {
                    await provider.save();
                  },
                  icon: const Icon(Icons.save),
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(8),
              child: FutureBuilder(
                  future: provider.model,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      /// Data from the database is received.
                      if (snapshot.hasData) {
                        /// Initialization of widgets.

                        /// Task.
                        taskWidget = TaskWidget(
                          task: snapshot.data!,
                        );

                        /// Report.
                        reportWidget = ReportWidget(
                          report: snapshot.data!.report,
                        );

                        /// Videos.
                        videosWidget = VideosWidget(
                          task: snapshot.data!,
                        );

                        return [
                          taskWidget,
                          reportWidget,
                          videosWidget,
                        ].elementAt(_selectedIndex);

                        /// Error.
                      } else if (snapshot.hasError) {
                        return MessageWidget(mes: snapshot.error.toString());
                      }
                    }

                    /// Loading.
                    return const LoadingWidget();
                  }),
            ),
            bottomNavigationBar: BottomNavigationBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                    icon: Icon(Icons.task_alt), label: 'Задание'),
                BottomNavigationBarItem(
                  icon: Icon(Icons.edit_document),
                  label: 'Отчёт',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.photo_library_outlined),
                  label: 'Видео',
                ),
              ],
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
            ),
          ),
        ),
      );
}

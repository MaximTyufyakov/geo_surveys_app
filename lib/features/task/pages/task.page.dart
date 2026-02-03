import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geo_surveys_app/common/widgets/dialogs/future_dialog.widget.dart';
import 'package:geo_surveys_app/common/widgets/dialogs/text_dialog.widget.dart';
import 'package:geo_surveys_app/common/widgets/dialogs/unsaved_dialog.widget.dart';
import 'package:geo_surveys_app/common/widgets/loading.widget.dart';
import 'package:geo_surveys_app/common/widgets/popup_menu.widget.dart';
import 'package:geo_surveys_app/common/widgets/scroll_message.widget.dart';
import 'package:geo_surveys_app/features/auth/pages/auth.page.dart';
import 'package:geo_surveys_app/features/task/controllers/task.provider.dart';
import 'package:geo_surveys_app/features/task/models/point.model.dart';
import 'package:geo_surveys_app/features/task/models/video.model.dart';
import 'package:geo_surveys_app/features/task/widgets/report.widget.dart';
import 'package:geo_surveys_app/features/task/widgets/task.widget.dart';
import 'package:geo_surveys_app/features/task/widgets/videos.widget.dart';
import 'package:geo_surveys_app/features/video_shoot/pages/video_shoot.page.dart';
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

  /// Bottom navigation item tap.
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  /// Back system button.
  Future<void> _onPopInvoked(bool didPop, TaskProvider provider) async {
    if (!didPop) {
      await provider.toPrevPage();
    }
  }

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider<TaskProvider>(
    create: (BuildContext context) => TaskProvider(
      taskid: widget.taskid,
      unsavedDialog: () => showDialog<bool>(
        context: context,
        builder: (context) => UnsavedDialog(),
      ),
      goBack: (bool? completed) => Navigator.of(context).pop(completed),
      saveDialog: (Future<List<String>> futureText) => showDialog<bool>(
        context: context,
        builder: (context) => FutureDialog(
          futureText: futureText,
          title: 'Сохранение',
          greenTitle: 'Ок',
          redTitle: null,
        ),
      ),
      goAuth: () => Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute<void>(builder: (context) => const AuthPage()),
        (route) => false, // Remove all previous routes.
      ),
      errorDialog: (text) => showDialog<bool>(
        context: context,
        builder: (context) => TextDialog(
          title: 'Ошибка',
          text: text,
          greenTitle: 'Ок',
          redTitle: null,
        ),
      ),
      openVideoShootPage: () => Navigator.of(context).push(
        MaterialPageRoute<File>(builder: (context) => const VideoShootPage()),
      ),
      geolocationDialog: (Future<List<String>> futureText) => showDialog<bool>(
        context: context,
        builder: (context) => FutureDialog(
          futureText: futureText,
          title: 'Определение местоположения',
          greenTitle: 'Ок',
          redTitle: null,
        ),
      ),
      videoDeleteDialog: () => showDialog<bool>(
        context: context,
        builder: (context) => TextDialog(
          title: 'Удаление видео',
          text: const ['Вы уверены?'],
          greenTitle: 'Да',
          redTitle: 'Нет',
        ),
      ),
    ),
    child: Consumer<TaskProvider>(
      builder: (context, provider, child) => Scaffold(
        appBar: AppBar(
          title: Text(
            'Задание',
            style: Theme.of(context).textTheme.displayMedium,
          ),
          leading: BackButton(
            onPressed: () async => await provider.toPrevPage(),
          ),
          actions: [
            /// Save.
            IconButton(
              onPressed: () async => await provider.onSave(),
              icon: const Icon(Icons.save),
            ),

            // Menu (...)
            PopupMenuWidget(logout: () async => await provider.logout()),
          ],
        ),
        body: PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) =>
              _onPopInvoked(didPop, provider),
          child: RefreshIndicator(
            onRefresh: () async => await provider.reloadPage(),
            child: FutureBuilder(
              future: provider.task,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  /// Data.
                  if (snapshot.hasData) {
                    switch (_selectedIndex) {
                      /// Task.
                      case 0:
                        return TaskWidget(
                          task: snapshot.data!,
                          onPointTap: (PointModel point) => provider.onPointTap(
                            task: snapshot.data!,
                            point: point,
                          ),
                        );

                      /// Report.
                      case 1:
                        return ReportWidget(
                          report: snapshot.data!.report,
                          onReportChange: (String report) =>
                              provider.onReportChange(
                                task: snapshot.data!,
                                report: report,
                              ),
                        );

                      /// Videos.
                      case 2:
                        return VideosWidget(
                          videos: snapshot.data!.videos,
                          onVideoDelete: (VideoModel video) =>
                              provider.onVideoDelete(
                                task: snapshot.data!,
                                video: video,
                              ),
                          onVideoAdd: (String title) => provider.onVideoAdd(
                            task: snapshot.data!,
                            newTitle: title,
                          ),
                        );

                      /// Task.
                      default:
                        return TaskWidget(
                          task: snapshot.data!,
                          onPointTap: (PointModel point) => provider.onPointTap(
                            task: snapshot.data!,
                            point: point,
                          ),
                        );
                    }

                    /// Error.
                  } else if (snapshot.hasError) {
                    return ScrollMessageWidget(
                      mes: snapshot.error.toString(),
                      icon: Icons.error,
                    );
                  }
                }

                /// Loading.
                return const LoadingWidget();
              },
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.task_alt),
              label: 'Задание',
            ),
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

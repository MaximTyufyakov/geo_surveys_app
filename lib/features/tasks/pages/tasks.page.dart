import 'package:flutter/material.dart';
import 'package:geo_surveys_app/common/widgets/dialogs/text_dialog.widget.dart';
import 'package:geo_surveys_app/common/widgets/loading.widget.dart';
import 'package:geo_surveys_app/common/widgets/popup_menu.widget.dart';
import 'package:geo_surveys_app/common/widgets/scroll_message.widget.dart';
import 'package:geo_surveys_app/features/auth/pages/auth.page.dart';
import 'package:geo_surveys_app/features/map/pages/map.page.dart';
import 'package:geo_surveys_app/features/task/pages/task.page.dart';
import 'package:geo_surveys_app/features/tasks/controllers/tasks.provider.dart';
import 'package:geo_surveys_app/features/tasks/widgets/task_card.widget.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

/// The main page with a list of all tasks in the database.
class TasksPage extends StatelessWidget {
  const TasksPage({super.key});

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider<TasksProvider>(
    create: (BuildContext context) => TasksProvider(
      goAuth: () => Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute<void>(builder: (context) => const AuthPage()),
        (route) => false, // Remove all previous routes.
      ),
      openTaskPage: (int taskId) => Navigator.of(context).push(
        MaterialPageRoute<bool>(builder: (context) => TaskPage(taskid: taskId)),
      ),
      openMapPage: (List<LatLng> markers) => Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (context) => MapPage(mapPoints: markers),
        ),
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
      mesDialog: (text) => showDialog<bool>(
        context: context,
        builder: (context) => TextDialog(
          title: 'Сообщение',
          text: text,
          greenTitle: 'Ок',
          redTitle: null,
        ),
      ),
    ),
    child: Consumer<TasksProvider>(
      builder: (context, provider, child) => Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            'Задания',
            style: Theme.of(context).textTheme.displayMedium,
          ),
          actions: [
            // Menu (...)
            PopupMenuWidget(onLogout: provider.logout, onMap: provider.openMap),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () async => provider.reload(),
          child: FutureBuilder(
            future: provider.tasks,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                /// Data.
                if (snapshot.hasData) {
                  /// Tasks empty.
                  return snapshot.data!.isEmpty
                      ? const ScrollMessageWidget(
                          mes: 'Нет заданий.',
                          icon: Icons.notes,
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(8),
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) => TaskCard(
                            task: snapshot.data![index],
                            onCardTap: () =>
                                provider.openTask(task: snapshot.data![index]),
                          ),
                        );

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
    ),
  );
}

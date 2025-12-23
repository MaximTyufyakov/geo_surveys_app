import 'package:flutter/material.dart';
import 'package:geo_surveys_app/common/widgets/loading.widget.dart';
import 'package:geo_surveys_app/common/widgets/popup_menu.widget.dart';
import 'package:geo_surveys_app/common/widgets/scroll_message.widget.dart';
import 'package:geo_surveys_app/features/auth/pages/auth.page.dart';
import 'package:geo_surveys_app/features/tasks/viewmodels/tasks.viewmodel.dart';
import 'package:geo_surveys_app/features/tasks/widgets/task_card.widget.dart';
import 'package:provider/provider.dart';

/// The main page with a list of all tasks in the database.
class TasksPage extends StatelessWidget {
  const TasksPage({super.key});

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider<TasksViewModel>(
    create: (BuildContext context) => TasksViewModel(
      goAuth: () => Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute<void>(builder: (context) => const AuthPage()),
        (route) => false, // Remove all previous routes.
      ),
    ),
    child: Consumer<TasksViewModel>(
      builder: (context, provider, child) => Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            'Задания',
            style: Theme.of(context).textTheme.displayMedium,
          ),
          actions: [
            // Menu (...)
            PopupMenuWidget(logout: provider.logout),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () async => await provider.reload(),
          child: FutureBuilder(
            future: provider.model,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                /// Data.
                if (snapshot.hasData) {
                  /// Tasks empty.
                  return snapshot.data!.tasks.isEmpty
                      ? const ScrollMessageWidget(
                          mes: 'Нет заданий.',
                          icon: Icons.notes,
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(8),
                          itemCount: snapshot.data!.tasks.length,
                          itemBuilder: (context, index) =>
                              TaskCard(task: snapshot.data!.tasks[index]),
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

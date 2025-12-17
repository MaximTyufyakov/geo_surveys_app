import 'package:flutter/material.dart';
import 'package:geo_surveys_app/common/widgets/loading.widget.dart';
import 'package:geo_surveys_app/common/widgets/popup_menu.widget.dart';
import 'package:geo_surveys_app/common/widgets/scroll_message.widget.dart';
import 'package:geo_surveys_app/features/tasks/viewmodels/tasks.viewmodel.dart';
import 'package:geo_surveys_app/features/tasks/widgets/task_card.widget.dart';
import 'package:provider/provider.dart';

/// The main page with a list of all tasks in the database.
class TasksPage extends StatelessWidget {
  const TasksPage({super.key});

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider<TasksViewModel>(
        create: (BuildContext context) => TasksViewModel(),
        child: Consumer<TasksViewModel>(
          builder: (context, provider, child) => Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Text(
                'Задания',
                style: Theme.of(context).textTheme.displayMedium,
              ),
              actions: const [
                // Menu (...)
                PopupMenuWidget(
                  beforeExit: null,
                )
              ],
            ),
            body: RefreshIndicator(
              onRefresh: () async {
                provider.reload();
              },
              child: FutureBuilder(
                future: provider.model,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    /// Data.
                    if (snapshot.hasData) {
                      /// Tasks empty.
                      if (snapshot.data!.tasks.isEmpty) {
                        return const ScrollMessageWidget(
                          mes: 'Нет заданий.',
                          icon: Icons.notes,
                        );

                        /// Tasks.
                      } else {
                        return ListView.builder(
                          padding: const EdgeInsets.all(8),
                          itemCount: snapshot.data!.tasks.length,
                          itemBuilder: (context, index) =>
                              TaskCard(task: snapshot.data!.tasks[index]),
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
        ),
      );
}

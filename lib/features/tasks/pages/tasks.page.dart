import 'package:flutter/material.dart';
import 'package:geo_surveys_app/common/widgets/loading.widget.dart';
import 'package:geo_surveys_app/common/widgets/message.widget.dart';
import 'package:geo_surveys_app/features/tasks/controllers/tasks.controller.dart';
import 'package:geo_surveys_app/features/tasks/models/task.model.dart';
import 'package:geo_surveys_app/features/tasks/widgets/task_card.widget.dart';
import 'package:provider/provider.dart';

/// The main page with a list of all tasks in the database.
///
/// {@category Widgets}
class TasksPage extends StatelessWidget {
  const TasksPage({super.key});

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider<TasksController>(
        create: (BuildContext context) => TasksController(
          context: context,
        ),
        child: Consumer<TasksController>(
          builder: (context, provider, child) => Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).primaryColorLight,
              title: Text(
                'Задания',
                style: Theme.of(context).textTheme.displaySmall,
              ),
              actions: [
                /// Page reload.
                IconButton(
                  onPressed: () async {
                    await Navigator.popAndPushNamed(context, '/');
                  },
                  icon: const Icon(Icons.replay_outlined),
                ),
              ],
            ),
            body: FutureBuilder(
              future: provider.tasksModel.tasks,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  /// Data from the database is received.
                  if (snapshot.hasData) {
                    List<Widget> taskCards = [];
                    for (Task task in snapshot.data!) {
                      taskCards.add(
                        TaskCard(
                          task: task,
                          controller: provider,
                        ),
                      );
                    }
                    return Padding(
                      padding: const EdgeInsets.all(8),

                      /// Scrolling and cards.
                      child: SingleChildScrollView(
                        child: Column(children: taskCards),
                      ),
                    );

                    /// Error.
                  } else if (snapshot.hasError) {
                    return MessageWidget(mes: snapshot.error.toString());
                  }
                }

                /// Loading.
                return const LoadingWidget();
              },
            ),
          ),
        ),
      );
}

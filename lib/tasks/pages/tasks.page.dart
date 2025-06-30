import 'package:flutter/material.dart';
import 'package:geo_surveys_app/tasks/controllers/tasks.controller.dart';
import 'package:geo_surveys_app/tasks/models/tasks.model.dart';
import 'package:geo_surveys_app/tasks/widgets/task_card.widget.dart';
import 'package:postgres_dart/postgres_dart.dart' as pg;
import 'package:provider/provider.dart';

/// The main page with a list of all tasks in the database.
///
/// @param [db] is the geosurveys database.
/// {@category Widgets}
class TasksPage extends StatelessWidget {
  const TasksPage({super.key, required this.db});

  final pg.PostgresDb db;

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider<TasksController>(
        create: (BuildContext context) => TasksController(
          context: context,
          db: db,
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
                InkWell(
                  child: IconButton(
                    onPressed: () async {
                      await Navigator.popAndPushNamed(context, '/');
                    },
                    icon: const Icon(Icons.replay_outlined),
                  ),
                ),
              ],
            ),
            body: FutureBuilder(
              future: provider.tasksModel.tasks,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  // Ok
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
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // Scrolling
                            Expanded(
                              child: SingleChildScrollView(
                                // Content
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: taskCards),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                    // Error
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(snapshot.error.toString(),
                              style: Theme.of(context).textTheme.bodyLarge),
                        ],
                      ),
                    );
                  }
                }
                // Loading
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      );
}

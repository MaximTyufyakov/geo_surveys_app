import 'package:flutter/material.dart';
import 'package:geo_surveys_app/common/widgets/loading.widget.dart';
import 'package:geo_surveys_app/common/widgets/message.widget.dart';
import 'package:geo_surveys_app/features/tasks/models/base_task.model.dart';
import 'package:geo_surveys_app/features/tasks/viewmodels/tasks.viewmodel.dart';
import 'package:geo_surveys_app/features/tasks/widgets/task_card.widget.dart';
import 'package:provider/provider.dart';

/// The main page with a list of all tasks in the database.
class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

/// A state of task page.
class _TasksPageState extends State<TasksPage> {
  /// The arguments from the previous page.
  late Map<String, dynamic> _arguments;

  @override
  Widget build(BuildContext context) {
    /// Decoding arguments.
    _arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map<String, dynamic>;
    return ChangeNotifierProvider<TasksViewModel>(
      create: (BuildContext context) => TasksViewModel(
        userid: _arguments['userid'] as int,
      ),
      child: Consumer<TasksViewModel>(
        builder: (context, provider, child) => Scaffold(
          appBar: AppBar(
            title: Text(
              'Задания',
              style: Theme.of(context).textTheme.displayMedium,
            ),
            actions: [
              /// Page reload.
              IconButton(
                onPressed: () async {
                  provider.reloadPage(context);
                },
                icon: const Icon(Icons.replay_outlined),
              ),
            ],
          ),
          body: FutureBuilder(
            future: provider.model,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                /// Data from the database is received.
                if (snapshot.hasData) {
                  List<Widget> taskCards = [];
                  for (BaseTaskModel task in snapshot.data!.tasks) {
                    taskCards.add(
                      TaskCard(
                        task: task,
                      ),
                    );
                  }
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                    ),

                    /// Scrolling and cards.
                    child: SingleChildScrollView(
                      child: Column(
                        children: taskCards,
                      ),
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
}

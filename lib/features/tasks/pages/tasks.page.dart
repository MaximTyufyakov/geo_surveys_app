import 'package:flutter/material.dart';
import 'package:geo_surveys_app/common/widgets/loading.widget.dart';
import 'package:geo_surveys_app/common/widgets/message.widget.dart';
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
              actions: [
                // Menu (...)
                PopupMenuButton(
                  itemBuilder: (context) => [
                    // Map.
                    PopupMenuItem(
                      value: 1,
                      onTap: () {},
                      child: const Row(
                        children: [
                          Icon(Icons.wifi_off_outlined),
                          SizedBox(
                            width: 10,
                          ),
                          Text('Оффлайн-режим')
                        ],
                      ),
                    ),
                    // Map.
                    PopupMenuItem(
                      value: 1,
                      onTap: () {},
                      child: const Row(
                        children: [
                          Icon(Icons.map),
                          SizedBox(
                            width: 10,
                          ),
                          Text('Открыть карту')
                        ],
                      ),
                    ),
                    // Exit.
                    PopupMenuItem(
                      value: 2,
                      onTap: () {
                        Navigator.of(context).popUntil(
                          ModalRoute.withName(
                            '/auth',
                          ),
                        );
                      },
                      child: const Row(
                        children: [
                          Icon(Icons.logout),
                          SizedBox(
                            width: 10,
                          ),
                          Text('Выход')
                        ],
                      ),
                    ),
                  ],
                  // Смещение ниже шапки
                  // offset: const Offset(0, 60),
                ),
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
                    if (snapshot.hasData) {
                      if (snapshot.data!.tasks.isEmpty) {
                        return const MessageWidget(mes: 'Нет заданий.');
                      } else {
                        return ListView.builder(
                          padding: const EdgeInsets.all(8),
                          itemCount: snapshot.data!.tasks.length,
                          itemBuilder: (context, index) =>
                              TaskCard(task: snapshot.data!.tasks[index]),
                        );
                      }
                    } else {
                      return MessageWidget(
                        mes: snapshot.error.toString(),
                      );
                    }
                  } else {
                    return const LoadingWidget();
                  }
                },
              ),
            ),
          ),
        ),
      );
}

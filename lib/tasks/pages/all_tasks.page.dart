import 'package:flutter/material.dart';
import 'package:geo_surveys_app/tasks/controllers/all_tasks.controller.dart';
import 'package:provider/provider.dart';

class AllTasksPage extends StatelessWidget {
  const AllTasksPage({super.key});

  @override
  Widget build(BuildContext context) =>
      ChangeNotifierProvider<AllTasksController>(
        create: (BuildContext context) => AllTasksController(context: context),
        child: Consumer<AllTasksController>(
          builder: (context, provider, child) => const Scaffold(
            body: Center(
              child: Text('Hello World!'),
            ),
          ),
        ),
      );
}

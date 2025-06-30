import 'package:flutter/material.dart';
import 'package:geo_surveys_app/tasks/controllers/all_tasks.controller.dart';
import 'package:postgres_dart/postgres_dart.dart' as pg;
import 'package:provider/provider.dart';

/// The main page with a list of all tasks in the database.
///
/// @param [db] is the geosurveys database.
/// {@category Widgets}
class AllTasksPage extends StatelessWidget {
  const AllTasksPage({super.key, required this.db});

  final pg.PostgresDb db;

  @override
  Widget build(BuildContext context) =>
      ChangeNotifierProvider<AllTasksController>(
        create: (BuildContext context) => AllTasksController(
          context: context,
          db: db,
        ),
        child: Consumer<AllTasksController>(
          builder: (context, provider, child) => Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).primaryColorLight,
              title: Text(
                'Задания',
                style: Theme.of(context).textTheme.displaySmall,
              ),
            ),
          ),
        ),
      );
}

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
        create: (BuildContext context) => AllTasksController(context: context),
        child: Consumer<AllTasksController>(
          builder: (context, provider, child) => Scaffold(
            // Панель сверху
            appBar: AppBar(
                // Заголовок
                backgroundColor: Theme.of(context).primaryColorLight,
                title: InkWell(
                  onTap: () {},
                  child: Icon(Icons.abc_rounded),
                )),
          ),
        ),
      );
}

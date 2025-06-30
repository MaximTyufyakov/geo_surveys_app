import 'package:flutter/material.dart';
import 'package:geo_surveys_app/tasks/models/all_tasks.model.dart';
import 'package:postgres_dart/postgres_dart.dart' as pg;

/// The controller of the main page.
///
/// @param [context] is the context of the main page widget.
/// @param [db] is the geosurveys database.
/// {@category Controllers}
class AllTasksController extends ChangeNotifier {
  AllTasksController({required this.context, required this.db})
      : tasksModel = AllTasksModel(
          db: db,
        );
  final BuildContext context;
  final pg.PostgresDb db;

  // Models
  final AllTasksModel tasksModel;
}

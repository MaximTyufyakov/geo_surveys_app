import 'package:flutter/material.dart';
import 'package:geo_surveys_app/tasks/models/tasks.model.dart';
import 'package:postgres_dart/postgres_dart.dart' as pg;

/// The controller of the tasks.
///
/// @param [context] is the context of the main page widget.
/// @param [db] is the geosurveys database.
/// {@category Controllers}
class TasksController extends ChangeNotifier {
  TasksController({required this.context, required this.db})
      : tasksModel = TasksModel(
          db: db,
        );
  final BuildContext context;
  final pg.PostgresDb db;

  // Models
  final TasksModel tasksModel;
}

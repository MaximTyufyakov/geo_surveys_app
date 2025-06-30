import 'package:flutter/material.dart';
import 'package:geo_surveys_app/tasks/models/all_tasks.model.dart';

class AllTasksController extends ChangeNotifier {
  AllTasksController({required this.context}) : tasksModel = AllTasksModel();
  final BuildContext context;

  // Models
  AllTasksModel tasksModel;
}

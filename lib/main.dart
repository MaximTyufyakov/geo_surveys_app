import 'package:flutter/material.dart';
import 'package:geo_surveys_app/tasks/pages/all_tasks.page.dart';
import 'package:postgres_dart/postgres_dart.dart';

void main() async {
  var db = PostgresDb(
    host: '10.0.2.2',
    databaseName: 'geosurveys',
    username: 'postgres',
    password: 'admin',
  );
  await db.open();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) => const MaterialApp(home: AllTasksPage());
}

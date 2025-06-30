import 'package:flutter/material.dart';
import 'package:geo_surveys_app/tasks/pages/all_tasks.page.dart';
import 'package:postgres_dart/postgres_dart.dart' as pg;

/// Main entry point to the app.
void main() async {
  /// Connect to geosurveys database.
  pg.PostgresDb db = pg.PostgresDb(
    host: '10.0.2.2',
    databaseName: 'geosurveys',
    username: 'postgres',
    password: 'admin',
  );
  await db.open();

  runApp(
    MainApp(
      db: db,
    ),
  );
}

/// Main widget.
///
/// @param [db] is the geosurveys database.
/// {@category Widgets}
class MainApp extends StatelessWidget {
  const MainApp({super.key, required this.db});
  final pg.PostgresDb db;

  static const dColor = Colors.brown;
  static final scaffoldColor = Colors.deepOrange[100];
  static const splashColor = Color.fromARGB(255, 206, 162, 120);

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Геоконтролируемые съёмки',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.deepOrange,
          splashColor: splashColor,
          // ThemeData do not run through colors' params.
          // ignore: no-equal-arguments
          highlightColor: splashColor,
          fontFamily: 'Vinque Rg',

          /// Text style hierarchy.
          ///
          /// Each style has 3 scale: large, medium and small.
          ///
          /// * display
          /// * headline
          /// * title
          /// * body
          /// * label
          textTheme: const TextTheme(
            /// Default text style.
            displayLarge: TextStyle(
              color: dColor,
              fontSize: 36,
            ),
            displaySmall: TextStyle(
              color: dColor,
              fontSize: 24,
            ),
            headlineMedium: TextStyle(
              fontSize: 20,
            ),
            titleMedium: TextStyle(
              fontSize: 18,
            ),
            bodyMedium: TextStyle(
              fontSize: 16,
            ),
          ),

          scaffoldBackgroundColor: scaffoldColor,
        ),
        home: AllTasksPage(
          db: db,
        ),
      );
}

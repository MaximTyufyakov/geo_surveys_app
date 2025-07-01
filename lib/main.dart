import 'package:flutter/material.dart';
import 'package:geo_surveys_app/features/tasks/pages/task.page.dart';
import 'package:geo_surveys_app/features/tasks/pages/tasks.page.dart';

/// Main entry point to the app.
void main() async {
  runApp(
    const MainApp(),
  );
}

/// Main widget.
///
/// {@category Widgets}
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  static const _primaryColor = Colors.deepOrange;
  static const _displayColor = Colors.brown;
  static const _scaffoldColor = Color.fromARGB(255, 255, 233, 226);
  static const _splashColor = Color.fromARGB(121, 177, 139, 103);
  static const _buttonBColor = Color.fromARGB(121, 206, 162, 120);
  static const _buttonFColor = Colors.black54;

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Геоконтролируемые съёмки',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: _primaryColor,
          primarySwatch: _primaryColor,
          splashColor: _splashColor,
          highlightColor: _splashColor,
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
              color: _displayColor,
              fontSize: 36,
            ),
            displaySmall: TextStyle(
              color: _displayColor,
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

          /// Buttons style.
          filledButtonTheme: FilledButtonThemeData(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all<Color>(_buttonBColor),
              foregroundColor: WidgetStateProperty.all<Color>(
                _buttonFColor,
              ),
            ),
          ),
          iconButtonTheme: IconButtonThemeData(
            style: ButtonStyle(
              foregroundColor: WidgetStateProperty.all<Color>(
                _buttonFColor,
              ),
            ),
          ),

          scaffoldBackgroundColor: _scaffoldColor,
        ),
        routes: {
          // '/': (_) => TasksPage(),
          '/tasks': (_) => const TasksPage(),
          '/task': (_) => const TaskPage(),
          // '/requisition': (_) => RequisitionPage(),
        },
        initialRoute: '/tasks',
      );
}

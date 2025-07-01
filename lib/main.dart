import 'package:flutter/material.dart';
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

  static const displayColor = Colors.brown;
  static const scaffoldColor = Color.fromARGB(255, 255, 233, 226);
  static const splashColor = Color.fromARGB(121, 177, 139, 103);
  static const buttonBColor = Color.fromARGB(121, 206, 162, 120);
  static const buttonFColor = Colors.black54;

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Геоконтролируемые съёмки',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.deepOrange,
          splashColor: splashColor,
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
              color: displayColor,
              fontSize: 36,
            ),
            displaySmall: TextStyle(
              color: displayColor,
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
              backgroundColor: WidgetStateProperty.all<Color>(buttonBColor),
              foregroundColor: WidgetStateProperty.all<Color>(
                buttonFColor,
              ),
            ),
          ),
          iconButtonTheme: IconButtonThemeData(
            style: ButtonStyle(
              foregroundColor: WidgetStateProperty.all<Color>(
                buttonFColor,
              ),
            ),
          ),

          scaffoldBackgroundColor: scaffoldColor,
        ),
        routes: {
          '/': (_) => TasksPage(),
          // '/tasks': (_) => TasksListPage(),
          // '/requisition': (_) => RequisitionPage(),
        },
        initialRoute: '/',
      );
}

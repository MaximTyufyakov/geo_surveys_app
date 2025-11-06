import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geo_surveys_app/features/auth/pages/auth.page.dart';
import 'package:geo_surveys_app/features/task/pages/task.page.dart';
import 'package:geo_surveys_app/features/tasks/pages/tasks.page.dart';
import 'package:geo_surveys_app/features/video_shoot/pages/video_shoot.page.dart';

/// Main entry point to the app.
void main() async {
  /// Load dotenv.
  await dotenv.load(fileName: 'assets/.env');
  runApp(
    const MainApp(),
  );
}

/// Main widget.
class MainApp extends StatelessWidget {
  const MainApp({
    super.key,
  });

  /// Main Color.
  static const _primaryColor = Colors.deepOrange;

  /// Display text color.
  static const _displayColor = Colors.brown;

  /// Scaffold background color.
  static final _scaffoldColor = _primaryColor[50];

  /// App background color.
  static final _appBarColor = _primaryColor[100];

  /// On element tap color.
  static const _splashColor = Color.fromARGB(121, 177, 139, 103);

  /// Buttons background color.
  static const _buttonBColor = Color.fromARGB(121, 206, 162, 120);

  /// Buttons text and icon color.
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
            displayMedium: TextStyle(
              color: _displayColor,
              fontSize: 24,
            ),
            displaySmall: TextStyle(
              color: _displayColor,
              fontSize: 20,
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

          /// Buttons styles.
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
          checkboxTheme: const CheckboxThemeData(
            fillColor: WidgetStateProperty.fromMap(
              <WidgetStatesConstraint, Color?>{
                WidgetState.selected: _primaryColor,
              },
            ),
          ),

          /// Input styles.
          inputDecorationTheme: const InputDecorationTheme(
            border: OutlineInputBorder(),
            fillColor: Colors.white,
            filled: true,
            suffixIconColor: _primaryColor,
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: _primaryColor,
              ),
            ),
          ),
          textSelectionTheme: TextSelectionThemeData(
            cursorColor: _primaryColor,
            selectionHandleColor: _primaryColor,
            selectionColor: _primaryColor[100],
          ),

          /// Scaffold and navigation styles.
          scaffoldBackgroundColor: _scaffoldColor,
          appBarTheme: AppBarTheme(
            backgroundColor: _appBarColor,
          ),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: _appBarColor,
            selectedItemColor: _primaryColor,
          ),
          progressIndicatorTheme: const ProgressIndicatorThemeData(
            color: _primaryColor,
          ),
        ),
        routes: {
          '/': (_) => const AuthPage(),
          '/tasks': (_) => const TasksPage(),
          '/task': (_) => const TaskPage(),
          '/video_shoot': (_) => const VideoShootPage(),
        },
        initialRoute: '/',
      );
}

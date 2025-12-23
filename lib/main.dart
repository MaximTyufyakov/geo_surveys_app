import 'package:flutter/material.dart';
import 'package:geo_surveys_app/features/auth/pages/auth.page.dart';

/// Main entry point to the app.
void main() {
  runApp(const MainApp());
}

/// Main widget.
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  /// Seed color.
  static const _seedColor = Colors.orange;

  /// Main Color.
  static const _primaryColor = Colors.deepOrange;

  /// App background color.
  static final _appBarColorLight = _primaryColor[100];
  static final _appBarColorDark = Colors.grey[850];

  // Base theme (light and dark).
  static ThemeData _baseTheme(Brightness brightness) => ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: _seedColor,
      primary: _primaryColor,
      brightness: brightness,
    ),
    useMaterial3: true,
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
      displayMedium: TextStyle(fontSize: 26),
      headlineMedium: TextStyle(fontSize: 20),
      titleMedium: TextStyle(fontSize: 18),
      bodyMedium: TextStyle(fontSize: 16),
      bodySmall: TextStyle(fontSize: 14),
    ),

    // Input style.
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(),
    ),
  );

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Геоконтролируемые съёмки',
    debugShowCheckedModeBanner: false,

    /// Light theme.
    theme: _baseTheme(Brightness.light).copyWith(
      /// Bars styles.
      appBarTheme: AppBarTheme(backgroundColor: _appBarColorLight),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: _appBarColorLight,
      ),
    ),

    /// Dark theme.
    darkTheme: _baseTheme(Brightness.dark).copyWith(
      /// Bars styles.
      appBarTheme: AppBarTheme(backgroundColor: _appBarColorDark),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: _appBarColorDark,
      ),
    ),

    /// Init page.
    home: const AuthPage(),
  );
}

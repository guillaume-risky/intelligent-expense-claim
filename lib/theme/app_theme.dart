import 'package:flutter/material.dart';

class AppTheme {
  static const Color navyStart = Color(0xFF0B132B);
  static const Color navyEnd = Color(0xFF1C2541);

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: navyStart,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
    ),
  );

  static BoxDecoration backgroundGradient = const BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        navyStart,
        navyEnd,
      ],
    ),
  );
}

import 'package:flutter/material.dart';

class AppTheme {
  // ☀️ Light Coffee Theme
  static ThemeData light = ThemeData(
    brightness: Brightness.light,
    primaryColor: const Color(0xFF6F4E37), // Coffee Brown
    scaffoldBackgroundColor: const Color(0xFFF5EFE6), // Cream
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF6F4E37),
      foregroundColor: Colors.white,
      elevation: 2,
    ),
    cardColor: Colors.white,
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xFF6F4E37),
    ),
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF6F4E37),
      brightness: Brightness.light,
    ),
  );

  // 🌙 Dark Coffee Theme
  static ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    primaryColor: const Color(0xFF3E2723), // Dark Espresso
    scaffoldBackgroundColor: const Color(0xFF1E1E1E),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF3E2723),
      foregroundColor: Colors.white,
      elevation: 2,
    ),
    cardColor: const Color(0xFF2C2C2C),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xFF3E2723),
    ),
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF3E2723),
      brightness: Brightness.dark,
    ),
  );
}

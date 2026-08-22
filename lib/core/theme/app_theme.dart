import 'package:flutter/material.dart';

class AppTheme {
  // ☀️ LIGHT THEME
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorSchemeSeed: Colors.green,
    scaffoldBackgroundColor: Colors.white,
    brightness: Brightness.light,
  );

  // 🌙 DARK THEME
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorSchemeSeed: Colors.green,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF121212),

    cardTheme: CardThemeData(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
    ),

    appBarTheme: const AppBarTheme(
      centerTitle: false,
    ),

    navigationBarTheme: NavigationBarThemeData(
      elevation: 3,
      height: 70,
      indicatorShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
    ),
  );

  // 🔵 OCEAN THEME
  static ThemeData oceanTheme = ThemeData(
    useMaterial3: true,
    colorSchemeSeed: Colors.blue,
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFF4F9FF),

    cardTheme: CardThemeData(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
    ),

    appBarTheme: const AppBarTheme(
      centerTitle: false,
    ),

    navigationBarTheme: NavigationBarThemeData(
      elevation: 3,
      height: 70,
      indicatorShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
    ),
  );
}
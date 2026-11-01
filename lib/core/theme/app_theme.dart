
import 'package:flutter/material.dart';

class AppTheme {
  // LIGHT THEME
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorSchemeSeed: Colors.green,
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
  );

  // DARK THEME
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
  );

  // OCEAN THEME
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
  );

  // TRANSPARENT GLASS THEME
  static ThemeData glassTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF7C83FD),
      brightness: Brightness.light,
      surface: const Color(0xFFEAF0FF),
    ),
    scaffoldBackgroundColor: const Color(0xFFEAF0FF),

    cardColor: const Color(0xBFFFFFFF),

    cardTheme: CardThemeData(
      color: const Color(0xBFFFFFFF),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(
          color: Colors.white.withOpacity(0.8),
          width: 1.2,
        ),
      ),
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
    ),

    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: const Color(0xBFFFFFFF),
      elevation: 0,
      height: 75,
      indicatorColor: const Color(0x337C83FD),
      indicatorShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF777DF4),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 14,
        ),
      ),
    ),
  );
}

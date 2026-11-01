<<<<<<< HEAD

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
=======
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
>>>>>>> 8c6adcddfc657ba0464891256e4e0998a4836294
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorSchemeSeed: Colors.green,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF121212),
<<<<<<< HEAD
=======

>>>>>>> 8c6adcddfc657ba0464891256e4e0998a4836294
    cardTheme: CardThemeData(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
    ),
<<<<<<< HEAD
  );

  // OCEAN THEME
=======

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
>>>>>>> 8c6adcddfc657ba0464891256e4e0998a4836294
  static ThemeData oceanTheme = ThemeData(
    useMaterial3: true,
    colorSchemeSeed: Colors.blue,
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFF4F9FF),
<<<<<<< HEAD
=======

>>>>>>> 8c6adcddfc657ba0464891256e4e0998a4836294
    cardTheme: CardThemeData(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
    ),
<<<<<<< HEAD
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
=======

    appBarTheme: const AppBarTheme(
>>>>>>> 8c6adcddfc657ba0464891256e4e0998a4836294
      centerTitle: false,
    ),

    navigationBarTheme: NavigationBarThemeData(
<<<<<<< HEAD
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
=======
      elevation: 3,
      height: 70,
      indicatorShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
    ),
  );
}
>>>>>>> 8c6adcddfc657ba0464891256e4e0998a4836294

<<<<<<< HEAD

=======
>>>>>>> 8c6adcddfc657ba0464891256e4e0998a4836294
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  bool _oceanTheme = false;
<<<<<<< HEAD
  bool get oceanTheme => _oceanTheme;

  bool _glassTheme = false;
  bool get glassTheme => _glassTheme;

  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTheme = prefs.getString('app_theme');

    _oceanTheme = savedTheme == 'ocean';
    _glassTheme = savedTheme == 'glass';

    if (savedTheme == 'dark') {
      _themeMode = ThemeMode.dark;
    } else {
      _themeMode = ThemeMode.light;
=======

  bool get oceanTheme => _oceanTheme;

  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();

    final savedTheme = prefs.getString('app_theme');

    if (savedTheme == 'dark') {
      _themeMode = ThemeMode.dark;
      _oceanTheme = false;
    } else if (savedTheme == 'ocean') {
      _themeMode = ThemeMode.light;
      _oceanTheme = true;
    } else {
      _themeMode = ThemeMode.light;
      _oceanTheme = false;
>>>>>>> 8c6adcddfc657ba0464891256e4e0998a4836294
    }

    notifyListeners();
  }

  Future<void> setTheme(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();

    _oceanTheme = false;
<<<<<<< HEAD
    _glassTheme = false;
    _themeMode = mode;

    await prefs.setString(
      'app_theme',
      mode == ThemeMode.dark ? 'dark' : 'light',
    );
=======
    _themeMode = mode;

    if (mode == ThemeMode.dark) {
      await prefs.setString('app_theme', 'dark');
    } else {
      await prefs.setString('app_theme', 'light');
    }
>>>>>>> 8c6adcddfc657ba0464891256e4e0998a4836294

    notifyListeners();
  }

  Future<void> setOceanTheme() async {
    final prefs = await SharedPreferences.getInstance();

    _oceanTheme = true;
<<<<<<< HEAD
    _glassTheme = false;
=======
>>>>>>> 8c6adcddfc657ba0464891256e4e0998a4836294
    _themeMode = ThemeMode.light;

    await prefs.setString('app_theme', 'ocean');

    notifyListeners();
  }
<<<<<<< HEAD

  Future<void> setGlassTheme() async {
    final prefs = await SharedPreferences.getInstance();

    _glassTheme = true;
    _oceanTheme = false;
    _themeMode = ThemeMode.light;

    await prefs.setString('app_theme', 'glass');

    notifyListeners();
  }
}

final themeController = ThemeController();
=======
}

final themeController = ThemeController();
>>>>>>> 8c6adcddfc657ba0464891256e4e0998a4836294

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  bool _oceanTheme = false;

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
    }

    notifyListeners();
  }

  Future<void> setTheme(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();

    _oceanTheme = false;
    _themeMode = mode;

    if (mode == ThemeMode.dark) {
      await prefs.setString('app_theme', 'dark');
    } else {
      await prefs.setString('app_theme', 'light');
    }

    notifyListeners();
  }

  Future<void> setOceanTheme() async {
    final prefs = await SharedPreferences.getInstance();

    _oceanTheme = true;
    _themeMode = ThemeMode.light;

    await prefs.setString('app_theme', 'ocean');

    notifyListeners();
  }
}

final themeController = ThemeController();
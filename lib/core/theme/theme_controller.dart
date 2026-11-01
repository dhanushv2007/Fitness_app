
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  bool _oceanTheme = false;
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
    }

    notifyListeners();
  }

  Future<void> setTheme(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();

    _oceanTheme = false;
    _glassTheme = false;
    _themeMode = mode;

    await prefs.setString(
      'app_theme',
      mode == ThemeMode.dark ? 'dark' : 'light',
    );

    notifyListeners();
  }

  Future<void> setOceanTheme() async {
    final prefs = await SharedPreferences.getInstance();

    _oceanTheme = true;
    _glassTheme = false;
    _themeMode = ThemeMode.light;

    await prefs.setString('app_theme', 'ocean');

    notifyListeners();
  }

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

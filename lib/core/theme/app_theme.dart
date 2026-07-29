import 'package:flutter/material.dart';//for flutter to understand that the code is for theme

class AppTheme {//class creation to keep the theme elements together 
  static ThemeData lightTheme = ThemeData(//for light theme
    useMaterial3: true,//to use google latest material design
    colorSchemeSeed: Colors.green,
    scaffoldBackgroundColor: Colors.white,
    brightness: Brightness.light,
  );
}

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';
import 'features/auth/services/auth_wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await themeController.loadTheme();

  runApp(const FitnessApp());
}

class FitnessApp extends StatefulWidget {
  const FitnessApp({super.key});

  @override
  State<FitnessApp> createState() => _FitnessAppState();
}

class _FitnessAppState extends State<FitnessApp> {
  @override
  void initState() {
    super.initState();
    themeController.addListener(_onThemeChanged);
  }

  void _onThemeChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    themeController.removeListener(_onThemeChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fitness App',

      theme: themeController.glassTheme
          ? AppTheme.glassTheme
          : themeController.oceanTheme
              ? AppTheme.oceanTheme
              : AppTheme.lightTheme,

      darkTheme: AppTheme.darkTheme,

      themeMode: (themeController.glassTheme ||
              themeController.oceanTheme)
          ? ThemeMode.light
          : themeController.themeMode,

      home: const AuthWrapper(),
    );
  }
}

<<<<<<< HEAD

=======
import 'core/theme/theme_controller.dart';
>>>>>>> 8c6adcddfc657ba0464891256e4e0998a4836294
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'core/theme/app_theme.dart';
<<<<<<< HEAD
import 'core/theme/theme_controller.dart';
=======
>>>>>>> 8c6adcddfc657ba0464891256e4e0998a4836294
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
<<<<<<< HEAD
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
=======
  
>>>>>>> 8c6adcddfc657ba0464891256e4e0998a4836294

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fitness App',

<<<<<<< HEAD
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
=======
      theme: AppTheme.lightTheme,

      darkTheme: AppTheme.darkTheme,

      themeMode: themeController.themeMode,
>>>>>>> 8c6adcddfc657ba0464891256e4e0998a4836294

      home: const AuthWrapper(),
    );
  }
<<<<<<< HEAD
}
=======
}
>>>>>>> 8c6adcddfc657ba0464891256e4e0998a4836294

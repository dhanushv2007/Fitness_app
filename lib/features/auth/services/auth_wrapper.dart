import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


import '../../profile/profile_service.dart';
import '../../profile/profile_setup_screen.dart';
import '../login_screen.dart';
import '../../main/main_screen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, authSnapshot) {
        if (authSnapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (!authSnapshot.hasData) {
          return const LoginScreen();
        }

        return FutureBuilder(
          future: ProfileService().getProfile(),
          builder: (context, profileSnapshot) {
            if (profileSnapshot.connectionState ==
                ConnectionState.waiting) {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            if (profileSnapshot.data == null) {
              return const ProfileSetupScreen();
            }

            return const MainScreen();
          },
        );
      },
    );
  }
}
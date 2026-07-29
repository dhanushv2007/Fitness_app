import 'package:flutter/material.dart';
import '../onboarding/onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();

    Future.delayed(
      const Duration(seconds: 3),
      () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const OnboardingScreen(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: const [

            Icon(
              Icons.fitness_center,
              color: Colors.white,
              size: 120,
            ),

            SizedBox(height: 20),

            Text(
              "Fitness App",
              style: TextStyle(
                fontSize: 34,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 10),

            Text(
              "Your Health, Your Journey",
              style: TextStyle(
                fontSize: 18,
                color: Colors.white70,
              ),
            ),

          ],
        ),
      ),
    );
  }
}
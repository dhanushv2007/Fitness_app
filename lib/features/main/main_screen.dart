import 'package:flutter/material.dart';

import '../dashboard/dashboard_screen.dart';
import '../meals/meals_screen.dart';
import '../profile/profile_screen.dart';
import '../progress/progress_screen.dart';
import '../workout/workout_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;

  late final List<Widget> screens;

  @override
  void initState() {
    super.initState();

    screens = [
      DashboardScreen(),
      const MealsScreen(),
      const WorkoutScreen(),
      const ProgressScreen(),
      const ProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: screens,
      ),

      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,

        onDestinationSelected: (index) {
          setState(() {
            currentIndex = index;
          });
        },

        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: "Home",
          ),

          NavigationDestination(
            icon: Icon(Icons.restaurant_menu_outlined),
            selectedIcon: Icon(Icons.restaurant_menu),
            label: "Meals",
          ),

          NavigationDestination(
            icon: Icon(Icons.fitness_center_outlined),
            selectedIcon: Icon(Icons.fitness_center),
            label: "Workout",
          ),

          NavigationDestination(
            icon: Icon(Icons.show_chart_outlined),
            selectedIcon: Icon(Icons.show_chart),
            label: "Progress",
          ),

          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../auth/login_screen.dart';
import '../profile/profile_model.dart';
import '../profile/profile_service.dart';
import 'dashboard_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final ProfileService _profileService = ProfileService();

  UserProfile? userProfile;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    try {
      final profile = await _profileService.getProfile();

      if (!mounted) return;

      setState(() {
        userProfile = profile;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  double calculateBMI() {
    if (userProfile == null) return 0;

    double heightInMeters = userProfile!.height / 100;

    return userProfile!.weight /
        (heightInMeters * heightInMeters);
  }

  String greeting() {
    final hour = DateTime.now().hour;

    if (hour < 12) {
      return "Good Morning";
    } else if (hour < 17) {
      return "Good Afternoon";
    } else {
      return "Good Evening";
    }
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const LoginScreen(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xffF7F8FA),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          "Fitness Tracker",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: logout,
          ),
        ],
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              Text(
                "${greeting()} 👋",
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 5),

              Text(
                userProfile?.name ?? "User",
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                "Let's achieve your fitness goals today 💪",
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 30),

              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 1.15,

                children: [

                  DashboardCard(
                    title: "Calories",
                    value: "2200 kcal",
                    icon: Icons.local_fire_department,
                    color: Colors.orange,
                  ),

                  DashboardCard(
                    title: "Water",
                    value: "0 / 3 L",
                    icon: Icons.water_drop,
                    color: Colors.blue,
                  ),

                  DashboardCard(
                    title: "Weight",
                    value:
                        "${userProfile?.weight.toStringAsFixed(1) ?? "0"} kg",
                    icon: Icons.monitor_weight,
                    color: Colors.green,
                  ),

                  DashboardCard(
                    title: "BMI",
                    value: calculateBMI().toStringAsFixed(1),
                    icon: Icons.favorite,
                    color: Colors.red,
                  ),
                ],
              ),

              const SizedBox(height: 30),

              const Text(
                "Today's Meals",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 15),

              Card(
                child: ListTile(
                  leading: const Icon(Icons.free_breakfast),
                  title: const Text("Breakfast"),
                  trailing: const Icon(Icons.add),
                  onTap: () {},
                ),
              ),

              Card(
                child: ListTile(
                  leading: const Icon(Icons.lunch_dining),
                  title: const Text("Lunch"),
                  trailing: const Icon(Icons.add),
                  onTap: () {},
                ),
              ),

              Card(
                child: ListTile(
                  leading: const Icon(Icons.dinner_dining),
                  title: const Text("Dinner"),
                  trailing: const Icon(Icons.add),
                  onTap: () {},
                ),
              ),

              Card(
                child: ListTile(
                  leading: const Icon(Icons.cookie),
                  title: const Text("Snacks"),
                  trailing: const Icon(Icons.add),
                  onTap: () {},
                ),
              ),

              const SizedBox(height: 30),

              const Text(
                "Today's Workout",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 15),

              Card(
                child: ListTile(
                  leading: const Icon(Icons.fitness_center),
                  title: const Text("No workout added"),
                  subtitle: const Text(
                    "Tap to add today's workout",
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
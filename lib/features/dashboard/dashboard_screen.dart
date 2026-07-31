
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
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  double calculateBMI() {
    if (userProfile == null) return 0;
    final h = userProfile!.height / 100;
    return userProfile!.weight / (h * h);
  }

  String greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return "Good Morning";
    if (hour < 17) return "Good Afternoon";
    return "Good Evening";
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (_) => false,
    );
  }

  Widget mealCard(IconData icon, String title, Color color) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(.15),
          child: Icon(icon, color: color),
        ),
        title: Text(title),
        subtitle: const Text("No meal added"),
        trailing: const Icon(Icons.add_circle_outline),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xffF5F7FA),
      appBar: AppBar(
        title: const Text("Fitness Tracker"),
        actions: [
          IconButton(
            onPressed: logout,
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: const LinearGradient(
                  colors: [Color(0xff43A047), Color(0xff2E7D32)],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${greeting()} 👋",
                      style: const TextStyle(color: Colors.white70)),
                  const SizedBox(height: 6),
                  Text(
                    userProfile?.name ?? "User",
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 30),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Let's achieve your fitness goals today 💪",
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              children: [
                DashboardCard(title:"Calories",value:"0 / 2200 kcal",icon:Icons.local_fire_department,color:Colors.orange),
                DashboardCard(title:"Water",value:"0 / 3 L",icon:Icons.water_drop,color:Colors.blue),
                DashboardCard(title:"Weight",value:"${userProfile?.weight.toStringAsFixed(1) ?? "0"} kg",icon:Icons.monitor_weight,color:Colors.green),
                DashboardCard(title:"BMI",value:calculateBMI().toStringAsFixed(1),icon:Icons.favorite,color:Colors.red),
                DashboardCard(title:"Steps",value:"0",icon:Icons.directions_walk,color:Colors.deepPurple),
                DashboardCard(title:"Streak",value:"1 Day",icon:Icons.emoji_events,color:Colors.amber),
              ],
            ),
            const SizedBox(height:24),
            const Text("Today's Meals",style:TextStyle(fontSize:22,fontWeight:FontWeight.bold)),
            const SizedBox(height:12),
            mealCard(Icons.free_breakfast,"Breakfast",Colors.orange),
            mealCard(Icons.lunch_dining,"Lunch",Colors.green),
            mealCard(Icons.dinner_dining,"Dinner",Colors.blue),
            mealCard(Icons.cookie,"Snacks",Colors.deepPurple),
            const SizedBox(height:24),
            const Text("Today's Workout",style:TextStyle(fontSize:22,fontWeight:FontWeight.bold)),
            const SizedBox(height:12),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: const ListTile(
                leading: Icon(Icons.fitness_center),
                title: Text("No Workout Added"),
                subtitle: Text("Tap to add today's workout"),
                trailing: Icon(Icons.chevron_right),
              ),
            ),
            const SizedBox(height:30),
          ],
        ),
      ),
    );
  }
}

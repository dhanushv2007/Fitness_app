
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../water/water_screen.dart';
import '../../utils/calorie_calculator.dart';
import 'dashboard_service.dart';
import '../../models/dashboard_stats.dart';
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
  final DashboardService _dashboardService = DashboardService();

DashboardStats? dashboardStats;

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
      final stats = await _dashboardService.loadDashboard();
      if (!mounted) return;
      setState(() {
        userProfile = profile;
        dashboardStats = stats;
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

  final heightInMeters = userProfile!.height / 100;

  return userProfile!.weight /
      (heightInMeters * heightInMeters);
}

  double calculateDailyCalories() {
  if (userProfile == null) return 0;

  return CalorieCalculator.calculateCalories(
    age: userProfile!.age,
    height: userProfile!.height,
    weight: userProfile!.weight,
    gender: userProfile!.gender,
    goal: userProfile!.goal,
    activityLevel: userProfile!.activityLevel,
  );
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
  elevation: 0,
  backgroundColor: Colors.transparent,
  surfaceTintColor: Colors.transparent,
  title: const Text(
    "Dashboard",
    style: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.bold,
    ),
  ),
  actions: [
    IconButton(
      icon: const Icon(Icons.notifications_none_rounded),
      onPressed: () {
        // We'll add notifications later
      },
    ),
    IconButton(
      icon: const Icon(Icons.logout),
      onPressed: logout,
    ),
  ],
),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
  width: double.infinity,
  padding: const EdgeInsets.all(25),
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(30),
    gradient: const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xff22C55E),
        Color(0xff15803D),
      ],
    ),
    boxShadow: [
      BoxShadow(
        color: Colors.green.withOpacity(0.35),
        blurRadius: 20,
        offset: const Offset(0, 8),
      ),
    ],
  ),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [

      Row(
        children: [
          const CircleAvatar(
            radius: 28,
            backgroundColor: Colors.white,
            child: Icon(
              Icons.person,
              color: Colors.green,
              size: 30,
            ),
          ),

          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  greeting(),
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),

                Text(
                  userProfile?.name ?? "User",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      const SizedBox(height: 30),

      const Text(
        "Today's Calories",
        style: TextStyle(
          color: Colors.white70,
          fontSize: 15,
        ),
      ),

      const SizedBox(height: 10),

      ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: LinearProgressIndicator(
          value: (dashboardStats?.caloriesConsumed ?? 0) /
              calculateDailyCalories(),
          minHeight: 12,
          backgroundColor: Colors.white24,
          valueColor:
              const AlwaysStoppedAnimation(Colors.white),
        ),
      ),

      const SizedBox(height: 15),

      Text(
        "${dashboardStats?.caloriesConsumed.toStringAsFixed(0) ?? 0} / ${calculateDailyCalories().toStringAsFixed(0)} kcal",
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
      ),

      const SizedBox(height: 8),

      const Text(
        "Stay consistent. Every workout counts! 💪",
        style: TextStyle(
          color: Colors.white70,
        ),
      ),
    ],
  ),
),
            const SizedBox(height: 24),
            GridView.builder(
  shrinkWrap: true,
  physics: const NeverScrollableScrollPhysics(),

  gridDelegate:
      const SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    crossAxisSpacing: 18,
    mainAxisSpacing: 18,
    childAspectRatio: .95,
  ),

  itemCount: 6,

  itemBuilder: (context, index) {

    final cards = [

      DashboardCard(
        title: "Calories",
        value:
            "${dashboardStats?.caloriesConsumed.toStringAsFixed(0) ?? 0}",
        icon: Icons.local_fire_department,
        color: Colors.orange,
      ),

      DashboardCard(
        title: "Water",
        value:
            "${dashboardStats?.waterConsumed.toStringAsFixed(1) ?? 0} L",
        icon: Icons.water_drop,
        color: Colors.blue,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const WaterScreen(),
            ),
          ).then((_) => loadProfile());
        },
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

      DashboardCard(
        title: "Steps",
        value: "0",
        icon: Icons.directions_walk,
        color: Colors.deepPurple,
      ),

      DashboardCard(
        title: "Streak",
        value: "1 Day",
        icon: Icons.emoji_events,
        color: Colors.amber,
      ),

    ];

    return cards[index];
  },
),

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

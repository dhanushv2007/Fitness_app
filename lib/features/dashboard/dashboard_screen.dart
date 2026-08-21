
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../water/water_screen.dart';
import '../../utils/calorie_calculator.dart';
import 'dashboard_service.dart';
import '../../models/dashboard_stats.dart';
import '../auth/login_screen.dart';
import '../profile/profile_model.dart';
import '../profile/profile_service.dart';
import 'dashboard_card.dart';
import '../meals/add_meal_screen.dart';
import '../meals/models/meal_model.dart';
import '../meals/services/meal_service.dart';
import '../steps/step_screen.dart';
import '../steps/step_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DashboardScreen extends StatefulWidget {
  final VoidCallback? onRefresh;

  const DashboardScreen({
    super.key,
    this.onRefresh,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final ProfileService _profileService = ProfileService();
  final DashboardService _dashboardService = DashboardService();
  final MealService _mealService = MealService();
  final StepService _stepService = StepService();

DashboardStats? dashboardStats;

List<MealModel> todaysMeals = [];
int todaySteps = 0;

UserProfile? userProfile;
  bool isLoading = true;

 @override
void initState() {
  super.initState();

  loadProfile();
  loadTodaysMeals();

_stepService.startStepTracking(
  onStepsChanged: (steps) {
    if (!mounted) return;

    setState(() {
      todaySteps = steps;
    });
  },
  onError: (error) {
    debugPrint("Step error: $error");
  },
);
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
Future<void> loadTodaysMeals() async {
  final meals = await _mealService.getMeals().first;

  final today = DateTime.now();

  final filteredMeals = meals.where((meal) {
    return meal.date.year == today.year &&
        meal.date.month == today.month &&
        meal.date.day == today.day;
  }).toList();

  if (!mounted) return;

  setState(() {
    todaysMeals = filteredMeals;
  });
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

  Widget mealCard(
  IconData icon,
  String title,
  Color color,
) {
  final mealsForType = todaysMeals
      .where((meal) => meal.mealType == title)
      .toList();

  final totalCalories = mealsForType.fold<int>(
    0,
    (sum, meal) => sum + meal.calories,
  );

  return Container(
    margin: const EdgeInsets.only(bottom: 15),
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(.05),
          blurRadius: 12,
          offset: const Offset(0, 5),
        ),
      ],
    ),
    child: Row(
      children: [
        CircleAvatar(
          radius: 25,
          backgroundColor: color.withOpacity(.15),
          child: Icon(
            icon,
            color: color,
          ),
        ),

        const SizedBox(width: 18),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),

              const SizedBox(height: 5),

              if (mealsForType.isEmpty)
                const Text(
                  "No meal added today",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                )
              else ...[
                Text(
                  mealsForType
                      .map((meal) => meal.foodName)
                      .join(", "),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  "$totalCalories kcal",
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ],
          ),
        ),

        Container(
          decoration: BoxDecoration(
            color: color.withOpacity(.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: Icon(
              Icons.add,
              color: color,
            ),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AddMealScreen(
                    initialMealType: title,
                  ),
                ),
              );

  Future<void> refreshDashboard() async {
  await loadProfile();
  await loadTodaysMeals();

  @override
void didUpdateWidget(covariant DashboardScreen oldWidget) {
  super.didUpdateWidget(oldWidget);

  if (widget.onRefresh != oldWidget.onRefresh) {
    widget.onRefresh?.call();
  }
}
}
            },
          ),
        ),
      ],
    ),
  );
}
@override
void dispose() {
  _stepService.dispose();
  super.dispose();
}

  Widget _progressItem(
  String title,
  String value,
  IconData icon,
  Color color,
) {
  return Column(
    children: [

      CircleAvatar(
        radius: 26,
        backgroundColor: color.withOpacity(.15),
        child: Icon(
          icon,
          color: color,
        ),
      ),

      const SizedBox(height: 10),

      Text(
        value,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),

      Text(
        title,
        style: const TextStyle(
          color: Colors.grey,
        ),
      ),
    ],
  );
}
Widget _quickAction(
  BuildContext context, {
  required IconData icon,
  required String title,
  required Color color,
  required VoidCallback onTap,
}) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(18),
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: color,
            child: Icon(
              icon,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
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

      Row(
  children: [

    CircularPercentIndicator(
      radius: 45,
      lineWidth: 8,
      animation: true,
      percent: ((dashboardStats?.caloriesConsumed ?? 0) /
              calculateDailyCalories())
          .clamp(0.0, 1.0),
      center: Text(
        "${(((dashboardStats?.caloriesConsumed ?? 0) /
                calculateDailyCalories()) *
            100).toStringAsFixed(0)}%",
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      progressColor: Colors.white,
      backgroundColor: Colors.white24,
      circularStrokeCap: CircularStrokeCap.round,
    ),

    const SizedBox(width: 20),

    Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          const Text(
            "Today's Goal",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),

          const SizedBox(height: 6),

          Text(
  "${((dashboardStats?.caloriesConsumed ?? 0) / calculateDailyCalories() * 100).clamp(0, 100).toStringAsFixed(0)}% of today's goal completed",
  style: const TextStyle(
    color: Colors.white,
    fontSize: 18,
    fontWeight: FontWeight.w600,
  ),
),

          const SizedBox(height: 6),

          const Text(
            "Keep going! 💪",
            style: TextStyle(
              color: Colors.white70,
            ),
          ),
        ],
      ),
    ),

  ],
),

      const SizedBox(height: 15),

      

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
            "${dashboardStats?.waterConsumed.toStringAsFixed(2) ?? 0} L",
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
  value: todaySteps.toString(), 
  icon: Icons.directions_walk,
  color: Colors.deepPurple,
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const StepScreen(),
      ),
    );
  },
),

      DashboardCard(
        title: "Streak",
        value: "${dashboardStats?.streak ?? 0} Days",
        icon: Icons.emoji_events,
        color: Colors.amber,
      ),

    ];

    return cards[index];
  },
),
const SizedBox(height: 30),

const Text(
  "Weekly Progress",
  style: TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
  ),
),

const SizedBox(height: 15),

Container(
  width: double.infinity,
  padding: const EdgeInsets.all(20),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(25),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(.05),
        blurRadius: 15,
        offset: const Offset(0, 5),
      ),
    ],
  ),
  child: Column(
    children: [

      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [

          _progressItem(
            "Calories",
            "${dashboardStats?.caloriesConsumed.toStringAsFixed(0) ?? "0"}",
            Icons.local_fire_department,
            Colors.orange,
          ),

          _progressItem(
            "Water",
            "${dashboardStats?.waterConsumed.toStringAsFixed(1) ?? "0"}L",
            Icons.water_drop,
            Colors.blue,
          ),

          _progressItem(
            "Workout",
            "1",
            Icons.fitness_center,
            Colors.green,
          ),

        ],
      ),
    ],
  ),
),
const SizedBox(height: 30),




const SizedBox(height: 15),

Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    const Text(
      "Today's Meals",
      style: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
    ),
    TextButton(
      onPressed: () {},
      child: const Text("View All"),
    ),
  ],
),

const SizedBox(height: 15),

mealCard(
  Icons.free_breakfast,
  "Breakfast",
  Colors.orange,
),

mealCard(
  Icons.lunch_dining,
  "Lunch",
  Colors.green,
),

mealCard(
  Icons.dinner_dining,
  "Dinner",
  Colors.blue,
),

mealCard(
  Icons.cookie,
  "Snacks",
  Colors.deepPurple,
),

const SizedBox(height: 24),



            


            const SizedBox(height:24),
            Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    const Text(
      "Today's Workout",
      style: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
    ),
    TextButton(
      onPressed: () {},
      child: const Text("View All"),
    ),
  ],
),
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

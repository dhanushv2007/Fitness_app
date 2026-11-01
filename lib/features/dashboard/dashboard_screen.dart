<<<<<<< HEAD
import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../../core/theme/theme_controller.dart';
=======

import 'package:flutter/material.dart';
>>>>>>> 8c6adcddfc657ba0464891256e4e0998a4836294
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
import '../sleep/sleep_screen.dart';

class DashboardScreen extends StatefulWidget {
  final VoidCallback? onRefresh;

  const DashboardScreen({
    super.key,
    this.onRefresh,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

<<<<<<< HEAD

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
=======
class _DashboardScreenState extends State<DashboardScreen> {
>>>>>>> 8c6adcddfc657ba0464891256e4e0998a4836294
  final ProfileService _profileService = ProfileService();
  final DashboardService _dashboardService = DashboardService();
  final MealService _mealService = MealService();
  final StepService _stepService = StepService();

<<<<<<< HEAD
  DashboardStats? dashboardStats;
  List<MealModel> todaysMeals = [];
  int todaySteps = 0;
  UserProfile? userProfile;
  bool isLoading = true;

  StreamSubscription<DashboardStats>? _dashboardSubscription;
  StreamSubscription<List<MealModel>>? _mealSubscription;
  late final AnimationController _ambientController;

  @override
  void initState() {
    super.initState();
    _ambientController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat(reverse: true);

    loadProfile();
    listenToDashboard();
    listenToMeals();

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
=======
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
>>>>>>> 8c6adcddfc657ba0464891256e4e0998a4836294

  Future<void> loadProfile() async {
    try {
      final profile = await _profileService.getProfile();
<<<<<<< HEAD

      if (!mounted) return;

      setState(() {
        userProfile = profile;
=======
      final stats = await _dashboardService.loadDashboard();
      if (!mounted) return;
      setState(() {
        userProfile = profile;
        dashboardStats = stats;
>>>>>>> 8c6adcddfc657ba0464891256e4e0998a4836294
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
<<<<<<< HEAD

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Profile error: $e")),
      );
    }
  }

  void listenToDashboard() {
    _dashboardSubscription =
        _dashboardService.watchDashboard().listen(
      (stats) {
        if (!mounted) return;

        setState(() {
          dashboardStats = stats;
        });
      },
      onError: (error) {
        debugPrint("Dashboard stream error: $error");
      },
    );
  }

  void listenToMeals() {
    _mealSubscription = _mealService.getMeals().listen(
      (meals) {
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
      },
      onError: (error) {
        debugPrint("Meals stream error: $error");
      },
    );
  }

  Future<void> refreshDashboard() async {
    await loadProfile();
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

=======
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
>>>>>>> 8c6adcddfc657ba0464891256e4e0998a4836294
    return "Good Evening";
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
<<<<<<< HEAD

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const LoginScreen(),
      ),
=======
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
>>>>>>> 8c6adcddfc657ba0464891256e4e0998a4836294
      (_) => false,
    );
  }

  Widget mealCard(
<<<<<<< HEAD
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

    final isGlass = themeController.glassTheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(
          sigmaX: isGlass ? 18 : 0,
          sigmaY: isGlass ? 18 : 0,
        ),
        child: Container(
          margin: const EdgeInsets.only(bottom: 15),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: isGlass
                ? Colors.white.withOpacity(0.48)
                : Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(22),
            border: isGlass
                ? Border.all(color: Colors.white.withOpacity(0.85), width: 1.2)
                : null,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isGlass ? .035 : .05),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: color.withOpacity(.15),
            child: Icon(icon, color: color),
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
                    style: TextStyle(color: Colors.grey),
                  )
                else ...[
                  Text(
                    mealsForType
                        .map((meal) => meal.foodName)
                        .join(", "),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface,
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
              icon: Icon(Icons.add, color: color),
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AddMealScreen(
                      initialMealType: title,
                    ),
                  ),
                );
              },
            ),
          ),
          ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _dashboardSubscription?.cancel();
    _mealSubscription?.cancel();
    _ambientController.dispose();
    _stepService.dispose();
    super.dispose();
  }

=======
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
      color: Theme.of(context).cardColor,
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
                style:  TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),

              const SizedBox(height: 5),

              if (mealsForType.isEmpty)
                Text(
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
                  style:  TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
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
>>>>>>> 8c6adcddfc657ba0464891256e4e0998a4836294

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
        style:  TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),

      Text(
        title,
        style:  TextStyle(
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
              color: Theme.of(context).cardColor,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: TextStyle(
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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
  elevation: 0,
  backgroundColor: Colors.transparent,
  surfaceTintColor: Colors.transparent,
  title: Text(
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
<<<<<<< HEAD
      body: Stack(
        children: [
          if (themeController.glassTheme)
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _ambientController,
                builder: (context, child) {
                  final t = _ambientController.value;
                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFFE8F0FF),
                              Color(0xFFF5ECFF),
                              Color(0xFFE4F8FA),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: -90 + (t * 45),
                        right: -75 + (t * 30),
                        child: _ambientGlow(
                          size: 250,
                          color: const Color(0xFF9DADFF).withOpacity(0.48),
                        ),
                      ),
                      Positioned(
                        top: 280 - (t * 55),
                        left: -105 + (t * 35),
                        child: _ambientGlow(
                          size: 230,
                          color: const Color(0xFFC7A5FF).withOpacity(0.42),
                        ),
                      ),
                      Positioned(
                        bottom: -110 + (t * 35),
                        right: -65,
                        child: _ambientGlow(
                          size: 260,
                          color: const Color(0xFF8DE0E7).withOpacity(0.38),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
=======
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
>>>>>>> 8c6adcddfc657ba0464891256e4e0998a4836294
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
  width: double.infinity,
  padding: const EdgeInsets.all(25),
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(30),
<<<<<<< HEAD
    gradient: themeController.glassTheme
        ? LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF8FA8FF).withOpacity(0.88),
              const Color(0xFFB69CFF).withOpacity(0.78),
              const Color(0xFF79D8E8).withOpacity(0.72),
            ],
          )
        : const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xff22C55E), Color(0xff15803D)],
          ),
=======
    gradient: const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xff22C55E),
        Color(0xff15803D),
      ],
    ),
>>>>>>> 8c6adcddfc657ba0464891256e4e0998a4836294
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
          CircleAvatar(
            radius: 28,
            backgroundColor:
    Theme.of(context).scaffoldBackgroundColor,
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
                  style: TextStyle(
  color: Theme.of(context).colorScheme.onPrimary,
  fontSize: 16,
),
                  ),
                

                Text(
  userProfile?.name ?? "User",
  style: TextStyle(
    color: Theme.of(context).colorScheme.onPrimary,
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

       Text(
        "Today's Calories",
        style: TextStyle(
          color: Theme.of(context).cardColor,
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
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      progressColor: Colors.white,
      backgroundColor:
    Theme.of(context).scaffoldBackgroundColor,
      circularStrokeCap: CircularStrokeCap.round,
    ),

    const SizedBox(width: 20),

    Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text(
            "Today's Goal",
            style: TextStyle(
              color: Theme.of(context).cardColor,
              fontSize: 16,
            ),
          ),

          const SizedBox(height: 6),

          Text(
  "${((dashboardStats?.caloriesConsumed ?? 0) / calculateDailyCalories() * 100).clamp(0, 100).toStringAsFixed(0)}% of today's goal completed",
  style: TextStyle(
    color: Theme.of(context).colorScheme.onPrimary,
    fontSize: 18,
    fontWeight: FontWeight.w600,
  ),
),

          const SizedBox(height: 6),

          Text(
            "Keep going! 💪",
            style: TextStyle(
              color: Theme.of(context).cardColor,
            ),
          ),
        ],
      ),
    ),

  ],
),

      const SizedBox(height: 15),

      

      const SizedBox(height: 8),

      Text(
        "Stay consistent. Every workout counts! 💪",
        style: TextStyle(
          color: Theme.of(context).cardColor,
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

Text(
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
    color: Theme.of(context).cardColor,
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

Text(
  "Sleep",
  style: TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
  ),
),

const SizedBox(height: 15),

GestureDetector(
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const SleepScreen(),
      ),
    );
  },
  child: Container(
    width: double.infinity,
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Row(
      children: [
        CircleAvatar(
  radius: 28,
  backgroundColor: Colors.deepPurple,
  child: Icon(
    Icons.bedtime,
    color: Theme.of(context).colorScheme.onPrimary,
  ),
),

        const SizedBox(width: 18),

        const Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                "Sleep Tracking",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 5),

              Text(
                "Track your sleep and recovery",
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),

        const Icon(
          Icons.chevron_right,
          color: Colors.deepPurple,
        ),
      ],
    ),
  ),
),

const SizedBox(height: 30),




const SizedBox(height: 15),

Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    Text(
      "Today's Meals",
      style: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
    ),
    TextButton(
      onPressed: () {},
      child:const Text("View All"),
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
    Text(
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
<<<<<<< HEAD
          ),
          ),
        ],
      ),
    );
  }

  Widget _ambientGlow({required double size, required Color color}) {
    return ImageFiltered(
      imageFilter: ui.ImageFilter.blur(sigmaX: 35, sigmaY: 35),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
=======
>>>>>>> 8c6adcddfc657ba0464891256e4e0998a4836294
        ),
      ),
    );
  }
}

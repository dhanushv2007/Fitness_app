import 'package:flutter/material.dart';

import 'models/progress_model.dart';
import 'services/progress_service.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  final ProgressService progressService = ProgressService();

  ProgressModel? progress;
  bool isLoading = true;
  List<int> weeklyWorkoutCounts = [];
  int weeklyCaloriesBurned = 0;
  int weeklyWorkoutMinutes = 0;

  @override
  void initState() {
    super.initState();
    loadProgress();
  }

  Future<void> loadProgress() async {
  final data = await progressService.loadProgress();
  final weeklyCounts =
      await progressService.loadWeeklyWorkoutCounts();
  final weeklyCalories =
    await progressService.loadWeeklyCaloriesBurned();
  final weeklyMinutes =
    await progressService.loadWeeklyWorkoutMinutes();

  if (!mounted) return;

  setState(() {
    progress = data;
    weeklyWorkoutCounts = weeklyCounts;
    isLoading = false;
  });
}

  Widget statCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: color.withOpacity(.15),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget weeklyWorkoutChart() {
  const days = [
    "Mon",
    "Tue",
    "Wed",
    "Thu",
    "Fri",
    "Sat",
    "Sun",
  ];

  final maxValue = weeklyWorkoutCounts.isEmpty
      ? 1
      : weeklyWorkoutCounts.reduce(
            (a, b) => a > b ? a : b,
          );

  return Card(
    elevation: 4,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(18),
    ),
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Weekly Workouts",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 25),

          SizedBox(
            height: 180,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(
                7,
                (index) {
                  final value =
                      weeklyWorkoutCounts.length > index
                          ? weeklyWorkoutCounts[index]
                          : 0;

                  final height = value == 0
                      ? 8.0
                      : (value / maxValue) * 120;

                  return Column(
                    mainAxisAlignment:
                        MainAxisAlignment.end,
                    children: [
                      Text(
                        "$value",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 5),

                      Container(
                        width: 25,
                        height: height,
                        decoration: BoxDecoration(
                          color: Colors.deepPurple,
                          borderRadius:
                              BorderRadius.circular(8),
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        days[index],
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  );
                },
              ),
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
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Progress"),
      ),

      body: RefreshIndicator(
        onRefresh: loadProgress,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [

            statCard(
              "Current Weight",
              "${progress!.currentWeight.toStringAsFixed(1)} kg",
              Icons.monitor_weight,
              Colors.green,
            ),

            statCard(
              "BMI",
              progress!.bmi.toStringAsFixed(1),
              Icons.favorite,
              Colors.red,
            ),

            statCard(
              "Calories",
              "${progress!.caloriesConsumed.toStringAsFixed(0)} / ${progress!.calorieGoal.toStringAsFixed(0)} kcal",
              Icons.local_fire_department,
              Colors.orange,
            ),

            statCard(
              "Water",
              "${progress!.waterConsumed.toStringAsFixed(1)} / ${progress!.waterGoal.toStringAsFixed(1)} L",
              Icons.water_drop,
              Colors.blue,
            ),

            statCard(
              "Workouts",
              "${progress!.workouts}",
              Icons.fitness_center,
              Colors.deepPurple,
            ),

            statCard(
              "Workout Time",
              "${progress!.workoutMinutes} min",
              Icons.timer,
              Colors.teal,
            ),
            const SizedBox(height: 20),

statCard(
  "Weekly Calories Burned",
  "$weeklyCaloriesBurned kcal",
  Icons.local_fire_department,
  Colors.orange,
),
const SizedBox(height: 20),

statCard(
  "Weekly Workout Time",
  "$weeklyWorkoutMinutes min",
  Icons.timer,
  Colors.teal,
),

weeklyWorkoutChart(),

          ],
        ),
      ),
    );
  }
}
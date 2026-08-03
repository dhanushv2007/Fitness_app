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

  @override
  void initState() {
    super.initState();
    loadProgress();
  }

  Future<void> loadProgress() async {
    final data = await progressService.loadProgress();

    if (!mounted) return;

    setState(() {
      progress = data;
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

          ],
        ),
      ),
    );
  }
}
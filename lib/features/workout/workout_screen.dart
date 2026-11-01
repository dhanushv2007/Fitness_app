import 'package:flutter/material.dart';

import 'add_workout_screen.dart';
import 'models/workout_model.dart';
import 'services/workout_service.dart';

class WorkoutScreen extends StatelessWidget {
  const WorkoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final WorkoutService workoutService = WorkoutService();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Workout"),
      ),

      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddWorkoutScreen(),
            ),
          );
        },
      ),

      body: StreamBuilder<List<WorkoutModel>>(
        stream: workoutService.getWorkouts(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final workouts = snapshot.data!;

          if (workouts.isEmpty) {
            return const Center(
              child: Text(
                "No workouts added yet",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            );
          }

          int totalCalories = workouts.fold(
            0,
            (sum, workout) => sum + workout.caloriesBurned,
          );

          int totalMinutes = workouts.fold(
            0,
            (sum, workout) => sum + workout.duration,
          );
          int totalWorkouts = workouts.length;

          return Column(
            children: [

              Container(
  margin: const EdgeInsets.all(15),
  padding: const EdgeInsets.all(20),
  decoration: BoxDecoration(
    gradient: const LinearGradient(
      colors: [
        Color(0xff43A047),
        Color(0xff2E7D32),
      ],
    ),
    borderRadius: BorderRadius.circular(20),
  ),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: [

      Column(
        children: [
          const Text(
            "Workouts",
            style: TextStyle(color: Colors.white70),
          ),
          Text(
            "$totalWorkouts",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),

      Column(
        children: [
          const Text(
            "Calories",
            style: TextStyle(color: Colors.white70),
          ),
          Text(
            "$totalCalories",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),

      Column(
        children: [
          const Text(
            "Minutes",
            style: TextStyle(color: Colors.white70),
          ),
          Text(
            "$totalMinutes",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),

    ],
  ),
),

              Expanded(
                child: ListView.builder(
                  itemCount: workouts.length,
                  itemBuilder: (context, index) {
                    final workout = workouts[index];

                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 6,
                      ),

                      child: ListTile(
                        leading: const CircleAvatar(
                          child: Icon(
                            Icons.fitness_center,
                          ),
                        ),

                        title: Text(
                          workout.exerciseName,
                        ),

                        subtitle: Text(
                          "${workout.sets} Sets • "
                          "${workout.reps} Reps\n"
                          "${workout.duration} min • "
                          "${workout.caloriesBurned} kcal",
                        ),

                        trailing: IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            workoutService.deleteWorkout(
                              workout.id,
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
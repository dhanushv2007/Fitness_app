import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import 'exercise_search_screen.dart';
import 'models/exercise_model.dart';
import 'models/workout_model.dart';
import 'services/workout_service.dart';

class AddWorkoutScreen extends StatefulWidget {
  const AddWorkoutScreen({super.key});

  @override
  State<AddWorkoutScreen> createState() => _AddWorkoutScreenState();
}

class _AddWorkoutScreenState extends State<AddWorkoutScreen> {
  final _formKey = GlobalKey<FormState>();

  final WorkoutService workoutService = WorkoutService();

  final exerciseController = TextEditingController();
  final setsController = TextEditingController(text: "3");
  final repsController = TextEditingController(text: "12");
  final weightController = TextEditingController(text: "0");
  final durationController = TextEditingController(text: "30");

  ExerciseModel? selectedExercise;

  bool isLoading = false;

  Future<void> saveWorkout() async {
    if (!_formKey.currentState!.validate()) return;

    if (selectedExercise == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select an exercise"),
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    final duration = int.parse(durationController.text);

    final workout = WorkoutModel(
      id: const Uuid().v4(),
      exerciseName: selectedExercise!.name,
      muscleGroup: selectedExercise!.muscleGroup,
      sets: int.parse(setsController.text),
      reps: int.parse(repsController.text),
      weight: double.parse(weightController.text),
      duration: duration,
      caloriesBurned:
          duration * selectedExercise!.caloriesPerMinute,
      date: DateTime.now(),
    );

    await workoutService.addWorkout(workout);

    if (!mounted) return;

    Navigator.pop(context);
  }

  Widget numberField(
    TextEditingController controller,
    String label,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Required";
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    exerciseController.dispose();
    setsController.dispose();
    repsController.dispose();
    weightController.dispose();
    durationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Workout"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              ElevatedButton.icon(
                icon: const Icon(Icons.search),
                label: const Text("Search Exercise"),
                onPressed: () async {
                  final exercise = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const ExerciseSearchScreen(),
                    ),
                  );

                  if (exercise != null &&
                      exercise is ExerciseModel) {
                    setState(() {
                      selectedExercise = exercise;
                      exerciseController.text =
                          exercise.name;
                    });
                  }
                },
              ),

              const SizedBox(height: 20),

              TextFormField(
                controller: exerciseController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: "Exercise",
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(15),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              numberField(setsController, "Sets"),
              numberField(repsController, "Reps"),
              numberField(weightController, "Weight (kg)"),
              numberField(durationController, "Duration (minutes)"),

              const SizedBox(height: 20),

              SizedBox(
                height: 55,
                child: ElevatedButton(
                  onPressed:
                      isLoading ? null : saveWorkout,
                  child: isLoading
                      ? const CircularProgressIndicator()
                      : const Text(
                          "Save Workout",
                          style: TextStyle(fontSize: 18),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
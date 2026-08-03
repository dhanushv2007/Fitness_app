import 'package:flutter/material.dart';

import 'data/exercise_database.dart';
import 'models/exercise_model.dart';

class ExerciseSearchScreen extends StatefulWidget {
  const ExerciseSearchScreen({super.key});

  @override
  State<ExerciseSearchScreen> createState() =>
      _ExerciseSearchScreenState();
}

class _ExerciseSearchScreenState
    extends State<ExerciseSearchScreen> {
  List<ExerciseModel> exercises =
      ExerciseDatabase.exercises;

  void searchExercise(String query) {
    setState(() {
      exercises = ExerciseDatabase.exercises
          .where(
            (exercise) => exercise.name
                .toLowerCase()
                .contains(query.toLowerCase()),
          )
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search Exercise"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: TextField(
              decoration: const InputDecoration(
                hintText: "Search Exercise",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: searchExercise,
            ),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: exercises.length,
              itemBuilder: (context, index) {
                final exercise = exercises[index];

                return ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.fitness_center),
                  ),
                  title: Text(exercise.name),
                  subtitle: Text(
                    "${exercise.muscleGroup} • ${exercise.difficulty}",
                  ),
                  trailing: Text(
                    "${exercise.caloriesPerMinute} kcal/min",
                  ),
                  onTap: () {
                    Navigator.pop(context, exercise);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
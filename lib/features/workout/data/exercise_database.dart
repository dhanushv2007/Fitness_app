import '../models/exercise_model.dart';

class ExerciseDatabase {
  static const List<ExerciseModel> exercises = [

    // Chest
    ExerciseModel(
      name: "Push Up",
      muscleGroup: "Chest",
      difficulty: "Beginner",
      caloriesPerMinute: 8,
    ),

    ExerciseModel(
      name: "Bench Press",
      muscleGroup: "Chest",
      difficulty: "Intermediate",
      caloriesPerMinute: 10,
    ),

    // Back
    ExerciseModel(
      name: "Pull Up",
      muscleGroup: "Back",
      difficulty: "Advanced",
      caloriesPerMinute: 12,
    ),

    ExerciseModel(
      name: "Lat Pulldown",
      muscleGroup: "Back",
      difficulty: "Beginner",
      caloriesPerMinute: 8,
    ),

    // Legs
    ExerciseModel(
      name: "Squat",
      muscleGroup: "Legs",
      difficulty: "Beginner",
      caloriesPerMinute: 10,
    ),

    ExerciseModel(
      name: "Leg Press",
      muscleGroup: "Legs",
      difficulty: "Intermediate",
      caloriesPerMinute: 9,
    ),

    // Shoulders
    ExerciseModel(
      name: "Shoulder Press",
      muscleGroup: "Shoulders",
      difficulty: "Intermediate",
      caloriesPerMinute: 8,
    ),

    ExerciseModel(
      name: "Lateral Raise",
      muscleGroup: "Shoulders",
      difficulty: "Beginner",
      caloriesPerMinute: 6,
    ),

    // Arms
    ExerciseModel(
      name: "Bicep Curl",
      muscleGroup: "Biceps",
      difficulty: "Beginner",
      caloriesPerMinute: 5,
    ),

    ExerciseModel(
      name: "Tricep Pushdown",
      muscleGroup: "Triceps",
      difficulty: "Beginner",
      caloriesPerMinute: 5,
    ),

    // Core
    ExerciseModel(
      name: "Plank",
      muscleGroup: "Abs",
      difficulty: "Beginner",
      caloriesPerMinute: 6,
    ),

    ExerciseModel(
      name: "Crunches",
      muscleGroup: "Abs",
      difficulty: "Beginner",
      caloriesPerMinute: 7,
    ),

    // Cardio
    ExerciseModel(
      name: "Running",
      muscleGroup: "Cardio",
      difficulty: "Intermediate",
      caloriesPerMinute: 12,
    ),

    ExerciseModel(
      name: "Cycling",
      muscleGroup: "Cardio",
      difficulty: "Beginner",
      caloriesPerMinute: 9,
    ),

    ExerciseModel(
      name: "Jump Rope",
      muscleGroup: "Cardio",
      difficulty: "Advanced",
      caloriesPerMinute: 14,
    ),
  ];
}
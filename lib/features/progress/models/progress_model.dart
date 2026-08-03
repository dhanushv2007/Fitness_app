class ProgressModel {
  final double currentWeight;
  final double bmi;
  final double caloriesConsumed;
  final double calorieGoal;
  final double waterConsumed;
  final double waterGoal;
  final int workouts;
  final int workoutMinutes;

  ProgressModel({
    required this.currentWeight,
    required this.bmi,
    required this.caloriesConsumed,
    required this.calorieGoal,
    required this.waterConsumed,
    required this.waterGoal,
    required this.workouts,
    required this.workoutMinutes,
  });
}
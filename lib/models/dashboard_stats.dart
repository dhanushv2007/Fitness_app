class DashboardStats {
  final double caloriesConsumed;
  final double calorieGoal;

  final double waterConsumed;
  final double waterGoal;

  final int steps;
  final int streak;

  DashboardStats({
    required this.caloriesConsumed,
    required this.calorieGoal,
    required this.waterConsumed,
    required this.waterGoal,
    required this.steps,
    required this.streak,
  });

  double get calorieProgress =>
      caloriesConsumed / calorieGoal;

  double get waterProgress =>
      waterConsumed / waterGoal;
}
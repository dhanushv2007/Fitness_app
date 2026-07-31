import '../../models/dashboard_stats.dart';

class DashboardService {
  Future<DashboardStats> loadDashboard() async {
    return DashboardStats(
      caloriesConsumed: 0,
      calorieGoal: 2200,
      waterConsumed: 0,
      waterGoal: 3,
      steps: 0,
      streak: 1,
    );
  }
}
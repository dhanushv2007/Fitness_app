import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../models/dashboard_stats.dart';

class DashboardService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<DashboardStats> loadDashboard() async {
    final uid = auth.currentUser!.uid;

    // ==========================
    // Load Meals
    // ==========================

    final now = DateTime.now();

final startOfDay = DateTime(
  now.year,
  now.month,
  now.day,
);

final endOfDay = startOfDay.add(
  const Duration(days: 1),
);

final meals = await firestore
    .collection('users')
    .doc(uid)
    .collection('meals')
    .where(
      'date',
      isGreaterThanOrEqualTo: startOfDay.toIso8601String(),
    )
    .where(
      'date',
      isLessThan: endOfDay.toIso8601String(),
    )
    .get();

    double caloriesConsumed = 0;

    for (var doc in meals.docs) {
      final data = doc.data();

      caloriesConsumed +=
          (data['calories'] as num?)?.toDouble() ?? 0;
    }

    // ==========================
    // Load Water
    // ==========================

    final waterSnapshot = await firestore
        .collection('users')
        .doc(uid)
        .collection('water')
        .doc('today')
        .get();

    double waterConsumed = 0;
    double waterGoal = 3;

    if (waterSnapshot.exists) {
      final data = waterSnapshot.data()!;

      waterConsumed =
          (data['consumed'] as num?)?.toDouble() ?? 0;

      waterGoal =
          (data['goal'] as num?)?.toDouble() ?? 3;
    }

    // ==========================
    // Return Dashboard Data
    // ==========================

    // ==========================
// Load Workout Streak
// ==========================

final workouts = await firestore
    .collection('users')
    .doc(uid)
    .collection('workouts')
    .get();

final workoutDates = <DateTime>{};

for (final doc in workouts.docs) {
  final data = doc.data();

  final dateString = data['date'];

  if (dateString is String) {
    final date = DateTime.tryParse(dateString);

    if (date != null) {
      workoutDates.add(
        DateTime(
          date.year,
          date.month,
          date.day,
        ),
      );
    }
  }
}

DateTime checkDate = DateTime(
  now.year,
  now.month,
  now.day,
);

int streak = 0;

while (workoutDates.contains(checkDate)) {
  streak++;

  checkDate = checkDate.subtract(
    const Duration(days: 1),
  );
}

// ==========================
// Return Dashboard Data
// ==========================

return DashboardStats(
  caloriesConsumed: caloriesConsumed,
  calorieGoal: 2200.0,
  waterConsumed: waterConsumed,
  waterGoal: waterGoal,
  steps: 0,
  streak: streak,
);
  }
}
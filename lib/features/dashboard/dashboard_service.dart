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

    final mealsSnapshot = await firestore
        .collection('users')
        .doc(uid)
        .collection('meals')
        .get();

    double caloriesConsumed = 0;

    for (var doc in mealsSnapshot.docs) {
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

    return DashboardStats(
      caloriesConsumed: caloriesConsumed,
      calorieGoal: 2200.0,
      waterConsumed: waterConsumed,
      waterGoal: waterGoal,
      steps: 0,
      streak: 1,
    );
  }
}
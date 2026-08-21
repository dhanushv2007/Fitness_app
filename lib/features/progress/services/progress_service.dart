import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../models/dashboard_stats.dart';
import '../../profile/profile_model.dart';
import '../../profile/profile_service.dart';
import '../models/progress_model.dart';

class ProgressService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  final ProfileService profileService = ProfileService();

  Future<ProgressModel> loadProgress() async {
    final uid = auth.currentUser!.uid;

    final UserProfile? profile =
    await profileService.getProfile();

    if (profile == null) {
      throw Exception("Profile not found");
    }

    //--------------------------
    // Meals
    //--------------------------

    final meals = await firestore
        .collection('users')
        .doc(uid)
        .collection('meals')
        .get();

    double calories = 0;

    for (var doc in meals.docs) {
      calories +=
          (doc['calories'] as num).toDouble();
    }

    //--------------------------
    // Water
    //--------------------------

    final waterDoc = await firestore
        .collection('users')
        .doc(uid)
        .collection('water')
        .doc('today')
        .get();

    double water = 0;
    double waterGoal = 3;

    if (waterDoc.exists) {
      water =
          (waterDoc['consumed'] as num).toDouble();

      waterGoal =
          (waterDoc['goal'] as num).toDouble();
    }

    //--------------------------
    // Workouts
    //--------------------------

    final workouts = await firestore
        .collection('users')
        .doc(uid)
        .collection('workouts')
        .get();

    int workoutCount = workouts.docs.length;

    int minutes = 0;

    for (var doc in workouts.docs) {
      minutes += doc['duration'] as int;
    }

    //--------------------------
    // BMI
    //--------------------------

    double bmi =
        profile.weight /
        ((profile.height / 100) *
            (profile.height / 100));

    return ProgressModel(
      currentWeight: profile.weight,
      bmi: bmi,
      caloriesConsumed: calories,
      calorieGoal: 2200,
      waterConsumed: water,
      waterGoal: waterGoal,
      workouts: workoutCount,
      workoutMinutes: minutes,
    );
  }
  Future<List<int>> loadWeeklyWorkoutCounts() async {
  final uid = auth.currentUser!.uid;

  final workouts = await firestore
      .collection('users')
      .doc(uid)
      .collection('workouts')
      .get();

  final now = DateTime.now();

  // Monday = 1, Sunday = 7
  final monday = DateTime(
    now.year,
    now.month,
    now.day,
  ).subtract(
    Duration(days: now.weekday - 1),
  );

  final counts = List<int>.filled(7, 0);

  for (final doc in workouts.docs) {
    final data = doc.data();

    final dateString = data['date'];

    if (dateString is! String) continue;

    final date = DateTime.tryParse(dateString);

    if (date == null) continue;

    final workoutDate = DateTime(
      date.year,
      date.month,
      date.day,
    );

    final difference =
        workoutDate.difference(monday).inDays;

    if (difference >= 0 && difference < 7) {
      counts[difference]++;
    }
  }

  return counts;
}
Future<int> loadWeeklyCaloriesBurned() async {
  final uid = auth.currentUser!.uid;

  final workouts = await firestore
      .collection('users')
      .doc(uid)
      .collection('workouts')
      .get();

  final now = DateTime.now();

  final monday = DateTime(
    now.year,
    now.month,
    now.day,
  ).subtract(
    Duration(days: now.weekday - 1),
  );

  int totalCalories = 0;

  for (final doc in workouts.docs) {
    final data = doc.data();

    final dateString = data['date'];

    if (dateString is! String) continue;

    final date = DateTime.tryParse(dateString);

    if (date == null) continue;

    final workoutDate = DateTime(
      date.year,
      date.month,
      date.day,
    );

    final difference =
        workoutDate.difference(monday).inDays;

    if (difference >= 0 && difference < 7) {
      totalCalories +=
          (data['caloriesBurned'] as num?)?.toInt() ?? 0;
    }
  }

  return totalCalories;
}
Future<int> loadWeeklyWorkoutMinutes() async {
  final uid = auth.currentUser!.uid;

  final workouts = await firestore
      .collection('users')
      .doc(uid)
      .collection('workouts')
      .get();

  final now = DateTime.now();

  final monday = DateTime(
    now.year,
    now.month,
    now.day,
  ).subtract(
    Duration(days: now.weekday - 1),
  );

  int totalMinutes = 0;

  for (final doc in workouts.docs) {
    final data = doc.data();

    final dateString = data['date'];

    if (dateString is! String) continue;

    final date = DateTime.tryParse(dateString);

    if (date == null) continue;

    final workoutDate = DateTime(
      date.year,
      date.month,
      date.day,
    );

    final difference =
        workoutDate.difference(monday).inDays;

    if (difference >= 0 && difference < 7) {
      totalMinutes +=
          (data['duration'] as num?)?.toInt() ?? 0;
    }
  }

  return totalMinutes;
}
}

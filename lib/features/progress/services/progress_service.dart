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
}
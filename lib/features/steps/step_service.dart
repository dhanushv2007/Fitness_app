import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pedometer/pedometer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StepService {
    final FirebaseFirestore firestore =
      FirebaseFirestore.instance;

  final FirebaseAuth auth =
      FirebaseAuth.instance;
  StreamSubscription<StepCount>? _stepSubscription;

  int _todaySteps = 0;

  int get todaySteps => _todaySteps;

  Future<void> startStepTracking({
    required void Function(int steps) onStepsChanged,
    required void Function(String error) onError,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    final now = DateTime.now();
    final todayKey =
        "${now.year}-${now.month}-${now.day}";

    final savedDate = prefs.getString("step_date");
    int? startSteps = prefs.getInt("step_start");

    _stepSubscription?.cancel();

    _stepSubscription = Pedometer.stepCountStream.listen(
      (StepCount event) async {
        final currentSteps = event.steps;

        // New day
        // New day
if (savedDate != todayKey) {
  // Save the previous day's final steps
  if (savedDate != null && startSteps != null) {
    int previousDaySteps = currentSteps - startSteps!;

    if (previousDaySteps < 0) {
      previousDaySteps = 0;
    }

    await saveStepsForDate(
      savedDate,
      previousDaySteps,
    );
  }

  // Start counting the new day
  await prefs.setString("step_date", todayKey);
  await prefs.setInt("step_start", currentSteps);

  startSteps = currentSteps;
}

        startSteps ??= currentSteps;

        _todaySteps = currentSteps - startSteps!;

if (_todaySteps < 0) {
  _todaySteps = 0;
}

await saveTodaySteps(_todaySteps);

onStepsChanged(_todaySteps);
      },
      onError: (error) {
        onError(error.toString());
      },
    );
  }
    Future<void> saveTodaySteps(int steps) async {
    final user = auth.currentUser;

    if (user == null) return;

    final now = DateTime.now();

    final dateKey =
        "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

    await firestore
        .collection('users')
        .doc(user.uid)
        .collection('stepHistory')
        .doc(dateKey)
        .set({
      'date': dateKey,
      'steps': steps,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
    Future<List<Map<String, dynamic>>> getStepHistory() async {
    final user = auth.currentUser;

    if (user == null) {
      return [];
    }

    final snapshot = await firestore
        .collection('users')
        .doc(user.uid)
        .collection('stepHistory')
        .orderBy('date', descending: true)
        .limit(7)
        .get();

    return snapshot.docs
        .map((doc) => doc.data())
        .toList();
  }
  Future<void> saveStepsForDate(
  String date,
  int steps,
) async {
  final user = auth.currentUser;

  if (user == null) return;

  await firestore
      .collection('users')
      .doc(user.uid)
      .collection('stepHistory')
      .doc(date)
      .set({
    'date': date,
    'steps': steps,
    'updatedAt': FieldValue.serverTimestamp(),
  }, SetOptions(merge: true));
}

  Future<void> stopStepTracking() async {
    await _stepSubscription?.cancel();
    _stepSubscription = null;
  }

  void dispose() {
    _stepSubscription?.cancel();
    _stepSubscription = null;
  }
}
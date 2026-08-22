import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/workout_model.dart';

class WorkoutService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> addWorkout(WorkoutModel workout) async {
    final uid = auth.currentUser!.uid;

    await firestore
        .collection('users')
        .doc(uid)
        .collection('workouts')
        .doc(workout.id)
        .set(workout.toMap());
  }

  Stream<List<WorkoutModel>> getWorkouts() {
  final uid = auth.currentUser!.uid;

  final now = DateTime.now();

  final startOfDay = DateTime(
    now.year,
    now.month,
    now.day,
  );

  final endOfDay = startOfDay.add(
    const Duration(days: 1),
  );

  return firestore
      .collection('users')
      .doc(uid)
      .collection('workouts')
      .where(
        'date',
        isGreaterThanOrEqualTo: startOfDay.toIso8601String(),
      )
      .where(
        'date',
        isLessThan: endOfDay.toIso8601String(),
      )
      .snapshots()
      .map(
        (snapshot) => snapshot.docs
            .map(
              (doc) => WorkoutModel.fromMap(
                doc.data(),
              ),
            )
            .toList(),
      );
}

  Future<void> deleteWorkout(String id) async {
    final uid = auth.currentUser!.uid;

    await firestore
        .collection('users')
        .doc(uid)
        .collection('workouts')
        .doc(id)
        .delete();
  }
}
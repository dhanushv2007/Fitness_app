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

    return firestore
        .collection('users')
        .doc(uid)
        .collection('workouts')
        .orderBy('date', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => WorkoutModel.fromMap(doc.data()))
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
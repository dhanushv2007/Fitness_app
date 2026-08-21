import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/sleep_model.dart';

class SleepService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> addSleep(SleepModel sleep) async {
    final user = auth.currentUser;

    if (user == null) {
      throw Exception("User not logged in");
    }

    await firestore
        .collection('users')
        .doc(user.uid)
        .collection('sleep')
        .doc(sleep.id)
        .set(sleep.toMap());
  }

  Stream<List<SleepModel>> getSleep() {
    final user = auth.currentUser;

    if (user == null) {
      return const Stream.empty();
    }

    return firestore
        .collection('users')
        .doc(user.uid)
        .collection('sleep')
        .orderBy('date', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => SleepModel.fromMap(doc.data()),
              )
              .toList(),
        );
  }
  Future<List<int>> getWeeklySleepMinutes() async {
  final user = auth.currentUser;

  if (user == null) {
    return List<int>.filled(7, 0);
  }

  final sleeps = await firestore
      .collection('users')
      .doc(user.uid)
      .collection('sleep')
      .get();

  final now = DateTime.now();

  final monday = DateTime(
    now.year,
    now.month,
    now.day,
  ).subtract(
    Duration(days: now.weekday - 1),
  );

  final weeklyMinutes = List<int>.filled(7, 0);

  for (final doc in sleeps.docs) {
    final data = doc.data();

    final dateString = data['date'];

    if (dateString is! String) continue;

    final date = DateTime.tryParse(dateString);

    if (date == null) continue;

    final sleepDate = DateTime(
      date.year,
      date.month,
      date.day,
    );

    final difference =
        sleepDate.difference(monday).inDays;

    if (difference >= 0 && difference < 7) {
      weeklyMinutes[difference] +=
          (data['durationMinutes'] as num?)?.toInt() ?? 0;
    }
  }

  return weeklyMinutes;
}

  Future<void> deleteSleep(String id) async {
    final user = auth.currentUser;

    if (user == null) {
      throw Exception("User not logged in");
    }

    await firestore
        .collection('users')
        .doc(user.uid)
        .collection('sleep')
        .doc(id)
        .delete();
  }
}
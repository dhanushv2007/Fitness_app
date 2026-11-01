import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/water_model.dart';

class WaterService {
  final FirebaseFirestore firestore =
      FirebaseFirestore.instance;

  final FirebaseAuth auth =
      FirebaseAuth.instance;

  Future<WaterModel> getWater() async {
    final uid = auth.currentUser!.uid;

    final doc = await firestore
        .collection('users')
        .doc(uid)
        .collection('water')
        .doc('today')
        .get();

    final now = DateTime.now();

    final todayKey =
        "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

    if (!doc.exists) {
      return WaterModel(
        consumed: 0,
        goal: 3,
      );
    }

    final data = doc.data()!;

    final savedDate = data['date'];

    // New day → reset water
    if (savedDate != todayKey) {
      final goal =
          (data['goal'] as num?)?.toDouble() ?? 3;

      await firestore
          .collection('users')
          .doc(uid)
          .collection('water')
          .doc('today')
          .set({
        'consumed': 0.0,
        'goal': goal,
        'date': todayKey,
      });

      return WaterModel(
        consumed: 0,
        goal: goal,
      );
    }

    return WaterModel.fromMap(data);
  }

  Future<void> saveWater(
    double consumed,
    double goal,
  ) async {
    final uid = auth.currentUser!.uid;

    final now = DateTime.now();

    final todayKey =
        "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

    await firestore
        .collection('users')
        .doc(uid)
        .collection('water')
        .doc('today')
        .set({
      'consumed': consumed,
      'goal': goal,
      'date': todayKey,
    });
  }
}
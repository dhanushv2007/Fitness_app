import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/water_model.dart';

class WaterService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<WaterModel> getWater() async {
    final uid = auth.currentUser!.uid;

    final doc = await firestore
        .collection('users')
        .doc(uid)
        .collection('water')
        .doc('today')
        .get();

    if (!doc.exists) {
      return WaterModel(
        consumed: 0,
        goal: 3,
      );
    }

    return WaterModel.fromMap(doc.data()!);
  }

  Future<void> saveWater(
    double consumed,
    double goal,
  ) async {
    final uid = auth.currentUser!.uid;

    await firestore
        .collection('users')
        .doc(uid)
        .collection('water')
        .doc('today')
        .set({
      'consumed': consumed,
      'goal': goal,
    });
  }
}
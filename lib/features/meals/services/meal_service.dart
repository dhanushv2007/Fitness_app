import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/meal_model.dart';

class MealService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> addMeal(MealModel meal) async {
    final uid = auth.currentUser!.uid;

    await firestore
        .collection('users')
        .doc(uid)
        .collection('meals')
        .doc(meal.id)
        .set(meal.toMap());
  }

  Stream<List<MealModel>> getMeals() {
    final uid = auth.currentUser!.uid;

    return firestore
        .collection('users')
        .doc(uid)
        .collection('meals')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => MealModel.fromMap(doc.data()))
              .toList(),
        );
  }

  Future<void> deleteMeal(String id) async {
    final uid = auth.currentUser!.uid;

    await firestore
        .collection('users')
        .doc(uid)
        .collection('meals')
        .doc(id)
        .delete();
  }
}
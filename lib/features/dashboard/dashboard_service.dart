
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../models/dashboard_stats.dart';

class DashboardService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  Stream<DashboardStats> watchDashboard() {
    final user = auth.currentUser;

    if (user == null) {
      return Stream.error(
        StateError('User is not logged in'),
      );
    }

    final uid = user.uid;
    final now = DateTime.now();

    final startOfDay = DateTime(
      now.year,
      now.month,
      now.day,
    );

    final endOfDay = startOfDay.add(
      const Duration(days: 1),
    );

    final todayKey =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

    final userRef = firestore.collection('users').doc(uid);

    final mealsStream = userRef
        .collection('meals')
        .where(
          'date',
          isGreaterThanOrEqualTo: startOfDay.toIso8601String(),
        )
        .where(
          'date',
          isLessThan: endOfDay.toIso8601String(),
        )
        .snapshots();

    final waterStream = userRef
        .collection('water')
        .doc('today')
        .snapshots();

    final workoutsStream =
        userRef.collection('workouts').snapshots();

    late StreamController<DashboardStats> controller;

    StreamSubscription? mealsSubscription;
    StreamSubscription? waterSubscription;
    StreamSubscription? workoutsSubscription;

    double calories = 0;
    double waterConsumed = 0;
    double waterGoal = 3;
    int streak = 0;

    bool mealsReady = false;
    bool waterReady = false;
    bool workoutsReady = false;

    void emitStats() {
      if (controller.isClosed ||
          !mealsReady ||
          !waterReady ||
          !workoutsReady) {
        return;
      }

      controller.add(
        DashboardStats(
          caloriesConsumed: calories,
          calorieGoal: 2200,
          waterConsumed: waterConsumed,
          waterGoal: waterGoal,
          steps: 0,
          streak: streak,
        ),
      );
    }

    void calculateStreak(
      QuerySnapshot<Map<String, dynamic>> snapshot,
    ) {
      final workoutDates = <DateTime>{};

      for (final doc in snapshot.docs) {
        final dateString = doc.data()['date'];

        if (dateString is String) {
          final date = DateTime.tryParse(dateString);

          if (date != null) {
            workoutDates.add(
              DateTime(date.year, date.month, date.day),
            );
          }
        }
      }

      DateTime checkDate = startOfDay;
      int count = 0;

      while (workoutDates.contains(checkDate)) {
        count++;
        checkDate = checkDate.subtract(
          const Duration(days: 1),
        );
      }

      streak = count;
    }

    controller = StreamController<DashboardStats>(
      onListen: () {
        mealsSubscription = mealsStream.listen(
          (snapshot) {
            calories = 0;

            for (final doc in snapshot.docs) {
              calories +=
                  (doc.data()['calories'] as num?)
                          ?.toDouble() ??
                      0;
            }

            mealsReady = true;
            emitStats();
          },
          onError: controller.addError,
        );

        waterSubscription = waterStream.listen(
          (snapshot) {
            waterConsumed = 0;
            waterGoal = 3;

            if (snapshot.exists) {
              final data = snapshot.data()!;

              waterGoal =
                  (data['goal'] as num?)?.toDouble() ?? 3;

              if (data['date'] == todayKey) {
                waterConsumed =
                    (data['consumed'] as num?)?.toDouble() ?? 0;
              }
            }

            waterReady = true;
            emitStats();
          },
          onError: controller.addError,
        );

        workoutsSubscription = workoutsStream.listen(
          (snapshot) {
            calculateStreak(snapshot);
            workoutsReady = true;
            emitStats();
          },
          onError: controller.addError,
        );
      },
      onCancel: () async {
        await mealsSubscription?.cancel();
        await waterSubscription?.cancel();
        await workoutsSubscription?.cancel();
      },
    );

    return controller.stream;
  }
}

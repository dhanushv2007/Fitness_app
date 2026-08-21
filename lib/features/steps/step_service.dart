import 'dart:async';

import 'package:pedometer/pedometer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StepService {
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
        if (savedDate != todayKey) {
          await prefs.setString("step_date", todayKey);
          await prefs.setInt("step_start", currentSteps);

          startSteps = currentSteps;
        }

        startSteps ??= currentSteps;

        _todaySteps = currentSteps - startSteps!;

        if (_todaySteps < 0) {
          _todaySteps = 0;
        }

        onStepsChanged(_todaySteps);
      },
      onError: (error) {
        onError(error.toString());
      },
    );
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
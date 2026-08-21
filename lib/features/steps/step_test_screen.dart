import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';

class StepTestScreen extends StatefulWidget {
  const StepTestScreen({super.key});

  @override
  State<StepTestScreen> createState() => _StepTestScreenState();
}

class _StepTestScreenState extends State<StepTestScreen> {
  StreamSubscription<StepCount>? _stepSubscription;

  int steps = 0;
  String status = "Requesting permission...";

  @override
  void initState() {
    super.initState();
    startTracking();
  }

  Future<void> startTracking() async {
    final permission =
        await Permission.activityRecognition.request();

    if (!permission.isGranted) {
      if (!mounted) return;

      setState(() {
        status = "Activity recognition permission denied";
      });

      return;
    }

    if (!mounted) return;

    setState(() {
      status = "Waiting for step sensor...";
    });

    _stepSubscription = Pedometer.stepCountStream.listen(
      (StepCount event) {
        if (!mounted) return;

        setState(() {
          steps = event.steps;
          status = "Step sensor working";
        });

        debugPrint("STEPS: ${event.steps}");
      },
      onError: (error) {
        if (!mounted) return;

        setState(() {
          status = "Step sensor error: $error";
        });

        debugPrint("STEP ERROR: $error");
      },
    );
  }

  @override
  void dispose() {
    _stepSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Step Sensor Test"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.directions_walk,
              size: 80,
              color: Colors.deepPurple,
            ),

            const SizedBox(height: 25),

            Text(
              "$steps",
              style: const TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
              ),
            ),

            const Text(
              "Steps",
              style: TextStyle(
                fontSize: 20,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 25),

            Text(
              status,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
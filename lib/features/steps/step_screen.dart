import 'package:flutter/material.dart';

import 'step_service.dart';

class StepScreen extends StatefulWidget {
  const StepScreen({super.key});

  @override
  State<StepScreen> createState() => _StepScreenState();
}

class _StepScreenState extends State<StepScreen> {
  final StepService _stepService = StepService();

  int steps = 0;

  final int stepGoal = 10000;

  String errorMessage = "";

  @override
  void initState() {
    super.initState();

    _startTracking();
  }

  Future<void> _startTracking() async {
    await _stepService.startStepTracking(
      onStepsChanged: (value) {
        if (!mounted) return;

        setState(() {
          steps = value;
          errorMessage = "";
        });
      },
      onError: (error) {
        if (!mounted) return;

        setState(() {
          errorMessage = error;
        });
      },
    );
  }

  @override
  void dispose() {
    _stepService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double progress =
        (steps / stepGoal).clamp(0.0, 1.0);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Steps"),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            const SizedBox(height: 20),

            // Step circle
            SizedBox(
              width: 240,
              height: 240,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 220,
                    height: 220,
                    child: CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 15,
                      backgroundColor: Colors.grey.shade200,
                      color: Colors.deepPurple,
                    ),
                  ),

                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.directions_walk,
                        size: 40,
                        color: Colors.deepPurple,
                      ),

                      const SizedBox(height: 10),

                      Text(
                        "$steps",
                        style: const TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const Text(
                        "Steps Today",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Goal
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),

                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Daily Goal",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        Text(
                          "$steps / $stepGoal",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 15),

                    LinearProgressIndicator(
                      value: progress,
                      minHeight: 10,
                      borderRadius: BorderRadius.circular(10),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      "${(progress * 100).toStringAsFixed(0)}% completed",
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Remaining steps
            Card(
              child: ListTile(
                leading: const CircleAvatar(
                  child: Icon(Icons.flag),
                ),

                title: const Text("Steps Remaining"),

                subtitle: Text(
                  "${(stepGoal - steps).clamp(0, stepGoal)} steps to reach your goal",
                ),
              ),
            ),

            if (errorMessage.isNotEmpty) ...[
              const SizedBox(height: 20),

              Text(
                errorMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.red,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
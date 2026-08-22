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
  List<Map<String, dynamic>> stepHistory = [];


  final int stepGoal = 10000;

  String errorMessage = "";
  Future<void> _loadStepHistory() async {
  try {
    final history = await _stepService.getStepHistory();

    if (!mounted) return;

    setState(() {
      stepHistory = history;
    });
  } catch (e) {
    // Keep the Steps page working even if history cannot load.
    if (!mounted) return;

    setState(() {
      stepHistory = [];
    });
  }
}

  @override
  void initState() {
    super.initState();

    _startTracking();
  }

 Future<void> _startTracking() async {
  await _stepService.startStepTracking(
    onStepsChanged: (value) async {
      if (!mounted) return;

      setState(() {
        steps = value;
        errorMessage = "";
      });

      await _stepService.saveTodaySteps(value);

      if (mounted) {
        await _loadStepHistory();
      }
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
  Widget _stepHistoryChart() {
  const days = [
    "Mon",
    "Tue",
    "Wed",
    "Thu",
    "Fri",
    "Sat",
    "Sun",
  ];

  final Map<String, int> historyMap = {};

  for (final item in stepHistory) {
    final date = item['date'];

    if (date is String) {
      historyMap[date] =
          (item['steps'] as num?)?.toInt() ?? 0;
    }
  }

  final now = DateTime.now();

  final monday = DateTime(
    now.year,
    now.month,
    now.day,
  ).subtract(
    Duration(days: now.weekday - 1),
  );

  final weeklySteps = List<int>.generate(7, (index) {
    final date = monday.add(Duration(days: index));

    final key =
        "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";

    return historyMap[key] ?? 0;
  });

  final maxSteps = weeklySteps.fold<int>(
    stepGoal,
    (maximum, value) =>
        value > maximum ? value : maximum,
  );

  return Card(
    elevation: 4,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Text(
            "7-Day Steps",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 5),

          const Text(
            "Your daily walking activity",
            style: TextStyle(
              color: Colors.grey,
            ),
          ),

          const SizedBox(height: 25),

          SizedBox(
            height: 230,
            width: double.infinity,
            child: Row(
              crossAxisAlignment:
                  CrossAxisAlignment.end,
              mainAxisAlignment:
                  MainAxisAlignment.spaceAround,
              children: List.generate(
                7,
                (index) {
                  final value = weeklySteps[index];

                  final barHeight = value == 0
                      ? 6.0
                      : (value / maxSteps) * 150;

                  return Expanded(
                    child: Padding(
                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 4,
                      ),
                      child: Column(
                        mainAxisAlignment:
                            MainAxisAlignment.end,
                        children: [
                          Text(
                            value == 0
                                ? "-"
                                : value.toString(),
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 5),

                          Flexible(
                            child: Align(
                              alignment:
                                  Alignment.bottomCenter,
                              child: AnimatedContainer(
                                duration:
                                    const Duration(
                                  milliseconds: 500,
                                ),
                                width: double.infinity,
                                height: barHeight,
                                decoration:
                                    BoxDecoration(
                                  color:
                                      Colors.deepPurple,
                                  borderRadius:
                                      BorderRadius.circular(
                                    8,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 8),

                          Text(
                            days[index],
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          const SizedBox(height: 15),

          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius:
                      BorderRadius.circular(3),
                ),
              ),

              const SizedBox(width: 8),

              const Text(
                "Steps",
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),

              const Spacer(),

              Text(
                "Goal: $stepGoal",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
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
            const SizedBox(height: 25),

_stepHistoryChart(),

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
import 'package:flutter/material.dart';

import 'add_sleep_screen.dart';
import 'models/sleep_model.dart';
import 'services/sleep_service.dart';

class SleepScreen extends StatefulWidget {
  const SleepScreen({super.key});

  @override
  State<SleepScreen> createState() => _SleepScreenState();
}

class _SleepScreenState extends State<SleepScreen> {
  final SleepService sleepService = SleepService();

List<int> weeklySleepMinutes = [];
bool weeklyLoading = true;
@override
void initState() {
  super.initState();
  loadWeeklySleep();
}

Future<void> loadWeeklySleep() async {
  final data = await sleepService.getWeeklySleepMinutes();

  if (!mounted) return;

  setState(() {
    weeklySleepMinutes = data;
    weeklyLoading = false;
  });
}
  

  String formatDuration(int minutes) {
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;

    if (remainingMinutes == 0) {
      return "$hours hr";
    }

    return "$hours hr $remainingMinutes min";
  }

  String formatTime(
    BuildContext context,
    DateTime time,
  ) {
    return TimeOfDay.fromDateTime(time).format(context);
  }
  Widget weeklySleepChart() {
  const days = [
    "Mon",
    "Tue",
    "Wed",
    "Thu",
    "Fri",
    "Sat",
    "Sun",
  ];

  final maxValue = weeklySleepMinutes.isEmpty
      ? 480
      : weeklySleepMinutes.reduce(
          (a, b) => a > b ? a : b,
        );

  return Card(
    elevation: 4,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(18),
    ),
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "7-Day Sleep",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          

          SizedBox(
            height: 200,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment:
                  MainAxisAlignment.spaceAround,
              children: List.generate(
                7,
                (index) {
                  final minutes =
                      weeklySleepMinutes.length > index
                          ? weeklySleepMinutes[index]
                          : 0;

                  final height = minutes == 0
                      ? 8.0
                      : (minutes / maxValue) * 120;

                  final hours = minutes ~/ 60;
                  final remaining = minutes % 60;

                  return Column(
                    mainAxisAlignment:
                        MainAxisAlignment.end,
                    children: [
                      Text(
                        minutes == 0
                            ? "-"
                            : "${hours}h ${remaining}m",
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 5),

                      Container(
                        width: 25,
                        height: height,
                        decoration: BoxDecoration(
                          color: Colors.deepPurple,
                          borderRadius:
                              BorderRadius.circular(8),
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        days[index],
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
SleepModel? getLastNightSleep(List<SleepModel> sleeps) {
  final now = DateTime.now();

  final today = DateTime(
    now.year,
    now.month,
    now.day,
  );

  for (final sleep in sleeps) {
    final wakeDate = DateTime(
      sleep.wakeTime.year,
      sleep.wakeTime.month,
      sleep.wakeTime.day,
    );

    if (wakeDate == today) {
      return sleep;
    }
  }

  return null;
}


  @override
  Widget build(BuildContext context) {
    

    return Scaffold(
  appBar: AppBar(
    title: const Text("Sleep"),
  ),

  floatingActionButton: FloatingActionButton(
    backgroundColor: Colors.deepPurple,
    child: const Icon(Icons.add),
    onPressed: () async {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const AddSleepScreen(),
        ),
      );

      if (mounted) {
        loadWeeklySleep();
      }
    },
  ),

  body: StreamBuilder<List<SleepModel>>(
    stream: sleepService.getSleep(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      final sleeps = snapshot.data ?? [];

      if (sleeps.isEmpty) {
        return const Center(
          child: Text(
            "No sleep recorded yet",
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey,
            ),
          ),
        );
      }

      final latestSleep = getLastNightSleep(sleeps);
      if (latestSleep == null) {
  return ListView(
    padding: const EdgeInsets.all(20),
    children: [
      const SizedBox(height: 40),

      const Icon(
        Icons.bedtime,
        size: 70,
        color: Colors.deepPurple,
      ),

      const SizedBox(height: 20),

      const Center(
        child: Text(
          "No sleep recorded today",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      const SizedBox(height: 10),

      const Center(
        child: Text(
          "Log your sleep to start tracking today.",
          style: TextStyle(
            color: Colors.grey,
          ),
          textAlign: TextAlign.center,
        ),
      ),

      const SizedBox(height: 30),

      ElevatedButton.icon(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddSleepScreen(),
            ),
          );

          if (mounted) {
            loadWeeklySleep();
          }
        },
        icon: const Icon(Icons.add),
        label: const Text("Log Sleep"),
      ),
    ],
  );
}

      const sleepGoal = 480;

      final progress =
          (latestSleep!.durationMinutes / sleepGoal)
              .clamp(0.0, 1.0);

      return ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const SizedBox(height: 15),

          // Main sleep card
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            child: Padding(
              padding: const EdgeInsets.all(25),
              child: Column(
                children: [
                  const Icon(
                    Icons.bedtime,
                    size: 55,
                    color: Colors.deepPurple,
                  ),

                  const SizedBox(height: 15),

                  const Text(
                    "Last Night",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    formatDuration(
                      latestSleep!.durationMinutes,
                    ),
                    style: const TextStyle(
                      fontSize: 38,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),

                  const SizedBox(height: 25),

                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          const Icon(
                            Icons.nightlight,
                            color: Colors.deepPurple,
                          ),
                          const SizedBox(height: 5),
                          const Text("Bedtime"),
                          const SizedBox(height: 3),
                          Text(
                            formatTime(
                              context,
                              latestSleep!.bedtime,
                            ),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      Column(
                        children: [
                          const Icon(
                            Icons.wb_sunny,
                            color: Colors.orange,
                          ),
                          const SizedBox(height: 5),
                          const Text("Wake Up"),
                          const SizedBox(height: 3),
                          Text(
                            formatTime(
                              context,
                              latestSleep!.wakeTime,
                            ),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Sleep Goal
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Sleep Goal",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Text(
                        "${latestSleep!.durationMinutes} / $sleepGoal min",
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  LinearProgressIndicator(
                    value: progress,
                    minHeight: 10,
                    borderRadius:
                        BorderRadius.circular(10),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "${(progress * 100).toStringAsFixed(0)}% of daily goal",
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 25),

          // 7-Day Sleep Chart
          weeklySleepChart(),

          const SizedBox(height: 25),

          const Text(
            "Sleep History",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          ...sleeps.map(
            (sleep) {
              return Card(
                child: ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.bedtime),
                  ),

                  title: Text(
                    formatDuration(
                      sleep.durationMinutes,
                    ),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  subtitle: Text(
                    "${formatTime(context, sleep.bedtime)} → "
                    "${formatTime(context, sleep.wakeTime)}",
                  ),

                  trailing: IconButton(
                    icon: const Icon(
                      Icons.delete_outline,
                      color: Colors.red,
                    ),
                    onPressed: () async {
                      await sleepService.deleteSleep(
                        sleep.id,
                      );

                      loadWeeklySleep();
                    },
                  ),
                ),
              );
            },
          ),
        ],
      );
    },
  ),
);

  }    
}
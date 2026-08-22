import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import 'models/sleep_model.dart';
import 'services/sleep_service.dart';

class AddSleepScreen extends StatefulWidget {
  const AddSleepScreen({super.key});

  @override
  State<AddSleepScreen> createState() => _AddSleepScreenState();
}

class _AddSleepScreenState extends State<AddSleepScreen> {
  final SleepService sleepService = SleepService();

  TimeOfDay bedtime = const TimeOfDay(
    hour: 23,
    minute: 0,
  );

  TimeOfDay wakeTime = const TimeOfDay(
    hour: 7,
    minute: 0,
  );

  bool isLoading = false;

  Future<void> selectBedtime() async {
    final selected = await showTimePicker(
      context: context,
      initialTime: bedtime,
    );

    if (selected != null) {
      setState(() {
        bedtime = selected;
      });
    }
  }

  Future<void> selectWakeTime() async {
    final selected = await showTimePicker(
      context: context,
      initialTime: wakeTime,
    );

    if (selected != null) {
      setState(() {
        wakeTime = selected;
      });
    }
  }

  int calculateDuration() {
    int bedtimeMinutes =
        bedtime.hour * 60 + bedtime.minute;

    int wakeMinutes =
        wakeTime.hour * 60 + wakeTime.minute;

    // If wake time is earlier than bedtime,
    // assume the sleep continued into the next day.
    if (wakeMinutes <= bedtimeMinutes) {
      wakeMinutes += 24 * 60;
    }

    return wakeMinutes - bedtimeMinutes;
  }

  String formatDuration(int minutes) {
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;

    if (remainingMinutes == 0) {
      return "$hours hr";
    }

    return "$hours hr $remainingMinutes min";
  }

  DateTime createDateTime(
    TimeOfDay time,
    DateTime date,
  ) {
    return DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
  }

  Future<void> saveSleep() async {
    setState(() {
      isLoading = true;
    });

    try {
      final now = DateTime.now();

      final duration = calculateDuration();

      final bedtimeDate = createDateTime(
        bedtime,
        now,
      );

      DateTime wakeDate = createDateTime(
        wakeTime,
        now,
      );

      // Wake time belongs to the next day
      // when it is earlier than or equal to bedtime.
      if (wakeTimeToMinutes() <= bedtimeToMinutes()) {
        wakeDate = wakeDate.add(
          const Duration(days: 1),
        );
      }

      final sleep = SleepModel(
        id: const Uuid().v4(),
        bedtime: bedtimeDate,
        wakeTime: wakeDate,
        durationMinutes: duration,
        date: now,
      );

      await sleepService.addSleep(sleep);

      if (!mounted) return;

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  int bedtimeToMinutes() {
    return bedtime.hour * 60 + bedtime.minute;
  }

  int wakeTimeToMinutes() {
    return wakeTime.hour * 60 + wakeTime.minute;
  }

  String formatTime(
    BuildContext context,
    TimeOfDay time,
  ) {
    return time.format(context);
  }

  @override
  Widget build(BuildContext context) {
    final duration = calculateDuration();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Log Sleep"),
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const SizedBox(height: 20),

          const Icon(
            Icons.bedtime,
            size: 70,
            color: Colors.deepPurple,
          ),

          const SizedBox(height: 15),

          const Center(
            child: Text(
              "Track Your Sleep",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 30),

          // Bedtime
          Card(
            child: ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.nightlight),
              ),

              title: const Text("Bedtime"),

              subtitle: Text(
                formatTime(context, bedtime),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              trailing: const Icon(
                Icons.edit,
              ),

              onTap: selectBedtime,
            ),
          ),

          const SizedBox(height: 15),

          // Wake time
          Card(
            child: ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.wb_sunny),
              ),

              title: const Text("Wake-up Time"),

              subtitle: Text(
                formatTime(context, wakeTime),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              trailing: const Icon(
                Icons.edit,
              ),

              onTap: selectWakeTime,
            ),
          ),

          const SizedBox(height: 25),

          // Duration
          Card(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: Padding(
              padding: const EdgeInsets.all(25),
              child: Column(
                children: [
                  const Text(
                    "Sleep Duration",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    formatDuration(duration),
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 30),

          SizedBox(
            height: 55,
            child: ElevatedButton.icon(
              onPressed:
                  isLoading ? null : saveSleep,

              icon: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.save),

              label: Text(
                isLoading
                    ? "Saving..."
                    : "Save Sleep",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
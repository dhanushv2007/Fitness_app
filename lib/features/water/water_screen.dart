import 'package:flutter/material.dart';

import 'models/water_model.dart';
import 'services/water_service.dart';

class WaterScreen extends StatefulWidget {
  const WaterScreen({super.key});

  @override
  State<WaterScreen> createState() => _WaterScreenState();
}

class _WaterScreenState extends State<WaterScreen> {
  final WaterService waterService = WaterService();

  WaterModel? water;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadWater();
  }

  Future<void> loadWater() async {
    final data = await waterService.getWater();

    if (!mounted) return;

    setState(() {
      water = data;
      isLoading = false;
    });
  }

  Future<void> addWater() async {
    double consumed = water!.consumed + 0.25;

    if (consumed > water!.goal) {
      consumed = water!.goal;
    }

    await waterService.saveWater(
      consumed,
      water!.goal,
    );

    loadWater();
  }

  Future<void> removeWater() async {
    double consumed = water!.consumed - 0.25;

    if (consumed < 0) {
      consumed = 0;
    }

    await waterService.saveWater(
      consumed,
      water!.goal,
    );

    loadWater();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final percent = water!.consumed / water!.goal;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Water Tracker"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            const SizedBox(height: 20),

            const Icon(
              Icons.water_drop,
              color: Colors.blue,
              size: 100,
            ),

            const SizedBox(height: 20),

            Text(
              "${water!.consumed.toStringAsFixed(2)} / ${water!.goal.toStringAsFixed(1)} L",
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 25),

            LinearProgressIndicator(
              value: percent,
              minHeight: 14,
              borderRadius: BorderRadius.circular(20),
            ),

            const SizedBox(height: 40),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [

                ElevatedButton.icon(
                  onPressed: removeWater,
                  icon: const Icon(Icons.remove),
                  label: const Text("-250 ml"),
                ),

                ElevatedButton.icon(
                  onPressed: addWater,
                  icon: const Icon(Icons.add),
                  label: const Text("+250 ml"),
                ),

              ],
            ),
          ],
        ),
      ),
    );
  }
}
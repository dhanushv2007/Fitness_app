import 'package:flutter/material.dart';

class CalorieCounterScreen extends StatefulWidget {
  const CalorieCounterScreen({super.key});

  @override
  State<CalorieCounterScreen> createState() => _CalorieCounterScreenState();
}

class _CalorieCounterScreenState extends State<CalorieCounterScreen> {
  int calories = 1200;

  void increaseCalories() {
    setState(() {
      calories++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Calories"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Calories",
              style: TextStyle(fontSize: 28),
            ),
            const SizedBox(height: 20),
            Text(
              "$calories",
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: increaseCalories,
              child: const Text("+"),
            ),
          ],
        ),
      ),
    );
  }
}
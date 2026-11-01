import 'package:flutter/material.dart';

import 'data/food_database.dart';
import 'models/food_model.dart';

class FoodSearchScreen extends StatefulWidget {
  const FoodSearchScreen({super.key});

  @override
  State<FoodSearchScreen> createState() => _FoodSearchScreenState();
}

class _FoodSearchScreenState extends State<FoodSearchScreen> {
  List<FoodModel> foods = FoodDatabase.foods;

  void searchFood(String value) {
    setState(() {
      foods = FoodDatabase.foods
          .where(
            (food) => food.name
                .toLowerCase()
                .contains(value.toLowerCase()),
          )
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search Food"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: searchFood,
              decoration: InputDecoration(
                hintText: "Search food...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: foods.length,
              itemBuilder: (context, index) {
                final food = foods[index];

                return ListTile(
                  leading: const Icon(Icons.restaurant),
                  title: Text(food.name),
                  subtitle: Text(
                    "${food.calories} kcal",
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.pop(context, food);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
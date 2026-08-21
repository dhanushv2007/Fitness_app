import 'package:flutter/material.dart';

import 'add_meal_screen.dart';
import 'models/meal_model.dart';
import 'services/meal_service.dart';

class MealsScreen extends StatelessWidget {
  const MealsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final MealService mealService = MealService();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Meals"),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddMealScreen(),
            ),
          );
        },
      ),

      body: StreamBuilder<List<MealModel>>(
        stream: mealService.getMeals(),
        builder: (context, snapshot) {

          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final allMeals = snapshot.data ?? [];

final today = DateTime.now();

final meals = allMeals.where((meal) {
  return meal.date.year == today.year &&
      meal.date.month == today.month &&
      meal.date.day == today.day;
}).toList();

          int calories = 0;
          double protein = 0;
          double carbs = 0;
          double fats = 0;

          for (var meal in meals) {
            calories += meal.calories;
            protein += meal.protein;
            carbs += meal.carbs;
            fats += meal.fats;
          }

          return Column(
            children: [

              Container(
                margin: const EdgeInsets.all(15),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(20),
                ),

                child: Column(
                  children: [

                    const Text(
                      "Today's Nutrition",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceAround,
                      children: [

                        nutritionTile(
                          calories.toString(),
                          "Calories",
                        ),

                        nutritionTile(
                          protein.toStringAsFixed(1),
                          "Protein",
                        ),

                        nutritionTile(
                          carbs.toStringAsFixed(1),
                          "Carbs",
                        ),

                        nutritionTile(
                          fats.toStringAsFixed(1),
                          "Fat",
                        ),

                      ],
                    ),
                  ],
                ),
              ),

              Expanded(
                child: meals.isEmpty
                    ? const Center(
                        child: Text(
                          "No meals added",
                          style: TextStyle(fontSize: 18),
                        ),
                      )
                    : ListView.builder(
                        itemCount: meals.length,
                        itemBuilder: (context, index) {

                          final meal = meals[index];

                          return Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 8,
                            ),

                            child: ListTile(

                              leading: CircleAvatar(
                                backgroundColor:
                                    Colors.green.shade100,
                                child: const Icon(
                                  Icons.restaurant,
                                  color: Colors.green,
                                ),
                              ),

                              title: Text(meal.foodName),

                              subtitle: Text(
                                meal.mealType,
                              ),

                              trailing: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.center,

                                children: [

                                  Text(
                                    "${meal.calories}",
                                    style: const TextStyle(
                                      fontWeight:
                                          FontWeight.bold,
                                    ),
                                  ),

                                  const Text("kcal"),
                                ],
                              ),

                              onLongPress: () async {
                                await mealService
                                    .deleteMeal(meal.id);
                              },
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget nutritionTile(
    String value,
    String label,
  ) {
    return Column(
      children: [

        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),

        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
          ),
        ),
      ],
    );
  }
}
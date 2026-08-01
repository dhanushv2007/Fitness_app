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
        title: const Text("Today's Meals"),
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
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                "No meals added today",
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          final meals = snapshot.data!;

          final totalCalories = meals.fold(
            0,
            (sum, meal) => sum + meal.calories,
          );

          return Column(
            children: [

              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    const Text(
                      "Today's Calories",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),

                    Text(
                      "$totalCalories kcal",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),

                  ],
                ),
              ),

              Expanded(
                child: ListView.builder(
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
                          backgroundColor: Colors.green.shade100,
                          child: const Icon(
                            Icons.restaurant,
                            color: Colors.green,
                          ),
                        ),

                        title: Text(meal.foodName),

                        subtitle: Text(
                          "${meal.mealType}\n"
                          "Protein: ${meal.protein}g | "
                          "Carbs: ${meal.carbs}g | "
                          "Fat: ${meal.fats}g",
                        ),

                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [

                            Text(
                              "${meal.calories}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),

                            const Text("kcal"),
                          ],
                        ),

                        isThreeLine: true,

                        onLongPress: () async {

                          await mealService.deleteMeal(meal.id);

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
}
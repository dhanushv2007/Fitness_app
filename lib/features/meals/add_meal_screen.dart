import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import 'models/meal_model.dart';
import 'services/meal_service.dart';

class AddMealScreen extends StatefulWidget {
  const AddMealScreen({super.key});

  @override
  State<AddMealScreen> createState() => _AddMealScreenState();
}

class _AddMealScreenState extends State<AddMealScreen> {
  final _formKey = GlobalKey<FormState>();

  final foodController = TextEditingController();
  final caloriesController = TextEditingController();
  final proteinController = TextEditingController();
  final carbsController = TextEditingController();
  final fatsController = TextEditingController();

  final MealService mealService = MealService();

  String mealType = "Breakfast";

  bool isLoading = false;

  Future<void> saveMeal() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    final meal = MealModel(
      id: const Uuid().v4(),
      mealType: mealType,
      foodName: foodController.text.trim(),
      calories: int.parse(caloriesController.text),
      protein: double.parse(proteinController.text),
      carbs: double.parse(carbsController.text),
      fats: double.parse(fatsController.text),
      date: DateTime.now(),
    );

    await mealService.addMeal(meal);

    if (!mounted) return;

    Navigator.pop(context);

    setState(() {
      isLoading = false;
    });
  }

  Widget numberField(
    TextEditingController controller,
    String label,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Required";
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    foodController.dispose();
    caloriesController.dispose();
    proteinController.dispose();
    carbsController.dispose();
    fatsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Meal"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Form(
          key: _formKey,

          child: ListView(
            children: [

              DropdownButtonFormField<String>(
                value: mealType,

                decoration: const InputDecoration(
                  labelText: "Meal Type",
                  border: OutlineInputBorder(),
                ),

                items: const [

                  DropdownMenuItem(
                    value: "Breakfast",
                    child: Text("Breakfast"),
                  ),

                  DropdownMenuItem(
                    value: "Lunch",
                    child: Text("Lunch"),
                  ),

                  DropdownMenuItem(
                    value: "Dinner",
                    child: Text("Dinner"),
                  ),

                  DropdownMenuItem(
                    value: "Snacks",
                    child: Text("Snacks"),
                  ),
                ],

                onChanged: (value) {
                  setState(() {
                    mealType = value!;
                  });
                },
              ),

              const SizedBox(height: 20),

              TextFormField(
                controller: foodController,

                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Enter food";
                  }
                  return null;
                },

                decoration: InputDecoration(
                  labelText: "Food Name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              numberField(
                caloriesController,
                "Calories",
              ),

              numberField(
                proteinController,
                "Protein (g)",
              ),

              numberField(
                carbsController,
                "Carbs (g)",
              ),

              numberField(
                fatsController,
                "Fat (g)",
              ),

              const SizedBox(height: 25),

              SizedBox(
                height: 55,

                child: ElevatedButton(
                  onPressed: isLoading ? null : saveMeal,

                  child: isLoading
                      ? const CircularProgressIndicator()
                      : const Text(
                          "Save Meal",
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
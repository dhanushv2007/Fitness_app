class MealModel {
  final String id;
  final String mealType;
  final String foodName;
  final int calories;
  final double protein;
  final double carbs;
  final double fats;
  final DateTime date;

  MealModel({
    required this.id,
    required this.mealType,
    required this.foodName,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fats,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'mealType': mealType,
      'foodName': foodName,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fats': fats,
      'date': date.toIso8601String(),
    };
  }

  factory MealModel.fromMap(Map<String, dynamic> map) {
    return MealModel(
      id: map['id'],
      mealType: map['mealType'],
      foodName: map['foodName'],
      calories: map['calories'],
      protein: (map['protein'] as num).toDouble(),
      carbs: (map['carbs'] as num).toDouble(),
      fats: (map['fats'] as num).toDouble(),
      date: DateTime.parse(map['date']),
    );
  }
  
}
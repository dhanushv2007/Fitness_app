class CalorieCalculator {
  static double calculateCalories({
    required int age,
    required double height,
    required double weight,
    required String gender,
    required String goal,
    required String activityLevel,
  }) {
    double bmr;

    if (gender == "Male") {
      bmr =
          10 * weight +
          6.25 * height -
          5 * age +
          5;
    } else {
      bmr =
          10 * weight +
          6.25 * height -
          5 * age -
          161;
    }

    double activityMultiplier = 1.2;

    switch (activityLevel) {
      case "Lightly Active":
        activityMultiplier = 1.375;
        break;

      case "Moderately Active":
        activityMultiplier = 1.55;
        break;

      case "Very Active":
        activityMultiplier = 1.725;
        break;
    }

    double calories = bmr * activityMultiplier;

    switch (goal) {
      case "Lose Weight":
        calories -= 500;
        break;

      case "Gain Muscle":
        calories += 300;
        break;

      case "Maintain Weight":
        break;
    }

    return calories;
  }
}
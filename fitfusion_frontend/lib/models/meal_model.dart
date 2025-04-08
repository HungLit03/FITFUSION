// lib/models/meal_model.dart
class Meal {
  final String dishName;
  final int calories;
  final Map<String, dynamic> macronutrients;

  Meal({
    required this.dishName,
    required this.calories,
    required this.macronutrients,
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      dishName: json['dishName'],
      calories: json['calories'],
      macronutrients: Map<String, dynamic>.from(json['macronutrients']),
    );
  }
}

class DailyMealPlan {
  final Meal breakfast;
  final Meal lunch;
  final Meal dinner;

  DailyMealPlan({
    required this.breakfast,
    required this.lunch,
    required this.dinner,
  });

  factory DailyMealPlan.fromJson(Map<String, dynamic> json) {
    return DailyMealPlan(
      breakfast: Meal.fromJson(json['breakfast']),
      lunch: Meal.fromJson(json['lunch']),
      dinner: Meal.fromJson(json['dinner']),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:fitfusion_frontend/theme/theme.dart';
import 'package:fitfusion_frontend/models/user_info_model.dart';
import 'package:fitfusion_frontend/services/meal_service.dart';
import 'nutrition_summary.dart';

class CaloriesSummaryScreen extends StatelessWidget {
  final List<Map<String, dynamic>> selectedFoods;
  final UserInfoModel userInfo;

  const CaloriesSummaryScreen({
    super.key,
    required this.selectedFoods,
    required this.userInfo,
  });

  // Hàm gộp các món ăn cùng loại
  List<Map<String, dynamic>> get _groupedFoods {
    final Map<String, Map<String, dynamic>> foodMap = {};

    for (final food in selectedFoods) {
      final name = food['name'];
      if (foodMap.containsKey(name)) {
        foodMap[name]!['selected_quantity'] += food['selected_quantity'];
        foodMap[name]!['total_calories'] += food['total_calories'];
        foodMap[name]!['total_protein'] += food['total_protein'];
        foodMap[name]!['total_carb'] += food['total_carb'];
        foodMap[name]!['total_fats'] += food['total_fats'];
      } else {
        foodMap[name] = {...food};
      }
    }

    return foodMap.values.toList();
  }

  void _removeFood(int index, BuildContext context) {
    final foodName = _groupedFoods[index]['name'];
    selectedFoods.removeWhere((food) => food['name'] == foodName);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => CaloriesSummaryScreen(
          selectedFoods: selectedFoods,
          userInfo: userInfo,
        ),
      ),
    );
  }

  int get _totalCalories {
    return selectedFoods.fold(
        0, (sum, item) => sum + (item['total_calories'] as int));
  }

  Future<void> _goToSummary(BuildContext context) async {
    try {
      final dailyPlan = await MealService.loadDailyMealPlan();
      final totalCalories = dailyPlan.breakfast.calories +
          dailyPlan.lunch.calories +
          dailyPlan.dinner.calories;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NutritionSummaryScreen(
            totalCalories: totalCalories,
            foods: selectedFoods,
            userInfo: userInfo,
          ),
        ),
      );
    } catch (e) {
      // Fallback: Tính tổng từ selectedFoods nếu load JSON thất bại
      final fallbackCalories = _totalCalories;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NutritionSummaryScreen(
            totalCalories: fallbackCalories,
            foods: selectedFoods,
            userInfo: userInfo,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final groupedFoods = _groupedFoods;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Center(
          child: Text(
            'TÍNH CALORIES',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        backgroundColor: AppColors.primary,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('Danh sách món ăn:',
                style: AppTextStyles.little_title_1),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: groupedFoods.length,
                itemBuilder: (context, index) {
                  final food = groupedFoods[index];
                  return Dismissible(
                    key: Key(food['name'] + index.toString()),
                    background: Container(color: Colors.red),
                    onDismissed: (direction) => _removeFood(index, context),
                    child: ListTile(
                      title: Text(
                        food['name'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      subtitle: Text(
                        '${food['selected_quantity']} ${food['baseUnit']} - ${food['total_calories']} calo',
                        style: const TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 16),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _removeFood(index, context),
                      ),
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              style: ButtonStyles.buttonTwo,
              onPressed: () => _goToSummary(context),
              child:
                  const Text('TỔNG CALO', style: AppTextStyles.textButtonTwo),
            ),
          ],
        ),
      ),
    );
  }
}

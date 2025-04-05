import 'package:flutter/material.dart';
import 'package:fitfusion_frontend/theme/theme.dart';

class CaloriesSummaryScreen extends StatelessWidget {
  final List<Map<String, dynamic>> selectedFoods;

  const CaloriesSummaryScreen({super.key, required this.selectedFoods});

  int get _totalCalories {
    return selectedFoods.fold(
        0, (sum, item) => sum + (item['total_calories'] as int));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tổng Calories', style: AppTextStyles.little_title),
        backgroundColor: AppColors.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('Danh sách món ăn:',
                style: AppTextStyles.little_title_1),
            const SizedBox(height: 10),

            // Danh sách món đã chọn
            Expanded(
              child: ListView.builder(
                itemCount: selectedFoods.length,
                itemBuilder: (context, index) {
                  final food = selectedFoods[index];
                  return ListTile(
                    title: Text(food['name']),
                    subtitle: Text(
                        '${food['selected_quantity']}g - ${food['total_calories']} calo'),
                  );
                },
              ),
            ),

            // Tổng calories
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                // ignore: deprecated_member_use
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('TỔNG CALO:', style: AppTextStyles.little_title_1),
                  Text('$_totalCalories calo',
                      style: AppTextStyles.little_title),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

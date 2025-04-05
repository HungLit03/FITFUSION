import 'package:flutter/material.dart';
import 'package:fitfusion_frontend/theme/theme.dart';
import 'nutrition_summary.dart';
import 'package:fitfusion_frontend/models/user_info_model.dart';

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
        // Cộng dồn nếu đã có món này
        foodMap[name]!['selected_quantity'] += food['selected_quantity'];
        foodMap[name]!['total_calories'] += food['total_calories'];
        foodMap[name]!['total_protein'] += food['total_protein'];
        foodMap[name]!['total_carb'] += food['total_carb'];
        foodMap[name]!['total_fats'] += food['total_fats'];
      } else {
        // Thêm mới nếu chưa có
        foodMap[name] = {...food};
      }
    }

    return foodMap.values.toList();
  }

  // Hàm xóa món ăn
  void _removeFood(int index, BuildContext context) {
    //xóa toàn bộ món cùng loại
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
        centerTitle: true, // Đảm bảo tiêu đề ở giữa
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
                          fontWeight: FontWeight.bold, // Thêm dòng này
                          fontSize: 20, // Tăng kích thước chữ nếu cần
                        ),
                      ),
                      subtitle: Text(
                        '${food['selected_quantity']} ${food['baseUnit']} - ${food['total_calories']} calo',
                        style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16), // Làm chữ to hơn
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

            // Nút Tổng Calo
            ElevatedButton(
              style: ButtonStyles.buttonTwo,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NutritionSummaryScreen(
                      totalCalories: _totalCalories,
                      foods: selectedFoods,
                      userInfo: userInfo,
                    ),
                  ),
                );
              },
              child:
                  const Text('TỔNG CALO', style: AppTextStyles.textButtonTwo),
            ),
          ],
        ),
      ),
    );
  }
}

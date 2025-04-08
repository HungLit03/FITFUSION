import 'package:fitfusion_frontend/models/meal_model.dart';
import 'package:fitfusion_frontend/models/user_info_model.dart';
import 'package:fitfusion_frontend/services/meal_service.dart';
import 'package:flutter/material.dart';
import 'package:fitfusion_frontend/theme/theme.dart';
import 'calories_summary.dart';
import 'package:flutter/services.dart';

class CaloriesScreen extends StatefulWidget {
  final UserInfoModel userInfo;

  const CaloriesScreen({
    super.key,
    required this.userInfo,
  });

  @override
  CaloriesScreenState createState() => CaloriesScreenState();
}

class CaloriesScreenState extends State<CaloriesScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<Map<String, dynamic>> _selectedFoods = [];
  Map<String, dynamic>? _selectedFood;
  int _quantity = 100;
  bool _showAddPanel = false;
  List<Map<String, dynamic>> _foodList = [];
  List<Map<String, dynamic>> _filteredFoodList = [];
  bool _showNotFound = false;

  @override
  void initState() {
    super.initState();
    _loadFoodData();
  }

  Future<void> _loadFoodData() async {
    try {
      final dailyPlan = await MealService.loadDailyMealPlan();

      setState(() {
        _foodList = [
          _convertMealToMap(dailyPlan.breakfast),
          _convertMealToMap(dailyPlan.lunch),
          _convertMealToMap(dailyPlan.dinner),
        ];
        _filteredFoodList = _foodList;
      });
    } catch (e) {
      print('Error loading meals: $e');
      // Fallback data
      setState(() {
        _foodList = [
          {
            'name': 'Cơm',
            'calories': 130,
            'protein': 3,
            'carb': 28,
            'fats': 0.3,
            'unit': 'bát',
            'type': 'rice',
            'baseUnit': 'bát',
            'baseQuantity': 1,
            'baseCalories': 130,
          },
          {
            'name': 'Chuối',
            'calories': 89,
            'protein': 1.1,
            'carb': 23,
            'fats': 0.3,
            'unit': 'trái',
            'type': 'fruit',
            'baseUnit': 'trái',
            'baseQuantity': 1,
            'baseCalories': 89,
          },
        ];
        _filteredFoodList = _foodList;
      });
    }
  }

  Map<String, dynamic> _convertMealToMap(Meal meal) {
    return {
      'name': meal.dishName,
      'calories': meal.calories,
      'protein': meal.macronutrients['protein'],
      'carb': meal.macronutrients['carbs'],
      'fats': meal.macronutrients['fats'],
      'unit': 'phần',
      'type': 'custom',
      'baseUnit': 'phần', // Thêm các trường cần thiết
      'baseQuantity': 1,
      'baseCalories': meal.calories,
    };
  }

  @override
  Widget build(BuildContext context) {
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
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Tìm kiếm món ăn...',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _searchFood,
                ),
                filled: true,
                fillColor: AppColors.gray,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              inputFormatters: [
                FilteringTextInputFormatter.deny(RegExp(r'[0-9]')),
              ],
              onChanged: (value) => _searchFood(),
            ),
            const SizedBox(height: 20),
            if (_showNotFound)
              const Text('Không tìm thấy món ăn phù hợp',
                  style: TextStyle(color: Colors.red)),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: _filteredFoodList.length,
                itemBuilder: (context, index) {
                  final food = _filteredFoodList[index];
                  return Card(
                    color: AppColors.background,
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      title: Text(food['name'],
                          style: AppTextStyles.little_title_1),
                      subtitle:
                          Text('${food['unit']} - ${food['calories']} calo'),
                      trailing: IconButton(
                        icon: const Icon(Icons.add, color: AppColors.primary),
                        onPressed: () => _showAddFoodPanel(food),
                      ),
                    ),
                  );
                },
              ),
            ),
            if (_showAddPanel && _selectedFood != null) ...[
              _buildAddFoodPanel(),
              const SizedBox(height: 10),
            ],
            ElevatedButton(
              style: ButtonStyles.buttonTwo,
              onPressed: _selectedFoods.isNotEmpty ? _goToSummary : null,
              child: const Text('TIẾP TỤC', style: AppTextStyles.textButtonTwo),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddFoodPanel() {
    final food = _selectedFood!;

    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(food['name'], style: AppTextStyles.little_title_1),
            const SizedBox(height: 10),
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Số lượng ${food['baseUnit']}',
                border: const OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _quantity = int.tryParse(value) ?? 0;
                });
              },
            ),
            const SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Calories: ${_calculateCalories()} calo'),
                Text('Protein: ${_calculateNutrient('protein')}g'),
                Text('Carb: ${_calculateNutrient('carb')}g'),
                Text('Fats: ${_calculateNutrient('fats')}g'),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => setState(() => _showAddPanel = false),
                  child: const Text('HỦY'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _addFoodToMenu,
                  style: ButtonStyles.buttonOne,
                  child: const Text('OK'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  double _calculateNutrient(String nutrient) {
    if (_selectedFood == null || _quantity <= 0) return 0;
    return (_selectedFood![nutrient] *
        _quantity /
        _selectedFood!['baseQuantity']);
  }

  int _calculateCalories() {
    if (_selectedFood == null || _quantity <= 0) return 0;
    return (_selectedFood!['baseCalories'] * _quantity).round();
  }

  void _searchFood() {
    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) {
      setState(() {
        _filteredFoodList = _foodList;
        _showNotFound = false;
      });
      return;
    }

    final normalizedQuery = _removeVietnameseAccent(query);
    final results = _foodList.where((food) {
      final foodName = food['name'].toLowerCase();
      return _removeVietnameseAccent(foodName).contains(normalizedQuery) ||
          foodName.contains(query);
    }).toList();

    setState(() {
      _filteredFoodList = results;
      _showNotFound = results.isEmpty;
    });
  }

  String _removeVietnameseAccent(String str) {
    str = str.replaceAll(RegExp(r'[àáạảãâầấậẩẫăằắặẳẵ]'), 'a');
    str = str.replaceAll(RegExp(r'[èéẹẻẽêềếệểễ]'), 'e');
    str = str.replaceAll(RegExp(r'[ìíịỉĩ]'), 'i');
    str = str.replaceAll(RegExp(r'[òóọỏõôồốộổỗơờớợởỡ]'), 'o');
    str = str.replaceAll(RegExp(r'[ùúụủũưừứựửữ]'), 'u');
    str = str.replaceAll(RegExp(r'[ỳýỵỷỹ]'), 'y');
    str = str.replaceAll(RegExp(r'[đ]'), 'd');
    return str;
  }

  void _showAddFoodPanel(Map<String, dynamic> food) {
    setState(() {
      _selectedFood = food;
      _showAddPanel = true;
      _quantity = 100;
    });
  }

  void _addFoodToMenu() {
    if (_selectedFood == null || _quantity <= 0) return;

    setState(() {
      _selectedFoods.add({
        ..._selectedFood!,
        'selected_quantity': _quantity,
        'total_calories': _calculateCalories(),
        'total_protein': _calculateNutrient('protein'),
        'total_carb': _calculateNutrient('carb'),
        'total_fats': _calculateNutrient('fats'),
      });
      _showAddPanel = false;
    });
  }

  void _goToSummary() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CaloriesSummaryScreen(
          selectedFoods: _selectedFoods,
          userInfo: widget.userInfo,
        ),
      ),
    );
  }
}

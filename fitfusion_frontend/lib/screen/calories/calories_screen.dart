import 'package:flutter/material.dart';
import 'package:fitfusion_frontend/theme/theme.dart';
import 'calories_summary.dart';

class CaloriesScreen extends StatefulWidget {
  const CaloriesScreen({super.key});

  @override
  CaloriesScreenState createState() => CaloriesScreenState();
}

class CaloriesScreenState extends State<CaloriesScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<Map<String, dynamic>> _selectedFoods = [];
  Map<String, dynamic>? _selectedFood;
  int _quantity = 100;
  bool _showAddPanel = false;

  // Dữ liệu mẫu (có thể thay bằng API thực tế)
  final List<Map<String, dynamic>> _foodList = [
    {'name': 'Cơm', 'calories': 130, 'unit': 'chén (bát)'},
    {'name': 'Chuối', 'calories': 89, 'unit': '100g'},
    {'name': 'Thịt gà', 'calories': 165, 'unit': '100g'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tính Calories', style: AppTextStyles.little_title),
        backgroundColor: AppColors.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Ô tìm kiếm
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Tìm kiếm...',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _searchFood,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) => setState(() {}),
            ),
            const SizedBox(height: 20),

            // Danh sách món ăn
            Expanded(
              child: ListView.builder(
                itemCount: _foodList.length,
                itemBuilder: (context, index) {
                  final food = _foodList[index];
                  return Card(
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

            // Panel thêm món (ảnh 3)
            if (_showAddPanel && _selectedFood != null) ...[
              _buildAddFoodPanel(),
              const SizedBox(height: 10),
            ],

            // Nút tiếp tục
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
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_selectedFood!['name'], style: AppTextStyles.little_title_1),
            const SizedBox(height: 10),

            // Nhập số lượng
            TextField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Số lượng (g)',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _quantity = int.tryParse(value) ?? 0;
                });
              },
            ),
            const SizedBox(height: 10),

            // Định lượng calo
            Text(
              'Định lượng: ${(_selectedFood!['calories'] * _quantity / 100).round()} calo',
              style: AppTextStyles.normal,
            ),
            const SizedBox(height: 10),

            // Nút OK
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

  void _searchFood() {
    // Logic tìm kiếm (có thể kết nối API)
    setState(() {});
  }

  void _showAddFoodPanel(Map<String, dynamic> food) {
    setState(() {
      _selectedFood = food;
      _showAddPanel = true;
      _quantity = 100; // Reset về giá trị mặc định
    });
  }

  void _addFoodToMenu() {
    if (_selectedFood == null || _quantity <= 0) return;

    setState(() {
      _selectedFoods.add({
        ..._selectedFood!,
        'selected_quantity': _quantity,
        'total_calories':
            (_selectedFood!['calories'] * _quantity / 100).round(),
      });
      _showAddPanel = false;
    });
  }

  void _goToSummary() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            CaloriesSummaryScreen(selectedFoods: _selectedFoods),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:fitfusion_frontend/theme/theme.dart';
import 'package:fl_chart/fl_chart.dart';
import '../home.dart';
import 'package:fitfusion_frontend/models/user_info_model.dart';

class NutritionSummaryScreen extends StatelessWidget {
  final int totalCalories;
  final List<Map<String, dynamic>> foods;
  final UserInfoModel userInfo;

  const NutritionSummaryScreen({
    super.key,
    required this.totalCalories,
    required this.foods,
    required this.userInfo,
  });

  @override
  Widget build(BuildContext context) {
    // Tính tổng các chất dinh dưỡng
    double totalProtein =
        foods.fold(0, (sum, food) => sum + (food['total_protein'] ?? 0));
    double totalCarb =
        foods.fold(0, (sum, food) => sum + (food['total_carb'] ?? 0));
    double totalFats =
        foods.fold(0, (sum, food) => sum + (food['total_fats'] ?? 0));

    // Tính phần trăm năng lượng từ từng loại chất
    double proteinPercentage = (totalProtein * 4 / totalCalories * 100);
    double carbPercentage = (totalCarb * 4 / totalCalories * 100);
    double fatsPercentage = (totalFats * 9 / totalCalories * 100);

    // Điều kiện hiển thị cảnh báo
    bool showCalorieWarning = totalCalories > 700;
    bool showFatWarning = totalFats > 20;

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
      body: Column(
        children: [
          // Phần tổng lượng calo
          Container(
            height: MediaQuery.of(context).size.height * 0.3,
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Tổng calo:',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '$totalCalories calo',
                  style: const TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                // Cảnh báo calo
                if (showCalorieWarning)
                  const Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Text(
                      'Cảnh báo: Lượng calo vượt mức tiêu chuẩn!',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Phần chi tiết thành phần dinh dưỡng
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Text(
                    'Bảng thành phần dinh dưỡng',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Hàng hiển thị % từng chất
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildNutrientInfo(
                          'Protein', proteinPercentage, Colors.blue),
                      _buildNutrientInfo('Carb', carbPercentage, Colors.green),
                      _buildNutrientInfo('Fats', fatsPercentage, Colors.orange),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Biểu đồ tròn
                  SizedBox(
                    height: 200,
                    child: PieChart(
                      PieChartData(
                        sections: [
                          PieChartSectionData(
                            value: proteinPercentage,
                            color: Colors.blue,
                            title:
                                'Protein\n${proteinPercentage.toStringAsFixed(1)}%',
                            radius: 50,
                            titleStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          PieChartSectionData(
                            value: carbPercentage,
                            color: Colors.green,
                            title:
                                'Carb\n${carbPercentage.toStringAsFixed(1)}%',
                            radius: 50,
                            titleStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          PieChartSectionData(
                            value: fatsPercentage,
                            color: Colors.orange,
                            title:
                                'Fats\n${fatsPercentage.toStringAsFixed(1)}%',
                            radius: 50,
                            titleStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Cảnh báo chất béo nếu vượt mức
                  if (showFatWarning)
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text(
                        'Cảnh báo: Lượng chất béo (${totalFats.toStringAsFixed(1)}g) vượt 20g!',
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),

                  const Spacer(),

                  // Nút quay lại trang chủ
                  ElevatedButton(
                    style: ButtonStyles.buttonTwo,
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomeScreen(userInfo: userInfo),
                        ),
                        (Route<dynamic> route) => false,
                      );
                    },
                    child: const Text('TRANG CHỦ',
                        style: AppTextStyles.textButtonTwo),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget hiển thị thông tin từng chất
  Widget _buildNutrientInfo(String name, double percentage, Color color) {
    return Column(
      children: [
        Container(
          width: 20,
          height: 20,
          color: color,
        ),
        const SizedBox(height: 5),
        Text(
          name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Text('${percentage.toStringAsFixed(1)}%'),
      ],
    );
  }
}

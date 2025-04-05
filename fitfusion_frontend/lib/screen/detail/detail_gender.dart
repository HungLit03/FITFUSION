import 'package:flutter/material.dart';
import 'detail_measure_height.dart';
import 'package:fitfusion_frontend/models/user_info_model.dart';
import 'package:fitfusion_frontend/theme/theme.dart';
import 'package:fitfusion_frontend/widgets/tabbar.dart';
import 'package:fitfusion_frontend/widgets/gender.dart';

class GenderSelectionScreen extends StatefulWidget {
  final UserInfoModel userInfo;

  const GenderSelectionScreen({super.key, required this.userInfo});

  @override
  _GenderSelectionScreenState createState() => _GenderSelectionScreenState();
}

class _GenderSelectionScreenState extends State<GenderSelectionScreen> {
  String? selectedGender;

  final List<Map<String, String>> genders = [
    {"gender": "Nam", "imagePath": "assets/male.png"},
    {"gender": "Nữ", "imagePath": "assets/female.png"},
  ];

  void selectGender(String gender) {
    setState(() {
      selectedGender = gender;
      print(
          "Giới tính đã chọn: $selectedGender"); // Debug để kiểm tra trong console
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: appGradient),
        child: Column(
          children: [
            SizedBox(height: screenHeight * 0.02),
            AppBarCustomHeader(fullname: widget.userInfo.fullname),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.05,
                  vertical: screenHeight * 0.02,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: boxGradient.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.buttonBg),
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: screenHeight * 0.03),
                      const Text("Giới tính của bạn là gì?",
                          style: AppTextStyles.little_title),
                      SizedBox(height: screenHeight * 0.03),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: genders.map((genderData) {
                          return Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.02),
                              child: GenderOptionWidget(
                                gender: genderData['gender']!,
                                imagePath: genderData['imagePath']!,
                                isSelected:
                                    selectedGender == genderData['gender'],
                                onTap: () =>
                                    selectGender(genderData['gender']!),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      SizedBox(height: screenHeight * 0.04),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.05),
                        child: const Text(
                          "Chúng tôi sử dụng giới tính của bạn để thiết kế kế hoạch ăn kiêng tốt nhất cho bạn.",
                          style: AppTextStyles.normal,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.05),
                      ElevatedButton(
                        style: ButtonStyles.buttonTwo,
                        onPressed: selectedGender != null
                            ? () {
                                widget.userInfo.gender = selectedGender;
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => HeightInputScreen(
                                        userInfo: widget.userInfo),
                                  ),
                                );
                              }
                            : null,
                        child: const Text("TIẾP TỤC",
                            style: AppTextStyles.textButtonTwo),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

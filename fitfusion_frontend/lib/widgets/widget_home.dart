import 'package:flutter/material.dart';
import '../models/user_info_model.dart';
import 'package:fitfusion_frontend/theme/theme.dart';

// Bảng màu theo ảnh body
final Map<String, Color> imageColorMap = {
  "assets/body_img/male_underweight.png": const Color(0xFF54CAF7),
  "assets/body_img/male_normal.png": const Color(0xFF9CB327),
  "assets/body_img/male_overweight.png": const Color(0xFFF48221),
  "assets/body_img/male_obese.png": const Color(0xFFE64638),
  "assets/body_img/male_extreme.png": const Color(0xFFBD3C8C),
  "assets/body_img/female_underweight.png": const Color(0xFF54CAF7),
  "assets/body_img/female_normal.png": const Color(0xFF9CB327),
  "assets/body_img/female_overweight.png": const Color(0xFFF7C818),
  "assets/body_img/female_obese.png": const Color(0xFFF48221),
  "assets/body_img/female_extreme.png": const Color(0xFFE64638),
};

// Widget hiển thị body
class UserImageWidget extends StatelessWidget {
  final UserInfoModel userInfo;
  final double screenWidth;
  final double screenHeight;

  const UserImageWidget(
      {super.key,
      required this.userInfo,
      required this.screenWidth,
      required this.screenHeight});

  @override
  Widget build(BuildContext context) {
    String imagePath = _getImagePath();
    Color bmiColor = imageColorMap[imagePath] ?? Colors.grey;

    return Stack(
      alignment: Alignment.center,
      children: [
        Image.asset(imagePath,
            width: screenWidth * 0.3, height: screenHeight * 0.5),
        Positioned(
          bottom: 10,
          child: Column(
            children: [
              Container(
                width: 150,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(10)),
                  color: bmiColor,
                ),
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  "BMI : ${userInfo.bmi.toStringAsFixed(1)}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              Container(
                width: 150,
                height: 50,
                decoration: const BoxDecoration(
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(10)),
                  color: Colors.white,
                ),
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  userInfo.bmiStatus,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: bmiColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _getImagePath() {
    Map<String, Map<String, String>> imagePaths = {
      "Nam": {
        "Gầy": "assets/body_img/male_underweight.png",
        "Bình thường": "assets/body_img/male_normal.png",
        "Thừa cân": "assets/body_img/male_overweight.png",
        "Béo phì": "assets/body_img/male_obese.png",
        "Nguy hiểm": "assets/body_img/male_extreme.png",
      },
      "Nữ": {
        "Gầy": "assets/body_img/female_underweight.png",
        "Bình thường": "assets/body_img/female_normal.png",
        "Thừa cân": "assets/body_img/female_overweight.png",
        "Béo phì": "assets/body_img/female_obese.png",
        "Nguy hiểm": "assets/body_img/female_extreme.png",
      }
    };

    return imagePaths[userInfo.gender]?[userInfo.bmiStatus] ??
        "assets/body_img/default.png";
  }
}

// Widget nút chức năng
class FeatureButton extends StatelessWidget {
  final String title;
  final String image;
  final List<Color> gradientColors;
  final bool isTextLeft;
  final VoidCallback onTap; // Hàm callback khi click

  const FeatureButton({
    super.key,
    required this.title,
    required this.image,
    required this.gradientColors,
    required this.isTextLeft,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.80,
          height: 100,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: gradientColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.black, width: 2),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: isTextLeft
                ? _buildLeftTextLayout() // chiều xuôi
                : _buildRightTextLayout(), // chiều ngược
          ),
        ),
      ),
    );
  }

  List<Widget> _buildLeftTextLayout() {
    return [
      Expanded(
        child: Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(title, style: AppTextStyles.little_title),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 25),
        child:
            Image.asset(image, height: 100, width: 100), // Giảm kích thước ảnh
      ),
    ];
  }

  List<Widget> _buildRightTextLayout() {
    return [
      Padding(
        padding: const EdgeInsets.only(left: 15),
        child:
            Image.asset(image, height: 100, width: 100), // Giảm kích thước ảnh
      ),
      Expanded(
        child: Padding(
          padding: const EdgeInsets.only(right: 15),
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(title, style: AppTextStyles.little_title),
          ),
        ),
      ),
    ];
  }
}

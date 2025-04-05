import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFFB3261E); // Màu chính (đỏ)
  static const Color primaryHalf = Color(0x7FB3261E); // Màu chính mờ (50%)
  static const Color secondary = Color(0xFFD78C88); // Màu phụ
  static const Color background = Color(0xFFFFFFFF); // Màu nền trắng
  static const Color textPrimary = Color(0xFFFFFFFF); // Màu chữ chính (trắng)
  static const Color textSecondary = Color(0xFFB3261E); // Màu chữ phụ (xám)
  static const Color buttonBg = Color(0x7FB3261E); // Nền button đỏ mờ
  static const Color buttonText = Color(0xFFFFFFFF); // Chữ trên button
  static const Color text = Color.fromARGB(255, 0, 0, 0); // Chữ trên button
  static const Color gray = Color(0xFFBDBDBD); // Màu gray cho ô tìm kiếm
}

class AppTextStyles {
  static const TextStyle title = TextStyle(
    fontSize: 40,
    fontWeight: FontWeight.w900,
    color: AppColors.textPrimary,
  );
  static const TextStyle subtitle = TextStyle(
    fontSize: 25,
    fontWeight: FontWeight.bold,
    fontStyle: FontStyle.italic, // Chữ nghiêng
    color: AppColors.textSecondary,
  );
  static const TextStyle little_title = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w900,
    color: AppColors.textPrimary,
  );
  static const TextStyle little_title_1 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w900,
    color: AppColors.text,
  );
  static const TextStyle textButtonOne = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.textSecondary,
  );
  static const TextStyle textButtonTwo = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );
  static const TextStyle forgotPassword = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: AppColors.textSecondary,
    decoration: TextDecoration.underline,
  );
  static const TextStyle text = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );
  static const TextStyle normal = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.normal,
    color: Color.fromARGB(255, 0, 0, 0),
  );
}

class ButtonStyles {
  static final ButtonStyle buttonOne = ElevatedButton.styleFrom(
    backgroundColor: const Color.fromARGB(255, 255, 255, 255),
    minimumSize: const Size(200, 50),
  );
  static final ButtonStyle buttonTwo = ElevatedButton.styleFrom(
    backgroundColor: AppColors.primary,
    minimumSize: const Size(200, 50),
  );
}

///background
const LinearGradient appGradient = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [AppColors.primary, AppColors.secondary, AppColors.background],
);

const LinearGradient boxGradient = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [Color(0xFF999999), AppColors.background],
);

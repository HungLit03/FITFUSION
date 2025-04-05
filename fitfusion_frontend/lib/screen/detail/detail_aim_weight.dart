import 'detail_aim_date.dart';
import 'package:flutter/material.dart';
import 'package:fitfusion_frontend/widgets/tabbar.dart';
import 'package:fitfusion_frontend/models/user_info_model.dart';
import 'package:fitfusion_frontend/theme/theme.dart';
import 'package:fitfusion_frontend/widgets/inputfield.dart';

class AimWeightScreen extends StatefulWidget {
  final UserInfoModel userInfo;

  const AimWeightScreen({super.key, required this.userInfo});

  @override
  _AimWeightScreenState createState() => _AimWeightScreenState();
}

class _AimWeightScreenState extends State<AimWeightScreen> {
  late TextEditingController _aimWeightController;
  bool isButtonEnabled = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _aimWeightController = TextEditingController(
      text: widget.userInfo.aimWeight?.toString() ??
          widget.userInfo.weight.toString(),
    );
    _aimWeightController.addListener(_updateAimWeight);
  }

  void _updateAimWeight() {
    setState(() {
      double? aimWeight = double.tryParse(_aimWeightController.text);
      double currentWeight = widget.userInfo.weight ?? 0.0;
      double height = widget.userInfo.height ?? 1.7;
      String goal = widget.userInfo.goal ?? "";
      errorMessage = null;

      if (aimWeight != null && aimWeight > 0) {
        if (goal == "Giảm cân" && aimWeight >= currentWeight) {
          errorMessage = "Cân nặng mục tiêu đang lớn hơn cân nặng hiện tại";
        } else if (goal == "Tăng cân") {
          double minGain = 2.0; // Mức tăng tối thiểu
          if (aimWeight <= currentWeight) {
            errorMessage = "Cân nặng mục tiêu đang nhỏ hơn cân nặng hiện tại";
          } else if (aimWeight < currentWeight + minGain) {
            errorMessage =
                "Bạn nên đặt cân nặng mục tiêu tăng ít nhất ${minGain}kg";
          }
        } else if (goal == "Cải thiện sức khỏe") {
          double bmiMin = 18.5;
          double bmiMax = 24.9;
          double weightMin = bmiMin * (height * height);
          double weightMax = bmiMax * (height * height);
          if (aimWeight < weightMin || aimWeight > weightMax) {
            errorMessage =
                "Cân nặng mục tiêu không nằm trong vùng BMI bình thường (${weightMin.toStringAsFixed(1)}kg - ${weightMax.toStringAsFixed(1)}kg)";
          }
        }

        // Cập nhật giá trị và tính toán lại BMI mục tiêu
        isButtonEnabled = errorMessage == null;
        widget.userInfo.aimWeight = aimWeight;
        widget.userInfo.calculateBMIAim();

        // Cập nhật phần trăm cân nặng giảm
        if (widget.userInfo.weight != null &&
            widget.userInfo.aimWeight != null) {
          widget.userInfo.weightLossPercentage =
              ((widget.userInfo.weight! - widget.userInfo.aimWeight!) /
                      widget.userInfo.weight!) *
                  100;
        } else {
          widget.userInfo.weightLossPercentage = 0.0;
        }
      } else {
        isButtonEnabled = false;
      }
    });
  }

  @override
  void dispose() {
    _aimWeightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: appGradient),
        child: Column(
          children: [
            SizedBox(height: screenHeight * 0.03),
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
                  padding: EdgeInsets.all(screenWidth * 0.05),
                  child: Column(
                    children: [
                      const Text(
                        "Cân nặng mục tiêu của bạn là bao nhiêu?",
                        style: AppTextStyles.little_title,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      InputField(
                          label: '',
                          controller: _aimWeightController,
                          width: 100,
                          height: 50,
                          isNumeric: true),
                      if (errorMessage != null) ...[
                        const SizedBox(height: 10),
                        Text(errorMessage!, style: AppTextStyles.textButtonOne),
                      ],
                      SizedBox(height: screenHeight * 0.03),
                      const Text(
                        "Chỉ số BMI mục tiêu của bạn là:",
                        style: AppTextStyles.little_title,
                      ),
                      Text(
                        widget.userInfo.bmiAim.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              offset: Offset(-1.5, -1.5),
                              color: Colors.red,
                            ),
                            Shadow(
                              offset: Offset(1.5, -1.5),
                              color: Colors.red,
                            ),
                            Shadow(
                              offset: Offset(-1.5, 1.5),
                              color: Colors.red,
                            ),
                            Shadow(
                              offset: Offset(1.5, 1.5),
                              color: Colors.red,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                                color: Colors.black26,
                                blurRadius: 5,
                                spreadRadius: 2),
                          ],
                        ),
                        padding: EdgeInsets.all(screenWidth * 0.05),
                        child: Column(
                          children: [
                            Text(
                              widget.userInfo.weightLossPercentage > 0
                                  ? "Giảm ${widget.userInfo.weightLossPercentage.toStringAsFixed(1)}% cân!"
                                  : "Bạn không cần giảm cân!",
                              style: AppTextStyles.title
                                  .copyWith(color: AppColors.buttonBg),
                              textAlign: TextAlign.center,
                            ),
                            if (widget.userInfo.weightLossPercentage > 0)
                              Text(
                                "Bạn sẽ giảm ${(widget.userInfo.weight! - widget.userInfo.aimWeight!).toStringAsFixed(1)}kg để đạt được cân nặng mục tiêu.",
                                style: AppTextStyles.little_title,
                                textAlign: TextAlign.center,
                              ),
                          ],
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.05),
                      ElevatedButton(
                        style: ButtonStyles.buttonTwo,
                        onPressed: isButtonEnabled
                            ? () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AimDateScreen(
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

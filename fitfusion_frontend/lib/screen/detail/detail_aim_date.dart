import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fitfusion_frontend/widgets/tabbar.dart';
import 'package:fitfusion_frontend/models/user_info_model.dart';
import 'package:fitfusion_frontend/theme/theme.dart';
import 'detail_health.dart';

class AimDateScreen extends StatefulWidget {
  final UserInfoModel userInfo;

  const AimDateScreen({super.key, required this.userInfo});

  @override
  _AimDateScreenState createState() => _AimDateScreenState();
}

class _AimDateScreenState extends State<AimDateScreen> {
  DateTime minDate = DateTime.now(); // lấy ngày hiện tại
  late DateTime selectedDate;
  bool isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    minDate = DateTime.now();
    selectedDate = minDate; //luôn cập nhật ngày gần nhất
    isButtonEnabled = true;
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
              child: SingleChildScrollView(
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
                          "Bạn muốn hoàn thành mục tiêu vào ngày bao nhiêu?",
                          style: AppTextStyles.little_title,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        _buildDatePicker(),
                        SizedBox(height: screenHeight * 0.05),
                        ElevatedButton(
                          style: ButtonStyles.buttonTwo,
                          onPressed: isButtonEnabled
                              ? () {
                                  widget.userInfo.aimDate = selectedDate;
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HealthScreen(
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
            ),
          ],
        ),
      ),
    );
  }

  //pick date, sử dụng package Cupertino để lấy set ngày
  Widget _buildDatePicker() {
    return Container(
      child: Column(
        children: [
          SizedBox(
            height: 300,
            child: CupertinoTheme(
              data: const CupertinoThemeData(
                textTheme: CupertinoTextThemeData(
                  dateTimePickerTextStyle: AppTextStyles.little_title,
                ),
              ),
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                initialDateTime: minDate,
                minimumDate: minDate,
                maximumDate: DateTime(DateTime.now().year + 5),
                onDateTimeChanged: (DateTime newDate) {
                  setState(() {
                    selectedDate = newDate;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

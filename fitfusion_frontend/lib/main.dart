import 'package:flutter/material.dart';
import 'package:fitfusion_frontend/screen/intro.dart';

void main() {
  runApp(const FitFusionApp());
}

class FitFusionApp extends StatelessWidget {
  const FitFusionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: IntroApp(), // Đặt màn hình khởi động đúng
    );
  }
}

import 'package:flutter/material.dart';
import '../theme/theme.dart'; // Import theme

class setProfile extends StatelessWidget {
  const setProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: appGradient,
      ),
    ));
  }
}

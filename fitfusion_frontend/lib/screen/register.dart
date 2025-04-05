import 'package:flutter/material.dart';
import '../models/user_info_model.dart';
import '../widgets/tabbar.dart';
import '../theme/theme.dart';
import '../widgets/inputfield.dart';
import 'detail/detail_gender.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController fullnameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    fullnameController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: appGradient,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const AppBarCustom(),
              const SizedBox(height: 20),
              Image.asset(
                'assets/logo.png',
                width: 200,
              ),
              const SizedBox(height: 10),
              InputField(label: "Họ và tên", controller: fullnameController),
              const SizedBox(height: 10),
              InputField(
                  label: "Tên đăng nhập", controller: usernameController),
              const SizedBox(height: 10),
              InputField(
                  label: "Mật khẩu",
                  controller: passwordController,
                  isPassword: true),
              const SizedBox(height: 10),
              InputField(
                  label: "Nhập lại mật khẩu",
                  controller: confirmPasswordController,
                  isPassword: true),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ButtonStyles.buttonTwo,
                onPressed: () {
                  if (passwordController.text ==
                      confirmPasswordController.text) {
                    UserInfoModel userInfo = UserInfoModel(
                      fullname: fullnameController.text,
                    );

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            GenderSelectionScreen(userInfo: userInfo),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Mật khẩu không khớp!")),
                    );
                  }
                },
                child:
                    const Text("ĐĂNG KÝ", style: AppTextStyles.textButtonTwo),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

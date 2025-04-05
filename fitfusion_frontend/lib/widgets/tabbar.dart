import 'package:fitfusion_frontend/screen/intro.dart';
import 'package:fitfusion_frontend/screen/profile.dart';
import 'package:flutter/material.dart';
import '../theme/theme.dart';

class AppBarCustom extends StatelessWidget {
  final VoidCallback? onBackPressed;

  const AppBarCustom({
    super.key,
    this.onBackPressed,
  });
  void _showMenu(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Stack(
          children: [
            Positioned(
              top: 70, // Điều chỉnh vị trí dọc
              right: 10, // Điều chỉnh vị trí ngang
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: 220, // Điều chỉnh kích thước
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        spreadRadius: 2,
                      )
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildMenuItem(
                        context,
                        Icons.person,
                        "Cơ bản",
                        "Thông tin cá nhân",
                        onTap: () {
                          Navigator.pop(context); // Đóng menu trước
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const setProfile()), // Chuyển đến màn hình IntroApp
                          );
                        },
                      ),
                      const Divider(),
                      _buildMenuItem(
                          context, Icons.help, "Trợ giúp", "Yêu cầu trợ giúp"),
                      const Divider(),
                      _buildMenuItem(
                          context, Icons.info, "Giới thiệu", "Về chúng tôi"),
                      const Divider(),
                      _buildMenuItem(
                        context,
                        Icons.account_circle,
                        "Tài Khoản",
                        "Đăng xuất",
                        onTap: () {
                          Navigator.pop(context); // Đóng menu trước
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const IntroApp()), // Chuyển đến IntroApp
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMenuItem(
      BuildContext context, IconData icon, String title, String subtitle,
      {VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: subtitle.isNotEmpty
          ? Text(subtitle, style: const TextStyle(fontSize: 12))
          : null,
      onTap: onTap ?? () {}, // Nếu có onTap thì dùng, không thì để trống
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.white, size: 50),
          onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
        ),
        const Text(
          "FITFUSION",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.menu, color: Colors.white, size: 50),
          onPressed: () => _showMenu(context),
        ),
      ],
    );
  }
}

class AppBarCustomHeader extends StatelessWidget {
  final String fullname;
  final VoidCallback? onBackPressed;

  const AppBarCustomHeader({
    super.key,
    required this.fullname,
    this.onBackPressed,
  });

  void _showMenu(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Stack(
          children: [
            Positioned(
              top: 70,
              right: 10,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: 220,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        spreadRadius: 2,
                      )
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildMenuItem(
                        context,
                        Icons.person,
                        "Cơ bản",
                        "Thông tin cá nhân",
                        onTap: () {
                          Navigator.pop(context); // Đóng menu trước
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const IntroApp()), // Chuyển đến màn hình IntroApp
                          );
                        },
                      ),
                      const Divider(),
                      _buildMenuItem(
                          context, Icons.help, "Trợ giúp", "Yêu cầu trợ giúp"),
                      const Divider(),
                      _buildMenuItem(
                        context,
                        Icons.info,
                        "Giới thiệu",
                        "Về chúng tôi",
                        onTap: () {
                          Navigator.pop(context); // Đóng menu trước
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const setProfile()), // Chuyển đến màn hình IntroApp
                          );
                        },
                      ),
                      const Divider(),
                      _buildMenuItem(
                        context,
                        Icons.account_circle,
                        "Tài Khoản",
                        "Đăng xuất",
                        onTap: () {
                          Navigator.pop(context); // Đóng menu trước
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const IntroApp()), // Chuyển đến màn hình IntroApp
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMenuItem(
      BuildContext context, IconData icon, String title, String subtitle,
      {VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: subtitle.isNotEmpty
          ? Text(subtitle, style: const TextStyle(fontSize: 12))
          : null,
      onTap: onTap ?? () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon:
                  const Icon(Icons.chevron_left, color: Colors.white, size: 50),
              onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
            ),
            const Text(
              "FITFUSION",
              style: AppTextStyles.title,
            ),
            IconButton(
              icon: const Icon(Icons.menu, color: Colors.white, size: 50),
              onPressed: () => _showMenu(context),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: "Fit",
                style: AppTextStyles.title.copyWith(
                  shadows: const [
                    Shadow(
                      offset: Offset(1.5, 1.5),
                      blurRadius: 0,
                      color: Color(0xFFB3261E),
                    ),
                  ],
                ),
              ),
              TextSpan(
                text: "AI",
                style: AppTextStyles.title.copyWith(
                  color: const Color(0xFFB3261E),
                  shadows: const [
                    Shadow(
                      offset: Offset(1.5, 1.5),
                      blurRadius: 0,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

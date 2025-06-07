import 'package:flutter/material.dart';
import 'package:flutter_app_template_with_login/app/widgets/custom_button.dart';
import 'package:get/get.dart';

import '../../config/app_colors.dart';
import '../controllers/auth_controller.dart';
import '../routes/app_routes.dart';
import '../widgets/language_selector.dart';

/// The HomePage is the main page of the application
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<void> test() async {
    return Get.toNamed(AppRoutes.test);
  }

  Future<void> location() async {
    return Get.toNamed(AppRoutes.location);
  }

  void _showLanguageDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: Text('Select Language'.tr),
        content: LanguageSelector(),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Close'.tr),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Row(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Image.asset(
                'assets/images/leaf.png',
                height: 32, // adjust size as needed
                width: 32,
              ),
            ),
            SizedBox(width: 10),
            Text(controller.userName.value),
          ],
        )),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'language':
                  _showLanguageDialog(context);
                  break;
                case 'logout':
                  controller.logout();
                  break;
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'language',
                child: Row(
                  children: [
                    Icon(Icons.language, size: 20, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Text('Language'.tr),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    const Icon(Icons.logout, size: 20, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Text('Logout'.tr),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              child: ListTile(
                title: Text('test'.tr),
                trailing: Icon(Icons.arrow_forward),
                onTap: test,
              ),
            ),
            Card(
              child: ListTile(
                title: Text('location'.tr),
                trailing: Icon(Icons.arrow_forward),
                onTap: location,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
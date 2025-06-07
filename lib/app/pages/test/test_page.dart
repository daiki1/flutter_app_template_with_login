import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/test_controller.dart';
import '../../widgets/custom_button.dart';

/// The TestPage is a demonstration page for testing various endpoints
class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPage();
}

class _TestPage extends State<TestPage> {
  final TestController testController = Get.put(TestController());

  void publicEndPoint() {
    testController.publicEndPoint();
  }

  void userEndPoint() {
    testController.userEndPoint();
  }

  void adminEndPoint() {
    testController.adminEndPoint();
  }

  void auditorEndPoint() {
    testController.auditorEndPoint();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('test'.tr)),
      body: Obx(() {
        return SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  if (testController.errorMessage.isNotEmpty)
                    Text(
                      testController.errorMessage.value,
                      style: const TextStyle(color: Colors.red),
                    ),
                  CustomButton(
                    label: 'public_endpoint'.tr,
                    onPressed: () async {
                      publicEndPoint();
                    },
                  ),
                  CustomButton(
                    label: 'user_endpoint'.tr,
                    onPressed: () async {
                      userEndPoint();
                    },
                  ),
                  CustomButton(
                    label: 'admin_endpoint'.tr,
                    onPressed: () async {
                      adminEndPoint();
                    },
                  ),
                  CustomButton(
                    label: 'audit_endpoint'.tr,
                    onPressed: () async {
                      auditorEndPoint();
                    },
                  ),

                ],
              ),
            ),
          ),
        );
      }),

    );
  }
}

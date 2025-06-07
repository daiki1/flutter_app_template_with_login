import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/validators.dart';
import '../../controllers/auth_controller.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_input.dart';

/// The ForgotPasswordPage allows users to request a password reset
class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPage();
}

class _ForgotPasswordPage extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();

  final AuthController authController = Get.find();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  void requestPasswordReset() {
    if (!_formKey.currentState!.validate()) return;
    authController.requestPasswordReset(emailController.text);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      authController.errorMessageForgotPassword.value = '';
    });
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(title: Text('recover_password'.tr)),
      body: Obx(() {
        return Padding(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                CustomInput(label: 'email'.tr, controller: emailController, maxLength: 100, validator: emailValidator,),
                SizedBox(height: 16),
                if (authController.errorMessageForgotPassword.isNotEmpty)
                  Text(
                    authController.errorMessageForgotPassword.value,
                    style: const TextStyle(color: Colors.red),
                  ),
                CustomButton(
                  label: 'audit_endpoint'.tr,
                  onPressed: () async {
                    requestPasswordReset();
                  },
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

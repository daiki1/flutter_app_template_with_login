import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/validators.dart';
import '../../controllers/auth_controller.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_input.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPage();
}

class _SignUpPage extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final repeatPasswordController = TextEditingController();
  final emailController = TextEditingController();

  final authController = Get.find<AuthController>();

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    repeatPasswordController.dispose();
    emailController.dispose();
    super.dispose();
  }

  void signUp() {
    if (!_formKey.currentState!.validate()) return;
    authController.signUp(
      usernameController.text,
      passwordController.text,
      emailController.text,
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      authController.errorMessageSignUp.value = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('sign_up'.tr)),
      body: Obx(() {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                CustomInput(
                  label: 'user'.tr,
                  controller: usernameController,
                  maxLength: 50,
                  validator: (value) =>
                      emptyValidator(value, fieldName: 'user'.tr),
                ),
                CustomInput(
                  label: 'password'.tr,
                  controller: passwordController,
                  maxLength: 50,
                  validator: passwordValidator,
                  obscure: true,
                  showEye: true,
                ),
                CustomInput(
                  label: 'repeat_password'.tr,
                  controller: repeatPasswordController,
                  maxLength: 50,
                  validator: repeatPasswordValidator(passwordController),
                  obscure: true,
                  showEye: true,
                ),
                CustomInput(
                  label: 'email'.tr,
                  maxLength: 100,
                  controller: emailController,
                  validator: emailValidator,
                ),

                const SizedBox(height: 20),
                if (authController.errorMessageSignUp.isNotEmpty)
                  Text(
                    authController.errorMessageSignUp.value,
                    style: const TextStyle(color: Colors.red),
                  ),
                CustomButton(
                  label: 'register'.tr,
                  onPressed: () async {
                    signUp();
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

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/validators.dart';
import '../../controllers/auth_controller.dart';
import '../../routes/app_routes.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_input.dart';
import '../../widgets/language_selector.dart';

/// The LoginPage allows users to log in to the application
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  final authController = Get.find<AuthController>();

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void login() {
    if (!_formKey.currentState!.validate()) return;
    authController.login(usernameController.text, passwordController.text);
  }

  void forgotPassword() {
    Get.toNamed(AppRoutes.forgotPassword);
  }

  void signUp() {
    Get.toNamed(AppRoutes.signUp);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      authController.errorMessageLogin.value = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(title: Text('login'.tr)),
      body: SafeArea(
        child: Obx(() {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(flex: 5, child: Container()),
                      Expanded(flex: 5, child: LanguageSelector()),
                    ],
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        CustomInput(
                          label: 'user_or_email'.tr,
                          controller: usernameController,
                          maxLength: 100,
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
                        const SizedBox(height: 20),
                        if (authController.errorMessageLogin.isNotEmpty)
                          Text(
                            authController.errorMessageLogin.value,
                            style: const TextStyle(color: Colors.red),
                          ),
                        CustomButton(
                          label: 'login'.tr,
                          onPressed: () async {
                            login();
                          },
                        ),
                      ],
                    ),
                  ),

                  TextButton(
                    onPressed: () {
                      forgotPassword();
                    },
                    child: Text('forgor_password'.tr),
                  ),
                  const SizedBox(height: 16),
                  //Text('dont_have_account'.tr),
                  CustomButton(
                    label: 'sign_up'.tr,
                    onPressed: () async {
                      signUp();
                    },
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

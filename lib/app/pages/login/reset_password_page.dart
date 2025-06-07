import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/validators.dart';
import '../../controllers/auth_controller.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_input.dart';

/// The ResetPasswordPage allows users to reset their password using a code
class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPage();
}

class _ResetPasswordPage extends State<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();

  final codeController = TextEditingController();
  final newPasswordController = TextEditingController();

  final AuthController authController = Get.find();

  @override
  void dispose() {
    codeController.dispose();
    newPasswordController.dispose();
    super.dispose();
  }

  void resetPassword(){
    if (!_formKey.currentState!.validate()) return;
    authController.resetPassword(
        codeController.text,
        newPasswordController.text
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      authController.errorMessageResetPassword.value = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    authController.errorMessageResetPassword.value = '';

    return Scaffold(
      appBar: AppBar(title: Text('reset_password'.tr)),
      body: Obx(() {
        return Padding(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Text('enter_code_reset_password'.tr),
                SizedBox(height: 10),
                _buildCodeField(codeController),
                SizedBox(height: 10),
                CustomInput(label: 'new_password'.tr, controller: newPasswordController, maxLength: 50, validator: passwordValidator, obscure: true, showEye: true,),
                SizedBox(height: 16),
                if (authController.errorMessageResetPassword.isNotEmpty)
                  Text(authController.errorMessageResetPassword.value, style: const TextStyle(color: Colors.red)),
                CustomButton(
                  label: 'reset_password'.tr,
                  onPressed: () async {
                    resetPassword();
                  },
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildCodeField(TextEditingController controller) {
    return TextFormField(
      controller: controller,
      maxLength: 5,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        counterText: "",
        hintText: "12345",
        border: OutlineInputBorder(),
        errorMaxLines: 3,
      ),
      validator: (value) => emptyValidator(value, fieldName: 'code'.tr),
    );
  }
}
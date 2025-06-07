import 'package:flutter/cupertino.dart';
import 'package:get/get_utils/get_utils.dart';

final passwordRegex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).{8,50}$');
final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

// You can also define other validators here if needed
bool isValidPassword(String password) {
  return passwordRegex.hasMatch(password);
}

String? passwordValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'required'.tr.replaceAll('{0}', 'password'.tr);
  } else if (!isValidPassword(value)) {
    return 'password_validation'.tr;
  }
  return null; // Valid
}

String? Function(String?) repeatPasswordValidator(TextEditingController originalPasswordController) {
  return (String? value) {
    if (value == null || value.isEmpty) {
      return 'please_repeat_password'.tr;
    }
    if (value != originalPasswordController.text) {
      return 'passwords_do_not_match'.tr;
    }
    return null;
  };
}

String? emptyValidator(String? value, {required String fieldName}) {
  if (value == null || value.trim().isEmpty) {
    return 'required'.tr.replaceAll('{0}', fieldName);
  }
  return null;
}

String? emailValidator(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'required'.tr.replaceAll('{0}', 'email'.tr);
  }

  if (!emailRegex.hasMatch(value.trim())) {
    return 'invalid_email'.tr;
  }

  return null; // Valid
}
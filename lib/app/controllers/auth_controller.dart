import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jwt_decode/jwt_decode.dart';
import '../../services/auth_service.dart';
import '../../utils/api_helper.dart';
import '../routes/app_routes.dart';

class AuthController extends GetxController {
final storage = GetStorage();

var errorMessageLogin = ''.obs;
var errorMessageForgotPassword = ''.obs;
var errorMessageResetPassword = ''.obs;
var errorMessageSignUp = ''.obs;
var isLoggedIn = false.obs;
var userName = ''.obs;
var userEmail = ''.obs;
var userId = 0.obs;
var userRoles = <String>[].obs;

@override
void onInit() {
  super.onInit();
  checkIfLoggedIn();
}

void checkIfLoggedIn() {
  final storedToken = storage.read('token');
  if (storedToken != null) {
    try {
      final payload = Jwt.parseJwt(storedToken);
      userName.value = payload['sub'];
      userEmail.value = payload['email'];
      userId.value = payload['userId'];
      userRoles.assignAll(List<String>.from(payload['roles']));
      isLoggedIn.value = true;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.offAllNamed('/home');
      });
    } catch (e) {
      //print('Invalid token: $e');
      logout();
    }
  }
}

Future<void> login(String username, String password) async {
  username = username.trim();
  password = password.trim();

  await ApiHelper.executeApiCall(
    errorMessage: errorMessageLogin,
    serviceCall: () => AuthService.login(username, password),
    onSuccess: (response) async {
      String token = response.data['token'];

      // Decode token to extract claims
      final payload = Jwt.parseJwt(token);
      userName.value = payload['sub'];
      userEmail.value = payload['email'];
      userId.value = payload['userId'];
      userRoles.assignAll(List<String>.from(payload['roles']));

      // Persist securely
      await storage.write('token', token);
      await storage.write('refreshToken', response.data['refreshToken']);
      await storage.write('userName', userName.value);
      await storage.write('email', userEmail.value);
      await storage.write('userId', userId.value);
      await storage.write('roles', userRoles);

      isLoggedIn.value = true;

      // Navigate to home
      Get.offAllNamed('/home');
    },
    onError: (response) async {
      errorMessageLogin.value = response.message;
    },
  );

}

Future<void> requestPasswordReset(String email) async {
  email = email.trim();

  await ApiHelper.executeApiCall(
    errorMessage: errorMessageForgotPassword,
    serviceCall: () => AuthService.requestPasswordReset(email),
    onSuccess: (_) async {
      Get.toNamed(AppRoutes.resetPassword);
    },
    onError: (response) async {
      errorMessageForgotPassword.value = response.message;
    },
  );
}

Future<void> resetPassword(String code, String newPassword) async {
  code = code.trim();
  newPassword = newPassword.trim();

  await ApiHelper.executeApiCall(
    errorMessage: errorMessageResetPassword,
    serviceCall: () => AuthService.resetPassword(code, newPassword),
    onSuccess: (response) async {
      Get.offAllNamed(AppRoutes.login);
      Get.snackbar('success'.tr, response.message);
    },
    onError: (response) async {
      errorMessageResetPassword.value = response.message;
    },
  );
}

Future<void> signUp(String username, String password, String email) async {
  username = username.trim();
  password = password.trim();
  email = email.trim();

  await ApiHelper.executeApiCall(
    errorMessage: errorMessageSignUp,
    serviceCall: () => AuthService.signUp(username, password, email),
    onSuccess: (response) async {
      Get.offAllNamed(AppRoutes.login);
      Get.snackbar('success'.tr, response.message);
    },
    onError: (response) async {
      errorMessageSignUp.value = response.message;
    },
  );
}

void logout({String? message}) async {
  userName.value = '';
  userEmail.value = '';
  userId.value = 0;
  userRoles.clear();
  isLoggedIn.value = false;

  final savedLanguage = storage.read('language'); // Save the current language
  await storage.erase();
  if (savedLanguage != null) {
    await storage.write('language', savedLanguage); // Restore the language
  }

  if (message != null) {
    Get.snackbar(
      'session_expired'.tr,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.redAccent,
      colorText: Colors.white,
    );
  }

  Get.offAllNamed('/login');
}

}
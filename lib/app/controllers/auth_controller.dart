import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jwt_decode/jwt_decode.dart';
import '../../services/auth_service.dart';
import '../../utils/api_helper.dart';
import '../../utils/storage_service.dart';
import '../routes/app_routes.dart';

// The AuthController handles user authentication, including login, logout,
class AuthController extends GetxController {
  // managing user sessions, and storing user data securely.

  // Observables to track authentication state and user data
  var errorMessageLogin = ''.obs;
  var errorMessageForgotPassword = ''.obs;
  var errorMessageResetPassword = ''.obs;
  var errorMessageSignUp = ''.obs;
  var isLoggedIn = false.obs;
  var userName = ''.obs;
  var userEmail = ''.obs;
  var userId = 0.obs;
  var userRoles = <String>[].obs;

  // Initialize the controller and check if the user is already logged in
  @override
  void onInit() {
    super.onInit();
    // Check if the user is logged in by reading the stored token
    checkIfLoggedIn();
  }

  /// Checks if the user is logged in by reading the stored token.
  /// If a valid token is found, it decodes the token to extract user information
  /// and updates the observable variables accordingly.
  /// If the token is invalid or not found, it calls logout().
  void checkIfLoggedIn() async {
    final storedToken = await StorageService.getToken();
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

  ///// Logs in the user with the provided username and password.
  Future<void> login(String username, String password) async {
    username = username.trim();
    password = password.trim();

    // Execute the API call to log in
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

        // Persist securely using StorageService
        await StorageService.saveTokens(
          token: token,
          refreshToken: response.data['refreshToken'],
        );
        await StorageService.saveUserData(
          userName: userName.value,
          email: userEmail.value,
          userId: userId.value,
          roles: userRoles,
        );

        isLoggedIn.value = true;

        // Navigate to home
        Get.offAllNamed('/home');
      },
      onError: (response) async {
        errorMessageLogin.value = response.message;
      },
    );
  }

  /// Requests a password reset for the user with the provided email.
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

  /// Resets the user's password using the provided code and new password.
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

  /// Signs up a new user with the provided username, password, and email.
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

  /// Logs out the user by clearing the stored session data and navigating to the login page.
  void logout({String? message}) async {
    userName.value = '';
    userEmail.value = '';
    userId.value = 0;
    userRoles.clear();
    isLoggedIn.value = false;

    // Clear all stored session data while preserving language setting
    await StorageService.clearAllStorage(
      localKeysToKeep: [StorageService.languageKey],
    );

    if (message != null) {
      // Show a snackbar with the session expired message
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

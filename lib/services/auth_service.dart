import 'dart:async';

import '../models/ApiResponse.dart';
import 'api_service.dart';

/// A service class for handling authentication-related API requests
/// This class provides methods for user login, password reset requests, and user registration.
class AuthService {

  /// Sends a login request to the API with the provided username and password.
  static Future<ApiResponse> login(String username, String password) async {
    return ApiService.postRequest('auth/login', {
      'username': username,
      'password': password,
    });
  }

  /// Sends a request to the API to request a password reset for the given email.
  static Future<ApiResponse> requestPasswordReset(String email) async {
    return ApiService.postRequest('auth/request-password-reset', {
      'email': email,
      'sendAsCode': true,
    });
  }

  /// Sends a request to reset the password using the provided code and new password.
  static Future<ApiResponse> resetPassword(String code, String newPassword) async {
    return ApiService.postRequest('auth/reset-password', {
      'token': code,
      'newPassword': newPassword,
    });
  }

  /// Sends a registration request to the API with the provided username, password, and email.
  static Future<ApiResponse> signUp(String username, String password, String email) async {
    return ApiService.postRequest('auth/register', {
      'username': username,
      'password': password,
      'email': email,
    });
  }


}
import 'dart:async';

import '../models/ApiResponse.dart';
import 'api_service.dart';

class AuthService {

  static Future<ApiResponse> login(String username, String password) async {
    return ApiService.postRequest('auth/login', {
      'username': username,
      'password': password,
    });
  }

  static Future<ApiResponse> requestPasswordReset(String email) async {
    return ApiService.postRequest('auth/request-password-reset', {
      'email': email,
      'sendAsCode': true,
    });
  }

  static Future<ApiResponse> resetPassword(String code, String newPassword) async {
    return ApiService.postRequest('auth/reset-password', {
      'token': code,
      'newPassword': newPassword,
    });
  }

  static Future<ApiResponse> signUp(String username, String password, String email) async {
    return ApiService.postRequest('auth/register', {
      'username': username,
      'password': password,
      'email': email,
    });
  }


}
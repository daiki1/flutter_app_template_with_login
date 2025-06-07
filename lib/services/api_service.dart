import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../app/controllers/auth_controller.dart';
import '../config/app_config.dart';
import '../models/ApiResponse.dart';

class ApiService {
  static Future<ApiResponse> postRequest(String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse('${AppConfig.apiBaseUrl}$endpoint');
    final currentLocale = Get.locale;
    final languageCode = currentLocale?.languageCode; // e.g., 'en'

    final storage = GetStorage();
    String? accessToken = storage.read('token');
    String? refreshToken = storage.read('refreshToken');

    // Helper to refresh token
    Future<bool> tryRefreshToken() async {
      if (refreshToken == null) return false;

      final refreshResponse = await ApiService.refreshToken(refreshToken);
      if (refreshResponse.statusCode == 200) {
        final newAccessToken = refreshResponse.data['token'];
        final newRefreshToken = refreshResponse.data['refreshToken'];

        await storage.write('token', newAccessToken);
        await storage.write('refreshToken', newRefreshToken);
        accessToken = newAccessToken;
        return true;
      } else {
        return false;
      }
    }

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept-Language': languageCode??'en',
          if (!endpoint.startsWith('auth/') && accessToken != null) 'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(body),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 401 && refreshToken != null && !endpoint.startsWith('auth/')) {
        // Try refreshing token and retry original request
        final refreshed = await tryRefreshToken();
        if (refreshed) {
          // Retry the request with new token
          final retryResponse = await http.post(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Accept-Language': languageCode??'en',
              'Authorization': 'Bearer $accessToken',
            },
            body: jsonEncode(body),
          ).timeout(const Duration(seconds: 10));

          return _processResponse(retryResponse);
        } else {
          final authController = Get.find<AuthController>();
          authController.logout(message: 'session_expired_message'.tr);

          return ApiResponse(statusCode: 401, message: 'session_expired'.tr);
        }
      }
      return _processResponse(response);
    } on TimeoutException {
      return ApiResponse(
        statusCode: 504,
        message: 'server_timeout'.tr,
      );
    } on SocketException {
      return ApiResponse(
        statusCode: 503,
        message: 'socket_exception'.tr,
      );
    } catch (e) {
      return ApiResponse(
        statusCode: 500,
        message: 'unexpected_error'.tr+e.toString(),
      );
    }
  }

  static Future<ApiResponse> getRequest(String endpoint, [Map<String, dynamic>? queryParams]) async {
    final uri = Uri.parse('${AppConfig.apiBaseUrl}$endpoint').replace(queryParameters: queryParams);
    final currentLocale = Get.locale;
    final languageCode = currentLocale?.languageCode ?? 'en';

    final storage = GetStorage();
    String? accessToken = storage.read('token');
    String? refreshToken = storage.read('refreshToken');

    // Helper to refresh token
    Future<bool> tryRefreshToken() async {
      if (refreshToken == null) return false;

      final refreshResponse = await ApiService.refreshToken(refreshToken);
      if (refreshResponse.statusCode == 200) {
        final newAccessToken = refreshResponse.data['token'];
        final newRefreshToken = refreshResponse.data['refreshToken'];

        await storage.write('token', newAccessToken);
        await storage.write('refreshToken', newRefreshToken);
        accessToken = newAccessToken;
        return true;
      } else {
        return false;
      }
    }

    try {
      final response = await http.get(
        uri,
        headers: {
          'Accept-Language': languageCode,
          if (!endpoint.startsWith('auth/') && accessToken != null)
            'Authorization': 'Bearer $accessToken',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 401 && refreshToken != null && !endpoint.startsWith('auth/')) {
        // Try refreshing token and retry original request
        final refreshed = await tryRefreshToken();
        if (refreshed) {
          final retryResponse = await http.get(
            uri,
            headers: {
              'Accept-Language': languageCode,
              'Authorization': 'Bearer $accessToken',
            },
          ).timeout(const Duration(seconds: 10));

          return _processResponse(retryResponse);
        } else {
          final authController = Get.find<AuthController>();
          authController.logout(message: 'session_expired_message'.tr);

          return ApiResponse(statusCode: 401, message: 'session_expired'.tr);
        }
      }

      return _processResponse(response);
    } on TimeoutException {
      return ApiResponse(
        statusCode: 504,
        message: 'server_timeout'.tr,
      );
    } on SocketException {
      return ApiResponse(
        statusCode: 503,
        message: 'socket_exception'.tr,
      );
    } catch (e) {
      return ApiResponse(
        statusCode: 500,
        message: 'unexpected_error'.tr + e.toString(),
      );
    }
  }

  static ApiResponse _processResponse(http.Response response) {
    try {
      final responseBody = jsonDecode(response.body);
      return ApiResponse(
        statusCode: response.statusCode,
        message: responseBody['message'] ?? 'success'.tr,
        data: responseBody,
      );
    } catch (e) {
      return ApiResponse(
        statusCode: response.statusCode,
        message: 'success'.tr,
        data: response.body,
      );
    }
  }

  static Future<ApiResponse> refreshToken(String refreshToken) async {
    final url = Uri.parse('${AppConfig.apiBaseUrl}auth/refresh');
    final currentLocale = Get.locale;
    final languageCode = currentLocale?.languageCode ?? 'en';

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept-Language': languageCode,
        },
        body: jsonEncode({'refreshToken': refreshToken}),
      ).timeout(const Duration(seconds: 10));

      final responseBody = jsonDecode(response.body);
      return ApiResponse(
        statusCode: response.statusCode,
        message: responseBody['message'] ?? 'Success',
        data: responseBody,
      );
    } catch (e) {
      return ApiResponse(
        statusCode: 500,
        message: 'unexpected_error'.tr + e.toString(),
      );
    }
  }
}
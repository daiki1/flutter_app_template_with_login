import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../app/controllers/auth_controller.dart';
import '../config/app_config.dart';
import '../models/ApiResponse.dart';
import '../utils/storage_service.dart';

/// A service class for making API requests with token management and error handling
/// This class provides methods for sending POST and GET requests, handling token refresh, and processing responses.
class ApiService {
  /// Sends a POST request to the specified endpoint with the provided body.
  /// Handles token management, including refreshing tokens if necessary.
  /// Returns an ApiResponse object containing the status code, message, and data.
  /// Handles common errors such as timeouts and socket exceptions.
  /// @param endpoint The API endpoint to send the request to.
  /// @param body The body of the POST request as a Map.
  /// @return A Future<ApiResponse> containing the result of the API call.
  static Future<ApiResponse> postRequest(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    final url = Uri.parse('${AppConfig.apiBaseUrl}$endpoint');
    final currentLocale = Get.locale;
    final languageCode = currentLocale?.languageCode; // e.g., 'en'

    String? accessToken = await StorageService.getToken();
    String? refreshToken = await StorageService.getRefreshToken();

    // Helper to refresh token
    Future<bool> tryRefreshToken() async {
      if (refreshToken == null) return false;

      final refreshResponse = await ApiService.refreshToken(refreshToken);
      if (refreshResponse.statusCode == 200) {
        final newAccessToken = refreshResponse.data['token'];
        final newRefreshToken = refreshResponse.data['refreshToken'];

        await StorageService.saveTokens(
          token: newAccessToken,
          refreshToken: newRefreshToken,
        );
        accessToken = newAccessToken;
        return true;
      } else {
        return false;
      }
    }

    try {
      final response = await http
          .post(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Accept-Language': languageCode ?? 'en',
              if (!endpoint.startsWith('auth/') && accessToken != null)
                'Authorization': 'Bearer $accessToken',
            },
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 401 &&
          refreshToken != null &&
          !endpoint.startsWith('auth/')) {
        // Try refreshing token and retry original request
        final refreshed = await tryRefreshToken();
        if (refreshed) {
          // Retry the request with new token
          final retryResponse = await http
              .post(
                url,
                headers: {
                  'Content-Type': 'application/json',
                  'Accept-Language': languageCode ?? 'en',
                  'Authorization': 'Bearer $accessToken',
                },
                body: jsonEncode(body),
              )
              .timeout(const Duration(seconds: 10));

          return _processResponse(retryResponse);
        } else {
          final authController = Get.find<AuthController>();
          authController.logout(message: 'session_expired_message'.tr);

          return ApiResponse(statusCode: 401, message: 'session_expired'.tr);
        }
      }
      return _processResponse(response);
    } on TimeoutException {
      return ApiResponse(statusCode: 504, message: 'server_timeout'.tr);
    } on SocketException {
      return ApiResponse(statusCode: 503, message: 'socket_exception'.tr);
    } catch (e) {
      return ApiResponse(
        statusCode: 500,
        message: 'unexpected_error'.tr + e.toString(),
      );
    }
  }

  /// Sends a GET request to the specified endpoint with optional query parameters.
  /// Handles token management, including refreshing tokens if necessary.
  /// Returns an ApiResponse object containing the status code, message, and data.
  /// Handles common errors such as timeouts and socket exceptions.
  /// @param endpoint The API endpoint to send the request to.
  /// @param queryParams Optional query parameters to include in the request.
  /// @return A Future<ApiResponse> containing the result of the API call.
  static Future<ApiResponse> getRequest(
    String endpoint, [
    Map<String, dynamic>? queryParams,
  ]) async {
    final uri = Uri.parse(
      '${AppConfig.apiBaseUrl}$endpoint',
    ).replace(queryParameters: queryParams);
    final currentLocale = Get.locale;
    final languageCode = currentLocale?.languageCode ?? 'en';

    String? accessToken = await StorageService.getToken();
    String? refreshToken = await StorageService.getRefreshToken();

    // Helper to refresh token
    Future<bool> tryRefreshToken() async {
      if (refreshToken == null) return false;

      final refreshResponse = await ApiService.refreshToken(refreshToken);
      if (refreshResponse.statusCode == 200) {
        final newAccessToken = refreshResponse.data['token'];
        final newRefreshToken = refreshResponse.data['refreshToken'];

        await StorageService.saveTokens(
          token: newAccessToken,
          refreshToken: newRefreshToken,
        );
        accessToken = newAccessToken;
        return true;
      } else {
        return false;
      }
    }

    try {
      final response = await http
          .get(
            uri,
            headers: {
              'Accept-Language': languageCode,
              if (!endpoint.startsWith('auth/') && accessToken != null)
                'Authorization': 'Bearer $accessToken',
            },
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 401 &&
          refreshToken != null &&
          !endpoint.startsWith('auth/')) {
        // Try refreshing token and retry original request
        final refreshed = await tryRefreshToken();
        if (refreshed) {
          final retryResponse = await http
              .get(
                uri,
                headers: {
                  'Accept-Language': languageCode,
                  'Authorization': 'Bearer $accessToken',
                },
              )
              .timeout(const Duration(seconds: 10));

          return _processResponse(retryResponse);
        } else {
          final authController = Get.find<AuthController>();
          authController.logout(message: 'session_expired_message'.tr);

          return ApiResponse(statusCode: 401, message: 'session_expired'.tr);
        }
      }

      return _processResponse(response);
    } on TimeoutException {
      return ApiResponse(statusCode: 504, message: 'server_timeout'.tr);
    } on SocketException {
      return ApiResponse(statusCode: 503, message: 'socket_exception'.tr);
    } catch (e) {
      return ApiResponse(
        statusCode: 500,
        message: 'unexpected_error'.tr + e.toString(),
      );
    }
  }

  /// Processes the HTTP response and returns an ApiResponse object.
  /// Handles JSON decoding and extracts the message and data from the response.
  /// @param response The HTTP response to process.
  /// @return An ApiResponse object containing the status code, message, and data.
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

  /// Refreshes the access token using the provided refresh token.
  /// Handles the API request and returns an ApiResponse object.
  /// @param refreshToken The refresh token to use for refreshing the access token.
  /// @return A Future<ApiResponse> containing the result of the token refresh operation.
  static Future<ApiResponse> refreshToken(String refreshToken) async {
    final url = Uri.parse('${AppConfig.apiBaseUrl}auth/refresh');
    final currentLocale = Get.locale;
    final languageCode = currentLocale?.languageCode ?? 'en';

    try {
      final response = await http
          .post(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Accept-Language': languageCode,
            },
            body: jsonEncode({'refreshToken': refreshToken}),
          )
          .timeout(const Duration(seconds: 10));

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

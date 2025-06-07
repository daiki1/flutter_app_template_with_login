/// This file defines the ApiResponse class used for handling API responses in a Flutter application.
class ApiResponse {
  final int statusCode;
  final String message;
  final dynamic data;

  ApiResponse({
    required this.statusCode,
    required this.message,
    this.data,
  });

  bool get isSuccess => statusCode >= 200 && statusCode < 300;
}
import '../models/ApiResponse.dart';
import 'api_service.dart';

class TestService {
  static Future<ApiResponse> publicEndPoint() async {
    return await ApiService.getRequest('test/all');
  }

  static Future<ApiResponse> userEndPoint() async {
    return await ApiService.getRequest('test/user');
  }

  static Future<ApiResponse> auditorEndPoint() async {
    return await ApiService.getRequest('test/auditor');
  }

  static Future<ApiResponse> adminEndPoint() async {
    return await ApiService.getRequest('test/admin');
  }
}
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../app/widgets/custom_popup.dart';
import '../models/ApiResponse.dart';
import '../services/loading_service.dart';

/// ResponseHandler is a type alias for a function that takes an ApiResponse and returns a Future<void>.
typedef ResponseHandler = Future<void> Function(ApiResponse response);

/// Get the LoadingService instance from GetX dependency injection
final loader = Get.find<LoadingService>();

/// ApiHelper is a utility class that provides methods for executing API calls with error handling and loading state management.
class ApiHelper {

  /// Executes an API call with error handling and loading state management.
  /// This method takes an error message observable, a service call function, and success and error handlers.
  /// It shows a loading indicator while the API call is in progress, updates the error message if the call fails,
  /// and calls the appropriate handler based on the success or failure of the API call.
  /// @param errorMessage An observable string to hold any error messages.
  /// @param serviceCall A function that returns a Future<ApiResponse> representing the API call.
  /// @param onSuccess A function to handle the response if the API call is successful.
  /// @param onError An optional function to handle the response if the API call fails.
  /// @return A Future<void> that completes when the API call is finished.
  static Future<void> executeApiCall({
    required RxString errorMessage,
    required Future<ApiResponse> Function() serviceCall,
    required ResponseHandler onSuccess,
    ResponseHandler? onError,
  }) async {
    loader.show();

    errorMessage.value = '';

    try {
      final response = await serviceCall();
      if (response.isSuccess) {
        await onSuccess(response);
      } else {
        errorMessage.value = response.message;
        if (onError != null) {
          await onError(response);
        } else {
          CustomPopup.show(title: 'error'.tr, message: response.message);
        }
      }
    } catch (e) {
      errorMessage.value = 'Unexpected error: $e';
      CustomPopup.show(title: 'error'.tr, message: errorMessage.value);
    } finally {
      loader.hide();
    }
  }


}
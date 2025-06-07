import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../app/widgets/custom_popup.dart';
import '../models/ApiResponse.dart';
import '../services/loading_service.dart';

typedef ResponseHandler = Future<void> Function(ApiResponse response);

final loader = Get.find<LoadingService>();

class ApiHelper {

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
import 'package:flutter_app_template_with_login/services/test_service.dart';
import 'package:get/get.dart';

import '../../utils/api_helper.dart';
import '../widgets/custom_popup.dart';

class TestController extends GetxController {
  var errorMessage = ''.obs;

  void publicEndPoint() async {
    await ApiHelper.executeApiCall(
      errorMessage: errorMessage,
      serviceCall: () => TestService.publicEndPoint(),
      onSuccess: (response) async {
        CustomPopup.show(title: 'success'.tr, message: response.data);
      },
      onError: (response) async {
        CustomPopup.show(title: 'error'.tr, message: response.message);
      },
    );
  }

  void userEndPoint() async {
    await ApiHelper.executeApiCall(
      errorMessage: errorMessage,
      serviceCall: () => TestService.userEndPoint(),
      onSuccess: (response) async {
        CustomPopup.show(title: 'success'.tr, message: response.data);
      },
      onError: (response) async {
        CustomPopup.show(title: 'error'.tr, message: response.message);
      },
    );
  }

  void auditorEndPoint() async {
    await ApiHelper.executeApiCall(
      errorMessage: errorMessage,
      serviceCall: () => TestService.auditorEndPoint(),
      onSuccess: (response) async {
        CustomPopup.show(title: 'success'.tr, message: response.data);
      },
      onError: (response) async {
        CustomPopup.show(title: 'error'.tr, message: response.message);
      },
    );
  }

  void adminEndPoint() async {
    await ApiHelper.executeApiCall(
      errorMessage: errorMessage,
      serviceCall: () => TestService.adminEndPoint(),
      onSuccess: (response) async {
        CustomPopup.show(title: 'success'.tr, message: response.data);
      },
      onError: (response) async {
        CustomPopup.show(title: 'error'.tr, message: response.message);
      },
    );
  }

}
import 'package:get/get.dart';

/// LoadingService is a GetX service that manages the loading state of the application.
class LoadingService extends GetxService {
  final isLoading = false.obs;

  void show() => isLoading.value = true;
  void hide() => isLoading.value = false;
}
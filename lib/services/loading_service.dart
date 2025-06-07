import 'package:get/get.dart';

class LoadingService extends GetxService {
  final isLoading = false.obs;

  void show() => isLoading.value = true;
  void hide() => isLoading.value = false;
}
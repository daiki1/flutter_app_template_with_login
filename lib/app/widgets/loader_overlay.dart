import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../services/loading_service.dart';

class LoaderOverlay extends StatelessWidget {
  const LoaderOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final loadingService = Get.find<LoadingService>();
    final loaderSize = Get.width * 0.4;
    final imageSize = Get.width * 0.3;

    return Obx(() {
      return loadingService.isLoading.value
          ? Stack(
        children: [
          ModalBarrier(dismissible: false, color: Colors.black54),
          Center(
            child: SizedBox(
              width: loaderSize,
              height: loaderSize,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: loaderSize,
                    height: loaderSize,
                    child: CircularProgressIndicator(
                      strokeWidth: 6,
                      color: Colors.amber,
                    ),
                  ),
                  Image.asset('assets/images/leaf.png', width: imageSize, height: imageSize),
                ],
              ),
            ),
          ),
        ],
      )
          : const SizedBox.shrink();
    });
  }
}
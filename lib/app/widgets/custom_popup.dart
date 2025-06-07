import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../config/app_colors.dart';

class CustomPopup {
  static void show({
    required String title,
    required String message,
    String confirmText = 'OK',
    VoidCallback? onConfirm,
    bool barrierDismissible = true,
  }) {
    if (Get.isDialogOpen != true) {
      Get.dialog(
        AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
          contentPadding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
          actionsPadding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          backgroundColor: AppColors.white,
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.text,
            ),
          ),
          content: Text(
            message,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.text,
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Get.back(); // Close the dialog
                onConfirm?.call();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                confirmText.tr,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        barrierDismissible: barrierDismissible,
      );
    }
  }
}
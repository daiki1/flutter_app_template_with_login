import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

/// LanguageController is responsible for managing the application's
/// language settings.
/// It allows users to switch between different languages
class LanguageController extends GetxController {
  final _storage = GetStorage();
  /// A map of supported languages with their locale keys and display names.
  final languages = {
    'en_US': 'English',
    'es_ES': 'Español',
  };

  var currentLocaleKey = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize the current locale based on the saved language or device locale
    final savedLocale = _storage.read('language') ?? Get.deviceLocale?.toString() ?? 'en_US';
    currentLocaleKey.value = languages.containsKey(savedLocale) ? savedLocale : 'en_US';
    WidgetsBinding.instance.addPostFrameCallback((_) {
      updateLocale(currentLocaleKey.value);
    });
  }

  /// Updates the application's locale to the specified language.
  void updateLocale(String localeKey) {
    final parts = localeKey.split('_');
    final locale = Locale(parts[0], parts[1]);
    Get.updateLocale(locale);
    _storage.write('language', localeKey);
    currentLocaleKey.value = localeKey;
  }
}
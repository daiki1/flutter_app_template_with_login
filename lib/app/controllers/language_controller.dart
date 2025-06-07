import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LanguageController extends GetxController {
  final _storage = GetStorage();
  final languages = {
    'en_US': 'English',
    'es_ES': 'Español',
  };

  var currentLocaleKey = ''.obs;

  @override
  void onInit() {
    super.onInit();
    final savedLocale = _storage.read('language') ?? Get.deviceLocale?.toString() ?? 'en_US';
    currentLocaleKey.value = languages.containsKey(savedLocale) ? savedLocale : 'en_US';
    WidgetsBinding.instance.addPostFrameCallback((_) {
      updateLocale(currentLocaleKey.value);
    });
  }

  void updateLocale(String localeKey) {
    final parts = localeKey.split('_');
    final locale = Locale(parts[0], parts[1]);
    Get.updateLocale(locale);
    _storage.write('language', localeKey);
    currentLocaleKey.value = localeKey;
  }
}
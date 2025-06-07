import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_template_with_login/services/loading_service.dart';
import 'package:flutter_app_template_with_login/translations/translations.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'app/routes/app_routes.dart';
import 'app/bindings/initial_binding.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'config/app_colors.dart';

var startLocale = Get.deviceLocale;

/// The main entry point of the Flutter application.
void main() async {
  // Ensure that the Flutter engine is initialized before using GetStorage
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize GetStorage for persistent storage
  await GetStorage.init();

  // Load the saved language from GetStorage or use the device locale
  final box = GetStorage();
  final savedLang = box.read('language');
  startLocale = savedLang != null
      ? Locale(savedLang.split('_')[0], savedLang.split('_')[1])
      : Get.deviceLocale ?? const Locale('en', 'US');

  // Set the initial locale for the application
  Get.put(LoadingService());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    // Set the initial locale for the application
    // This is done here to ensure that the locale is set before the app starts
    return GetMaterialApp(
      theme: ThemeData(
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.background,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.border),
          ),
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: AppColors.text),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white, // icon + text color
          elevation: 0,
          titleTextStyle: const TextStyle(
            color: AppColors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: const IconThemeData(color: AppColors.white),
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: AppColors.primary,
            statusBarIconBrightness: Brightness.light,
          ),
        ),
      ),
      translations: AppTranslations(),
      locale: startLocale,
      fallbackLocale: const Locale('en', 'US'),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('es', 'ES'),
      ],
      debugShowCheckedModeBanner: false,
      title: 'App',
      initialBinding: InitialBinding(),
      initialRoute: AppRoutes.login,
      getPages: AppRoutes.pages,
    );
  }
}

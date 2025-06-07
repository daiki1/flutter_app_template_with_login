
import 'package:flutter_app_template_with_login/app/pages/test/location_page.dart';
import 'package:flutter_app_template_with_login/app/pages/test/test_page.dart';
import 'package:get/get.dart';
import '../pages/login/forgot_password_page.dart';
import '../pages/home_page.dart';
import '../pages/login/login_page.dart';
import '../pages/login/reset_password_page.dart';
import '../pages/login/sign_up_page.dart';
import '../widgets/main_wrapper.dart';

class AppRoutes {
  static const login = '/login';
  static const forgotPassword  = '/forgot-password';
  static const resetPassword   = '/reset-password';
  static const signUp = '/sign-up';
  static const home = '/home';

  static const location = '/location';
  static const test = '/test';

  static final pages = [
    GetPage(name: login, page: () => MainWrapper(child: LoginPage())),
    GetPage(name: forgotPassword, page: () => MainWrapper(child: ForgotPasswordPage())),
    GetPage(name: resetPassword, page: () => MainWrapper(child: ResetPasswordPage())),
    GetPage(name: signUp, page: () => MainWrapper(child: SignUpPage())),
    GetPage(name: home, page: () => MainWrapper(child: HomePage())),

    GetPage(name: location, page: () => MainWrapper(child: LocationPage())),
    GetPage(name: test, page: () => MainWrapper(child: TestPage())),
  ];
}
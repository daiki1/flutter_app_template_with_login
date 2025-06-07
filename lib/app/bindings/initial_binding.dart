import 'package:get/get.dart';
import '../controllers/auth_controller.dart';

/// InitialBinding is responsible for initializing dependencies
/// when the application starts.
/// It uses GetX's dependency injection to put the AuthController
/// into the dependency management system.
class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthController());
  }


}
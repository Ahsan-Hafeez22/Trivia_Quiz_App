import "package:get/get.dart";
import "package:trivia_quiz_app/view_model/controller/auth_controllers/google_controller.dart";
import "package:trivia_quiz_app/view_model/controller/auth_controllers/login_controller.dart";

class LoginBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(() => LoginController());
    Get.lazyPut<GoogleController>(() => GoogleController());
  }
}

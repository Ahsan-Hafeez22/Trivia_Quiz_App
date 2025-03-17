import 'package:get/get.dart';
import 'package:trivia_quiz_app/view_model/controller/auth_controllers/forgot_password_controller.dart';

class ForgotPasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ForgotPasswordController>(() => ForgotPasswordController());
  }
}

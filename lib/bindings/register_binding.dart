import 'package:get/get.dart';
import 'package:trivia_quiz_app/view_model/controller/auth_controllers/signup_controller.dart';

class RegisterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SignupController>(
      () => Get.put(SignupController()),
    );
  }
}

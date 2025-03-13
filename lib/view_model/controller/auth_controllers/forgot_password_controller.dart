import 'package:get/get.dart';
import 'package:trivia_quiz_app/res/routes/routes_name.dart';
import 'package:trivia_quiz_app/view_model/service/auth_service.dart';

class ForgotPasswordController extends GetxController {
  RxString error = "".obs;
  RxBool isLoading = false.obs;
  final _auth = AuthService();

  void setRxError(String message) => error.value = message;
  void setIsLoading(bool isLoading) => this.isLoading.value = isLoading;

  void forgotPassword(String email) async {
    try {
      setIsLoading(true);
      await _auth.forgotPassword(email).then(
        (value) {
          Get.snackbar(
              "Success", "Email sent to reset password, Check your email");
          Get.toNamed(RoutesName.loginView);
        },
      );
    } catch (e) {
      setIsLoading(false);
      setRxError(e.toString());
    } finally {
      setIsLoading(false);
    }
  }
}

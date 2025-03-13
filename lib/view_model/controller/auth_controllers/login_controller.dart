import 'package:get/get.dart';
import 'package:trivia_quiz_app/res/routes/routes_name.dart';
import 'package:trivia_quiz_app/utils/utils.dart';
import 'package:trivia_quiz_app/view_model/service/auth_service.dart';
import 'package:trivia_quiz_app/view_model/service/session_controller.dart';

class LoginController extends GetxController {
  RxBool isLoading = false.obs;
  RxString error = ''.obs;
  final auth = AuthService();

  void setRxError(String message) => error.value = message;
  void setRxIsLoading(bool loading) => isLoading.value = loading;
  void login(String email, String password) async {
    try {
      setRxIsLoading(true);
      final user = await auth.loginUserWithEmailAndPassword(email, password);
      if (user != null) {
        SessionController().uid = user.uid.toString();
        Utils.snackbarMessage('Login', 'User login successfully');
        Get.offAllNamed(RoutesName.homeView);
        setRxIsLoading(false);
      }
    } catch (e) {
      setRxIsLoading(false);
      setRxError(e.toString());
    } finally {
      setRxIsLoading(false);
    }
  }
}

import 'package:get/get.dart';
import 'package:trivia_quiz_app/res/routes/routes_name.dart';
import 'package:trivia_quiz_app/utils/utils.dart';
import 'package:trivia_quiz_app/view_model/service/auth_service.dart';
import 'package:trivia_quiz_app/view_model/service/session_controller.dart';

class SignupController extends GetxController {
  final _auth = AuthService();

  RxBool isLoading = false.obs;
  RxString rxError = "".obs;

  void setIsLoading(bool value) => isLoading.value = value;
  void setRxError(String value) => rxError.value = value;
  void signup(String username, String email, String password) async {
    try {
      setIsLoading(true);
      final user =
          await _auth.createUserWithEmailAndPassword(username, email, password);
      if (user != null) {
        SessionController().uid = user.uid.toString();
        Utils.snackbarMessage('Created', 'Account created successfully');
        Get.offAllNamed(RoutesName.homeView);
        setIsLoading(false);
      }
    } catch (e) {
      setIsLoading(false);
      setRxError(e.toString());
    } finally {
      setIsLoading(false);
    }
  }
}

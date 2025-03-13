import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:trivia_quiz_app/res/routes/routes_name.dart';
import 'package:trivia_quiz_app/utils/utils.dart';
import 'package:trivia_quiz_app/view_model/service/auth_service.dart';
import 'package:trivia_quiz_app/view_model/service/session_controller.dart';

class GoogleController extends GetxController {
  final _authService = AuthService();
  RxBool isLoading = false.obs;
  RxString error = ''.obs;

  Rx<User?> firebaseUser = Rx<User?>(null);

  void setRxError(String message) => error.value = message;
  void setRxIsLoading(bool loading) => isLoading.value = loading;
  @override
  void onInit() {
    firebaseUser.value = _authService.getCurrentUser();
    super.onInit();
  }

  // Google Sign-In
  Future<void> signInWithGoogle() async {
    try {
      setRxIsLoading(true);
      final user = await _authService.signInWithGoogle();
      if (user != null) {
        SessionController().uid = user.uid.toString();
        Utils.snackbarMessage("Success", "Google Sign-In successful");
        Get.offAllNamed(RoutesName.homeView);
      }
    } catch (e) {
      setRxIsLoading(false);
      Utils.snackbarMessage("Error", "Google Sign-In failed");
      setRxError(e.toString());
    } finally {
      setRxIsLoading(false);
    }
  }

  // Logout
  Future<void> signOut() async {
    await _authService.signOut();
    firebaseUser.value = null;
    Get.offAllNamed(RoutesName.loginView);
  }
}

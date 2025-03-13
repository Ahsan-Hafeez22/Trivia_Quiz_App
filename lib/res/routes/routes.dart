import 'package:get/get.dart';
import 'package:trivia_quiz_app/res/routes/routes_name.dart';
import 'package:trivia_quiz_app/view/Auth/forgot_password.dart';
import 'package:trivia_quiz_app/view/Home/edit_user_screen.dart';
import 'package:trivia_quiz_app/view/Home/home_view.dart';
import 'package:trivia_quiz_app/view/Auth/Login/login_view.dart';
import 'package:trivia_quiz_app/view/Auth/Sign%20Up/register_view.dart';
import 'package:trivia_quiz_app/view/Home/quiz_screen.dart';
import 'package:trivia_quiz_app/view/Home/quiz_selection_view.dart';
import 'package:trivia_quiz_app/view/Home/result_screen.dart';
import 'package:trivia_quiz_app/view/splash_screen.dart';

class AppRoutes {
  static List<GetPage> appRoutes() {
    return [
      GetPage(
        name: RoutesName.splashScreen,
        page: () => QuizSplashScreen(),
        transition: Transition.fadeIn,
      ),
      GetPage(
        name: RoutesName.loginView,
        page: () => LoginView(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: RoutesName.registerView,
        page: () => RegisterView(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: RoutesName.homeView,
        page: () => HomeView(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: RoutesName.forgotPassword,
        page: () => ForgotPassword(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: RoutesName.editView,
        page: () => EditUserScreen(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: RoutesName.quizSelectionView,
        page: () => QuizSelectionView(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: RoutesName.quizScreen,
        page: () => QuizScreen(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: RoutesName.resultScreen,
        page: () => ResultScreen(),
        transition: Transition.rightToLeft,
      ),
    ];
  }
}

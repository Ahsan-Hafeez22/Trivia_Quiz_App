import 'package:get/get.dart';
import 'package:trivia_quiz_app/bindings/forgot_password_binding.dart';
import 'package:trivia_quiz_app/bindings/loading_binding.dart';
import 'package:trivia_quiz_app/bindings/login_binding.dart';
import 'package:trivia_quiz_app/bindings/quiz_binding.dart';
import 'package:trivia_quiz_app/bindings/register_binding.dart';
import 'package:trivia_quiz_app/res/routes/routes_name.dart';
import 'package:trivia_quiz_app/view/Auth/forgot_password.dart';
import 'package:trivia_quiz_app/view/Home/edit_user_screen.dart';
import 'package:trivia_quiz_app/view/Home/history_screen.dart';
import 'package:trivia_quiz_app/view/Home/home_view.dart';
import 'package:trivia_quiz_app/view/Auth/Login/login_view.dart';
import 'package:trivia_quiz_app/view/Auth/Sign%20Up/register_view.dart';
import 'package:trivia_quiz_app/view/Home/question_detail_screen.dart';
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
        binding: LoginBinding(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: RoutesName.registerView,
        page: () => RegisterView(),
        binding: RegisterBinding(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: RoutesName.forgotPassword,
        page: () => ForgotPassword(),
        binding: ForgotPasswordBinding(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: RoutesName.homeView,
        page: () => HomeView(),
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
        binding: QuizBinding(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: RoutesName.quizScreen,
        page: () => QuizScreen(),
        binding: LoadingBinding(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: RoutesName.resultScreen,
        page: () => ResultScreen(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: RoutesName.historyScreen,
        page: () => HistoryScreen(),
        transition: Transition.circularReveal,
      ),
      GetPage(
        name: RoutesName.questionDetailScreen,
        page: () => QuestionsDetailScreen(),
        transition: Transition.downToUp,
      ),
    ];
  }
}

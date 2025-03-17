import 'package:get/get.dart';
import 'package:trivia_quiz_app/view_model/controller/home_controller/quiz_controller.dart';

class QuizBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<QuizController>(() => QuizController());
  }
}

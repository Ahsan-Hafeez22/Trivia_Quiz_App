import 'package:get/get.dart';
import 'package:trivia_quiz_app/data/responses/status.dart';
import 'package:trivia_quiz_app/data/respository/quiz_repo.dart';
import 'package:trivia_quiz_app/model/quizModel.dart';
import 'package:trivia_quiz_app/res/routes/routes_name.dart';

class QuizController extends GetxController {
  final rxResponseStatus = Status.IDLE.obs;
  final rxError = "".obs;
  final quizResponse = Rxn<QuizModel>();
  final repo = QuizRepo();

  final RxString selectedCategory = "Any Category".obs;
  final RxString selectedDifficulty = "Any Difficulty".obs;
  final RxString selectedType = "Any Type".obs;

  void setCategory(String value) => selectedCategory.value = value;
  void setDifficulty(String value) => selectedDifficulty.value = value;
  void setType(String value) => selectedType.value = value;
  void setRxError(String error) => rxError.value = error;
  void setRxResponseStatus(Status status) => rxResponseStatus.value = status;
  void setQuizResponse(QuizModel quizs) => quizResponse.value = quizs;

  void getQuiz({required int amount}) async {
    setRxResponseStatus(Status.LOADING);
    repo
        .getQuizData(
      amount: amount,
      difficulty: selectedDifficulty.value,
      type: selectedType.value,
      category: selectedCategory.value,
    )
        .then((value) {
      setRxResponseStatus(Status.COMPLETED);
      setQuizResponse(value);
      Get.toNamed(RoutesName.quizScreen);
    }).onError((error, stackTrace) {
      setRxResponseStatus(Status.ERROR);
      setRxError(error.toString());
    });
  }
}

import 'package:get/get.dart';
import 'package:trivia_quiz_app/data/responses/status.dart';
import 'package:trivia_quiz_app/data/respository/quiz_repo.dart';
import 'package:trivia_quiz_app/model/quiz_model.dart';
import 'package:trivia_quiz_app/res/routes/routes_name.dart';

class QuizController extends GetxController {
  final rxResponseStatus = Status.IDLE.obs;
  final rxError = "".obs;
  final quizResponse = Rxn<QuizModel>();
  final repo = QuizRepo();

  // Make variables public via getters
  final _selectedCategory = "Any Category".obs;
  final _selectedDifficulty = "Any Difficulty".obs;
  final _selectedType = "Any Type".obs;

  String get selectedCategory => _selectedCategory.value;
  String get selectedDifficulty => _selectedDifficulty.value;
  String get selectedType => _selectedType.value;

  void setCategory(String value) => _selectedCategory.value = value;
  void setDifficulty(String value) => _selectedDifficulty.value = value;
  void setType(String value) => _selectedType.value = value;
  void setRxError(String error) => rxError.value = error;
  void setRxResponseStatus(Status status) => rxResponseStatus.value = status;
  void setQuizResponse(QuizModel quizs) => quizResponse.value = quizs;

  void getQuiz({required int amount}) async {
    setRxResponseStatus(Status.LOADING);
    try {
      final value = await repo.getQuizData(
        amount: amount,
        difficulty: _selectedDifficulty.value,
        type: _selectedType.value,
        category: _selectedCategory.value,
      );
      setRxResponseStatus(Status.COMPLETED);
      setQuizResponse(value);
      Get.toNamed(RoutesName.quizScreen);
    } catch (error) {
      setRxResponseStatus(Status.ERROR);
      setRxError(error.toString());
    }
  }
}

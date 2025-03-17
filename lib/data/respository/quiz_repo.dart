import 'dart:developer';

import 'package:trivia_quiz_app/data/network/network_api_service.dart';
import 'package:trivia_quiz_app/model/quiz_model.dart';
import 'package:trivia_quiz_app/res/url/app_urls.dart';

class QuizRepo {
  final _apiService = NetworkApiService();
  Future<QuizModel> getQuizData(
      {required int amount,
      String? difficulty,
      String? type,
      String? category}) async {
    final String url = AppUrls.buildQuizApiUrl(
        amount: amount, difficulty: difficulty, type: type, category: category);
    log('url: ${url.toString()}');
    try {
      log("Enter Repo");
      dynamic response = await _apiService.getApi(url);
      if (response is Map<String, dynamic>) {
        // QuizModel quizModel = QuizModel.fromJson(response);
        // // log("Response: ${response.toString()}");
        // log("Mapped QuizModel: ${quizModel.toString()}");
        return QuizModel.fromJson(response);
      } else {
        throw Exception('Failed to fetch quiz data');
      }
    } catch (e) {
      throw Exception("Error fetching products: $e");
    }
  }
}

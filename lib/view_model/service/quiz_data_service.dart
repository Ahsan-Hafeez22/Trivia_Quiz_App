import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:trivia_quiz_app/model/quiz_model.dart';
import 'package:trivia_quiz_app/utils/utils.dart';
import 'package:trivia_quiz_app/view_model/controller/loading_controller.dart';

class StoreQuizDataService {
  CollectionReference quiz = FirebaseFirestore.instance.collection('quiz_data');
  final loadingController = Get.put(LoadingController());

  Future<void> storeQuizHistory({
    required String userId,
    required int correctCount,
    required int incorrectCount,
    required int totalQuestions,
    required List<Result> questionsList,
  }) async {
    try {
      loadingController.setLoadingValue(true);
      final quizId = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('quiz_history')
          .doc()
          .id;

      double winningPercentage = (correctCount / totalQuestions) * 100;

      // ✅ Convert List<Result> to List<Map<String, dynamic>> with enums as Strings
      List<Map<String, dynamic>> questionsAsMap = questionsList
          .map((question) => {
                "type":
                    typeValues.reverse[question.type], // Convert enum to String
                "difficulty":
                    difficultyValues.reverse[question.difficulty], // ✅ Fix
                "category": question.category,
                "question": question.question,
                "correct_answer": question.correctAnswer,
                "incorrect_answers": question.incorrectAnswers,
              })
          .toList();

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('quiz_history')
          .doc(quizId)
          .set({
        'correct_count': correctCount,
        'incorrect_count': incorrectCount,
        'total_questions': totalQuestions,
        'winning_percentage': winningPercentage,
        'date_time': Timestamp.now(),
        'questions': questionsAsMap,
      });
      loadingController.setLoadingValue(false);
    } catch (e) {
      log(e.toString());
      loadingController.setLoadingValue(false);

      throw Exception(e);
    }
  }

  Future<List<Map<String, dynamic>>> fetchQuizHistory(String userId) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('quiz_history')
        .orderBy('date_time', descending: true)
        .get();

    return snapshot.docs.map((doc) {
      var data = doc.data() as Map<String, dynamic>;
      data['docId'] = doc.id;
      return data;
    }).toList();
  }

  Future<void> deleteQuiz(String userId, String docId) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('quiz_history')
          .doc(docId)
          .delete();
      Utils.toastMessage("Quiz record deleted");
    } catch (e) {
      Utils.toastMessage("Failed to delete quiz record");
    }
  }

  Future<void> deleteAllQuizHistory(String userId) async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('quiz_history')
          .get();

      if (snapshot.docs.isEmpty) {
        Utils.toastMessage("No history to delete");
        return;
      }

      WriteBatch batch = FirebaseFirestore.instance.batch();

      for (QueryDocumentSnapshot doc in snapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
      Utils.toastMessage("All quiz history deleted");
    } catch (e) {
      Utils.toastMessage("Failed to delete quiz history");
    }
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trivia_quiz_app/model/quiz_model.dart';
import 'package:trivia_quiz_app/res/component/custom_card_resullt.dart';
import 'package:trivia_quiz_app/res/font/app_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:trivia_quiz_app/res/routes/routes_name.dart';
import 'package:trivia_quiz_app/utils/utils.dart';
import 'package:trivia_quiz_app/view_model/service/auth_service.dart';
import 'package:trivia_quiz_app/view_model/service/quiz_data_service.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final quizData = StoreQuizDataService();
  final auth = AuthService();
  late User? user;
  late Future<List<Map<String, dynamic>>> quizHistoryFuture;

  @override
  void initState() {
    user = auth.getCurrentUser();
    super.initState();
    quizHistoryFuture = quizData.fetchQuizHistory(user!.uid);
  }

  void refreshQuizHistory() {
    setState(() {
      quizHistoryFuture = quizData.fetchQuizHistory(user!.uid);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFFFFFFF), Color(0xFFFFFFFF), Color(0xFF24243e)],
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(CupertinoIcons.back, color: Colors.white),
            onPressed: () => Get.back(),
          ),
          backgroundColor: Colors.black,
          title: Text('History', style: AppFonts.bold24()),
          actions: [
            FutureBuilder(
              future: quizHistoryFuture,
              builder: (context,
                  AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                bool hasHistory = snapshot.hasData && snapshot.data!.isNotEmpty;

                return IconButton(
                  icon: const Icon(CupertinoIcons.delete, color: Colors.red),
                  onPressed: hasHistory
                      ? () {
                          Utils.showAlertBox(
                            context,
                            primaryColor: Colors.red,
                            "Alert",
                            "Do you really want to delete the complete history?",
                            () async {
                              await quizData.deleteAllQuizHistory(user!.uid);
                              refreshQuizHistory();
                            },
                          );
                        }
                      : null, // Disable if no history
                );
              },
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: FutureBuilder(
            future: quizHistoryFuture,
            builder:
                (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: LoadingAnimationWidget.hexagonDots(
                    color: Colors.black,
                    size: 40,
                  ),
                );
              }

              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    "Something went wrong. Please try again.",
                    style: AppFonts.normal20(color: Colors.red),
                  ),
                );
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.history, size: 70, color: Colors.grey[400]),
                      const SizedBox(height: 10),
                      Text(
                        "No quiz history available",
                        style: AppFonts.normal16(color: Colors.black),
                      ),
                    ],
                  ),
                );
              }

              final quizHistory = snapshot.data!;

              return ListView.builder(
                itemCount: quizHistory.length,
                itemBuilder: (context, index) {
                  final quiz = quizHistory[index];
                  final docId = quiz['docId'];

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Dismissible(
                      key: ValueKey(docId),
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        color: Colors.red,
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      direction: DismissDirection.endToStart,
                      onDismissed: (_) async {
                        await quizData.deleteQuiz(user!.uid, docId);
                        refreshQuizHistory();
                      },
                      child: GestureDetector(
                        onTap: () {
                          List<Result> resultList = (quiz['questions'] as List)
                              .map((question) => Result.fromJson(question))
                              .toList();
                          Get.toNamed(
                            RoutesName.questionDetailScreen,
                            arguments: {'resultList': resultList},
                          );
                        },
                        child: customResultCard(
                          context: context,
                          scorePercentage:
                              quiz['winning_percentage']?.toDouble() ?? 0.0,
                          correctAnswerCount: quiz['correct_count'] ?? 0,
                          incorrectAnswerCount: quiz['incorrect_count'] ?? 0,
                          totalQuestionCount: quiz['total_questions'] ?? 0,
                          dateTime: quiz['date_time'],
                          textSize: 18,
                          width: 60,
                          height: 60,
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

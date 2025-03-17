import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trivia_quiz_app/res/component/custom_button.dart';
import 'package:trivia_quiz_app/res/component/custom_card_resullt.dart';
import 'package:trivia_quiz_app/res/routes/routes_name.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> arguments = Get.arguments ?? {};
    final int correctAnswerCount = arguments['correctAnswerCount'] ?? 0;
    final int incorrectAnswerCount = arguments['incorrectAnswerCount'] ?? 0;
    final int totalQuestionCount = arguments['totalQuestionCount'] ?? 0;
    final List<dynamic> resultList = arguments['result'] ?? [];
    final double scorePercentage = totalQuestionCount > 0
        ? (correctAnswerCount / totalQuestionCount) * 100
        : 0.0;

    return PopScope(
      canPop: false,
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color.fromARGB(255, 232, 210, 10), Color(0xFFFFFFFF)],
          ),
        ),
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              scrolledUnderElevation: 0,
              leading: IconButton(
                icon: const Icon(CupertinoIcons.back, color: Colors.black),
                onPressed: () => Get.offAllNamed(RoutesName.homeView),
              ),
              backgroundColor: Colors.transparent,
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: customResultCard(
                      context: context,
                      scorePercentage: scorePercentage,
                      correctAnswerCount: correctAnswerCount,
                      incorrectAnswerCount: incorrectAnswerCount,
                      totalQuestionCount: totalQuestionCount,
                      // textSize: 20,
                    ),
                  ),
                  // SizedBox(height: Get.height * 0.04),
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.quiz,
                          size: 60,
                          color: Colors.grey[500],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Click the button below to see\nquestions and correct answers",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: Get.height * 0.04),
                  CustomButton(
                      title: 'Show Questions & Answers',
                      textColor: Colors.white,
                      buttonColor: Colors.green,
                      width: Get.width * 0.8,
                      onPress: () {
                        Get.toNamed(RoutesName.questionDetailScreen,
                            arguments: {'resultList': resultList});
                      }),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

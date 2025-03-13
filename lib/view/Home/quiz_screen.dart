import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trivia_quiz_app/res/asset/image.dart';
import 'package:trivia_quiz_app/res/color/color.dart';
import 'package:trivia_quiz_app/res/font/app_fonts.dart';
import 'package:trivia_quiz_app/res/routes/routes_name.dart';
import 'package:trivia_quiz_app/view_model/controller/home_controller/quiz_controller.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final QuizController quizController = Get.find<QuizController>();
  final ValueNotifier<int> _secondsNotifier = ValueNotifier<int>(60);
  int currentQuestionIndex = 0;
  Timer? timer;
  List<String> optionList = [];
  List<Color> optionColor = [];
  bool isAnswered = false;
  int correctAnswerCount = 0;
  int incorrectAnswerCount = 0;
  int quizLength = 0;

  @override
  void initState() {
    super.initState();
    loadQuestion();
    startTimer();
  }

  @override
  void dispose() {
    timer?.cancel();
    _secondsNotifier.dispose();
    super.dispose();
  }

  void startTimer() {
    timer?.cancel();
    timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (_secondsNotifier.value > 0) {
          _secondsNotifier.value--;
        } else {
          goToNextQuestion();
        }
      },
    );
  }

  void resetColors() {
    optionColor = List.generate(optionList.length, (index) => Colors.white);
  }

  void loadQuestion() {
    final quizResults = quizController.quizResponse.value?.results ?? [];
    quizLength = quizResults.length;
    if (currentQuestionIndex < quizLength) {
      setState(() {
        optionList =
            List.from(quizResults[currentQuestionIndex].incorrectAnswers);
        optionList.add(quizResults[currentQuestionIndex].correctAnswer);
        optionList.shuffle();
        resetColors();
        isAnswered = false;
        _secondsNotifier.value = 60;
      });
    }
  }

  void goToNextQuestion() {
    if (currentQuestionIndex <
        (quizController.quizResponse.value?.results.length ?? 0) - 1) {
      currentQuestionIndex++;
      loadQuestion();
      startTimer();
    } else {
      timer?.cancel();
      showCompletionDialog();
    }
  }

  void showCompletionDialog() {
    Get.offAllNamed(RoutesName.resultScreen, arguments: {
      'correctAnswerCount': correctAnswerCount,
      'incorrectAnswerCount': incorrectAnswerCount,
      'totalQuestionCount': quizLength,
    });
  }

  @override
  Widget build(BuildContext context) {
    final quizResults = quizController.quizResponse.value?.results ?? [];
    if (quizResults.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.blue,
        body: Center(
            child: Text("No quiz data available", style: AppFonts.normal20())),
      );
    }

    String correctAnswer = quizResults[currentQuestionIndex].correctAnswer;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.darkBlue, AppColors.blue, AppColors.lightBlue],
        ),
      ),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.red, size: 30),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    ValueListenableBuilder<int>(
                      valueListenable: _secondsNotifier,
                      builder: (context, seconds, _) {
                        return Stack(
                          alignment: Alignment.center,
                          children: [
                            Text('$seconds', style: AppFonts.normal24()),
                            SizedBox(
                              height: 70,
                              width: 70,
                              child: CircularProgressIndicator(
                                value: seconds / 60,
                                valueColor:
                                    AlwaysStoppedAnimation(Colors.white),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(height: Get.height * 0.05),
                Image.asset(ImageAssets.quizSplashLogo, width: 150),
                SizedBox(height: Get.height * 0.02),
                Text(
                  'Question ${currentQuestionIndex + 1} of ${quizResults.length}',
                  style: AppFonts.bold18(),
                ),
                SizedBox(height: Get.height * 0.02),
                Text(
                  quizResults[currentQuestionIndex].question,
                  style: AppFonts.normal18(),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: Get.height * 0.03),
                ListView.builder(
                  itemCount: optionList.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: isAnswered
                          ? null
                          : () {
                              setState(() {
                                isAnswered = true;
                                if (optionList[index] == correctAnswer) {
                                  optionColor[index] = Colors.green;
                                  correctAnswerCount++;
                                } else {
                                  optionColor[index] = Colors.red;
                                  incorrectAnswerCount++;
                                }
                              });

                              Future.delayed(Duration(milliseconds: 500), () {
                                goToNextQuestion();
                              });
                            },
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        margin: EdgeInsets.only(bottom: 10),
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                        alignment: Alignment.center,
                        width: Get.width * 0.6,
                        decoration: BoxDecoration(
                          color: optionColor[index],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          optionList[index],
                          style: AppFonts.normal16(color: Colors.black),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

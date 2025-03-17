import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:trivia_quiz_app/res/asset/image.dart';
import 'package:trivia_quiz_app/res/color/color.dart';
import 'package:trivia_quiz_app/res/font/app_fonts.dart';
import 'package:trivia_quiz_app/res/routes/routes_name.dart';
import 'package:trivia_quiz_app/utils/utils.dart';
import 'package:trivia_quiz_app/view_model/controller/home_controller/quiz_controller.dart';
import 'package:trivia_quiz_app/view_model/controller/loading_controller.dart';
import 'package:trivia_quiz_app/view_model/service/auth_service.dart';
import 'package:trivia_quiz_app/view_model/service/quiz_data_service.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final QuizController quizController = Get.find<QuizController>();
  final ValueNotifier<int> _secondsNotifier = ValueNotifier<int>(10);
  final storeQuizDataService = StoreQuizDataService();
  final authService = AuthService();
  var unescape = HtmlUnescape();
  final loadingController = Get.find<LoadingController>();

  int currentQuestionIndex = 0;
  Timer? timer;
  List<String> optionList = [];
  List<Color> optionColor = [];
  bool isAnswered = false;
  int correctAnswerCount = 0;
  int incorrectAnswerCount = 0;
  int quizLength = 0;
  String correctAnswer = "";
  bool hasStoredData = false;

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
    _secondsNotifier.value = 10;

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsNotifier.value > 0) {
        _secondsNotifier.value--;
      } else {
        goToNextQuestion();
      }
    });
  }

  void resetColors() =>
      optionColor = List.generate(optionList.length, (index) => Colors.white);

  void loadQuestion() {
    final quizResults = quizController.quizResponse.value?.results ?? [];
    quizLength = quizResults.length;

    if (currentQuestionIndex < quizLength) {
      final currentQuestion = quizResults[currentQuestionIndex];

      setState(() {
        isAnswered = false;
        _secondsNotifier.value = 10;
        correctAnswer = currentQuestion.correctAnswer;
        optionList = List.from(currentQuestion.incorrectAnswers);
        optionList.add(correctAnswer);
        optionList.shuffle();

        resetColors();
      });
    }
  }

  void goToNextQuestion() {
    if (currentQuestionIndex < quizLength - 1) {
      currentQuestionIndex++;
      loadQuestion();
      startTimer();
    } else {
      if (!hasStoredData) {
        hasStoredData = true;
        showCompletionDialog();
      }
    }
  }

  void showCompletionDialog() async {
    final user = authService.getCurrentUser();
    if (user == null) return;

    loadingController.setLoadingValue(true);
    try {
      await storeQuizDataService.storeQuizHistory(
        userId: user.uid,
        correctCount: correctAnswerCount,
        incorrectCount: incorrectAnswerCount,
        totalQuestions: quizLength,
        questionsList: quizController.quizResponse.value!.results,
      );

      Utils.toastMessage('Stored in History');

      loadingController.setLoadingValue(false);

      Get.toNamed(RoutesName.resultScreen, arguments: {
        'correctAnswerCount': correctAnswerCount,
        'incorrectAnswerCount': incorrectAnswerCount,
        'totalQuestionCount': quizLength,
        'result': quizController.quizResponse.value?.results ?? []
      });
    } catch (error) {
      loadingController.setLoadingValue(false);
      Utils.toastMessage('Failed to store data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final quizResults = quizController.quizResponse.value?.results ?? [];

    if (quizResults.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.blue,
        body: Center(
          child: Text("No quiz data available", style: AppFonts.normal20()),
        ),
      );
    }

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.darkBlue, AppColors.blue, AppColors.lightBlue],
        ),
      ),
      child: Obx(() => loadingController.loadingValue.value
          ? Center(
              child: LoadingAnimationWidget.inkDrop(
                color: Colors.black,
                size: 40,
              ),
            )
          : SafeArea(
              child: Scaffold(
                backgroundColor: Colors.transparent,
                body: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.close,
                                color: Colors.red, size: 30),
                            onPressed: () {
                              Utils.showAlertBox(
                                primaryColor: Colors.blue,
                                context,
                                "Alert",
                                "If you exit, your progress will be lost",
                                () => Navigator.of(context).pop(),
                              );
                            },
                          ),
                          ValueListenableBuilder<int>(
                            valueListenable: _secondsNotifier,
                            builder: (context, seconds, _) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Text('$seconds',
                                        style: AppFonts.normal24()),
                                    SizedBox(
                                      height: 50,
                                      width: 50,
                                      child: CircularProgressIndicator(
                                        value: seconds / 10,
                                        valueColor:
                                            const AlwaysStoppedAnimation(
                                                Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: Get.height * 0.05),
                      Image.asset(ImageAssets.quizSplashLogo, width: 150),
                      SizedBox(height: Get.height * 0.02),
                      Text(
                        'Question ${currentQuestionIndex + 1} of $quizLength',
                        style: AppFonts.bold18(),
                      ),
                      SizedBox(height: Get.height * 0.02),
                      Text(
                        unescape.convert(
                            quizResults[currentQuestionIndex].question),
                        style: AppFonts.normal18(),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: Get.height * 0.03),
                      SizedBox(
                        height: Get.height * 0.4,
                        child: ListView.builder(
                          itemCount: optionList.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: isAnswered
                                  ? null
                                  : () {
                                      setState(() {
                                        isAnswered = true;
                                        if (optionList[index] ==
                                            correctAnswer) {
                                          optionColor[index] = Colors.green;
                                          correctAnswerCount++;
                                        } else {
                                          optionColor[index] = Colors.red;
                                          incorrectAnswerCount++;
                                        }
                                      });

                                      Future.delayed(
                                          const Duration(milliseconds: 500),
                                          () {
                                        goToNextQuestion();
                                      });
                                    },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                margin: const EdgeInsets.only(bottom: 10),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 25),
                                decoration: BoxDecoration(
                                  color: optionColor[index],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  unescape.convert(optionList[index]),
                                  style: AppFonts.normal16(color: Colors.black),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )),
    );
  }
}

import 'dart:developer';
import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:trivia_quiz_app/data/responses/status.dart';
import 'package:trivia_quiz_app/res/color/color.dart';
import 'package:trivia_quiz_app/res/component/custom_button.dart';
import 'package:trivia_quiz_app/res/font/app_fonts.dart';
import 'package:trivia_quiz_app/view_model/controller/home_controller/quiz_controller.dart';

class QuizSelectionView extends StatefulWidget {
  const QuizSelectionView({super.key});

  @override
  State<QuizSelectionView> createState() => _QuizSelectionViewState();
}

class _QuizSelectionViewState extends State<QuizSelectionView> {
  final TextEditingController _controller = TextEditingController(text: '10');
  final quizController = Get.find<QuizController>();
  Map<String, dynamic> data = Get.arguments ?? {};

  /// Dropdown Lists
  final List<String> _difficultyList = [
    'Any Difficulty',
    'Easy',
    'Medium',
    'Hard'
  ];
  final List<String> _typeList = ['Any Type', 'True/False', 'Multiple Choice'];
  final List<String> _categoryList = [
    'Any Category',
    'General Knowledge',
    'Science & Nature',
    'Animal',
    'Sport',
    'Art',
    'Celebrities',
    'Vehicles'
  ];

  @override
  Widget build(BuildContext context) {
    quizController.setCategory(data['category'] ?? "Any Category");
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF0f0c29), Color(0xFF302b63), Color(0xFF24243e)],
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(CupertinoIcons.back, color: Colors.white),
            onPressed: () => Get.back(),
          ),
          backgroundColor: Colors.black,
          title: Text('Quiz Selection', style: AppFonts.bold24()),
        ),
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: Get.height * .01),
                Text(
                  'Select the Quiz Difficulty, Type, and Number of Questions to get the quiz.',
                  style: AppFonts.normal16(color: AppColors.lightGrey),
                ),
                SizedBox(height: Get.height * .02),

                Text('Number of Questions:', style: AppFonts.bold18()),
                SizedBox(height: Get.height * .02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomButton(
                      title: '-',
                      width: Get.width * 0.05,
                      buttonColor: Colors.red,
                      onPress: () {
                        int currentVal = int.tryParse(_controller.text) ?? 10;
                        if (currentVal > 10) {
                          setState(() {
                            _controller.text = (currentVal - 1).toString();
                          });
                        }
                      },
                      textColor: Colors.white,
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: 50,
                      child: TextFormField(
                        onTapOutside: (event) =>
                            FocusManager.instance.primaryFocus?.unfocus(),
                        style: AppFonts.bold16(color: Colors.black),
                        inputFormatters: [LengthLimitingTextInputFormatter(2)],
                        controller: _controller,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        decoration: const InputDecoration(
                          border:
                              OutlineInputBorder(borderSide: BorderSide.none),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    CustomButton(
                      title: '+',
                      width: Get.width * 0.05,
                      onPress: () {
                        int currentVal = int.tryParse(_controller.text) ?? 10;
                        if (currentVal < 30) {
                          setState(() {
                            _controller.text = (currentVal + 1).toString();
                          });
                        }
                      },
                      buttonColor: Colors.red,
                      textColor: Colors.white,
                    ),
                  ],
                ),
                SizedBox(height: Get.height * .02),

                Text('Select Difficulty:', style: AppFonts.bold18()),
                SizedBox(height: Get.height * .02),
                Obx(
                  () => CustomDropdown<String>(
                    hintText: '',
                    items: _difficultyList,
                    initialItem: quizController.selectedDifficulty,
                    onChanged: (value) {
                      quizController.setDifficulty(value!);
                      log('Selected Difficulty: ${quizController.selectedDifficulty}');
                    },
                  ),
                ),

                SizedBox(height: Get.height * .02),

                /// Type Selection
                Text('Select Type:', style: AppFonts.bold18()),
                SizedBox(height: Get.height * .02),
                Obx(
                  () => CustomDropdown<String>(
                    hintText: '',
                    items: _typeList,
                    initialItem: quizController.selectedType,
                    onChanged: (value) {
                      quizController.setType(value!);
                      log('Selected Type: ${quizController.selectedType}');
                    },
                  ),
                ),

                SizedBox(height: Get.height * .02),

                /// Category Selection
                Text('Select Category:', style: AppFonts.bold18()),
                SizedBox(height: Get.height * .02),
                Obx(
                  () => CustomDropdown<String>(
                    hintText: '',
                    items: _categoryList,
                    initialItem: quizController.selectedCategory,
                    onChanged: (value) {
                      quizController.setCategory(value!);
                      log('Selected Category: ${quizController.selectedCategory}');
                    },
                  ),
                ),

                SizedBox(height: Get.height * .02),

                /// Start Quiz Button
                Obx(() => CustomButton(
                      title: 'Start Quiz',
                      width: Get.width * 0.5,
                      buttonColor: Colors.yellow,
                      loading: quizController.rxResponseStatus.value ==
                          Status.LOADING,
                      onPress: () {
                        quizController.getQuiz(
                            amount: int.parse(_controller.text.trim()));
                      },
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

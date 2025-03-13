import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trivia_quiz_app/res/asset/image.dart';
import 'package:trivia_quiz_app/res/color/color.dart';
import 'package:trivia_quiz_app/res/component/custom_button.dart';
import 'package:trivia_quiz_app/view_model/service/splash_service.dart';

class QuizSplashScreen extends StatefulWidget {
  const QuizSplashScreen({super.key});

  @override
  State<QuizSplashScreen> createState() => _QuizSplashScreenState();
}

class _QuizSplashScreenState extends State<QuizSplashScreen> {
  final service = SplashService();
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(
          colors: [AppColors.darkBlue, AppColors.blue, AppColors.lightBlue],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        )),
        child: SafeArea(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: Get.height * 0.08),
            Center(child: Image.asset(ImageAssets.quizSplashLogo)),
            SizedBox(height: 25),
            Text('Welcome to Trivia Quiz App!',
                style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold)),
            SizedBox(height: Get.height * 0.01),
            Text(
              'Trivia Quiz App is a simple quiz app where users can answer multiple-choice questions across various categories, track their scores, and challenge friends.',
              style: TextStyle(
                  fontSize: 16,
                  color: AppColors.lightGrey,
                  fontWeight: FontWeight.w400),
            ),
            Spacer(),
            CustomButton(
              title: "Continue",
              width: width * 0.8,
              height: height * 0.1,
              onPress: () {
                service.isLogin(context);
              },
            )
          ],
        )),
      ),
    );
  }
}

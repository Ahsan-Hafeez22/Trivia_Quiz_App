import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trivia_quiz_app/constants/config/config_keys_body.dart';
import 'package:trivia_quiz_app/constants/config/config_keys_title.dart';
import 'package:trivia_quiz_app/constants/locale/trivia_quiz_app.dart';
import 'package:trivia_quiz_app/res/color/color.dart';
import 'package:trivia_quiz_app/res/component/auth_custom_textfield.dart';
import 'package:trivia_quiz_app/res/component/custom_button.dart';
import 'package:trivia_quiz_app/res/font/app_fonts.dart';
import 'package:trivia_quiz_app/view_model/controller/auth_controllers/forgot_password_controller.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController emailController = TextEditingController();
  FocusNode focusNodeEmail = FocusNode();
  final fpc = Get.find<ForgotPasswordController>();
  final _formKey = GlobalKey<FormState>();
  final mLocaleData =
      TriviaQuizApp.mLocate[ConfigKeysTitle.forgotPasswordScreen];
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.darkBlue, AppColors.blue, AppColors.lightBlue],
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: Get.height * 0.04),
                    Row(
                      children: [
                        IconButton(
                          style: IconButton.styleFrom(padding: EdgeInsets.zero),
                          onPressed: () => Get.back(),
                          icon: Icon(
                            CupertinoIcons.back,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          mLocaleData![ConfigKeysBody.forgotPasswordTitle]!,
                          style: AppFonts.bold24(),
                        ),
                      ],
                    ),
                    SizedBox(height: Get.height * 0.05),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          Text(
                            mLocaleData![
                                ConfigKeysBody.forgotPasswordSubtitle]!,
                            style:
                                AppFonts.normal18(color: AppColors.lightGrey),
                          ),
                          SizedBox(height: Get.height * 0.04),
                          Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  AuthTextField(
                                    controller: emailController,
                                    hintText: mLocaleData![ConfigKeysBody
                                        .forgotPasswordEmailHint]!,
                                    type: "email",
                                    focusNode: focusNodeEmail,
                                  ),
                                  SizedBox(
                                    height: Get.height * 0.01,
                                  ),
                                  SizedBox(height: Get.height * 0.01),
                                ],
                              )),
                          SizedBox(height: Get.height * 0.04),
                          Obx(
                            () {
                              return CustomButton(
                                title: mLocaleData![
                                    ConfigKeysBody.forgotPasswordButtonText]!,
                                onPress: _sentEmail,
                                width: Get.width * 0.4,
                                loading: fpc.isLoading.value,
                              );
                            },
                          ),
                        ],
                      ),
                    )
                  ]),
            ),
          ),
        ));
  }

  void _sentEmail() {
    if (!_formKey.currentState!.validate()) return;
    fpc.forgotPassword(emailController.text.trim());
  }
}

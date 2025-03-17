import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trivia_quiz_app/constants/config/config_keys_body.dart';
import 'package:trivia_quiz_app/constants/config/config_keys_title.dart';
import 'package:trivia_quiz_app/constants/locale/trivia_quiz_app.dart';
import 'package:trivia_quiz_app/res/color/color.dart';
import 'package:trivia_quiz_app/res/component/custom_button.dart';
import 'package:trivia_quiz_app/res/component/text_field.dart';
import 'package:trivia_quiz_app/utils/form_validation.dart';
import 'package:trivia_quiz_app/view_model/controller/auth_controllers/signup_controller.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final cpasswordController = TextEditingController();
  final FocusNode focusNode1 = FocusNode();
  final FocusNode focusNode2 = FocusNode();
  final FocusNode focusNode3 = FocusNode();
  final FocusNode focusNode4 = FocusNode();
  final _formKey = GlobalKey<FormState>();
  final signupController = Get.find<SignupController>();
  final mLocaleData = TriviaQuizApp.mLocate[ConfigKeysTitle.registerScreen];
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
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
                          mLocaleData![ConfigKeysBody.registerTitle]!,
                          style: TextStyle(
                              fontSize: 28,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(height: Get.height * 0.04),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          Text(
                            mLocaleData![ConfigKeysBody.registerSubtitleText]!,
                            style: TextStyle(
                                fontSize: 18,
                                color: AppColors.lightGrey,
                                fontWeight: FontWeight.w400),
                          ),
                          SizedBox(height: Get.height * 0.04),
                          Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  CustomTextField(
                                    controller: nameController,
                                    hintText: mLocaleData![
                                        ConfigKeysBody.registerNameHint]!,
                                    type: "name",
                                    focusNode: focusNode1,
                                    focusNode2: focusNode2,
                                    validator: (value) =>
                                        validateInput(value, 'name'),
                                  ),
                                  SizedBox(height: 10),
                                  CustomTextField(
                                    controller: emailController,
                                    hintText: mLocaleData![
                                        ConfigKeysBody.registerEmailHint]!,
                                    type: "email",
                                    focusNode: focusNode2,
                                    focusNode2: focusNode3,
                                    validator: (value) =>
                                        validateInput(value, 'email'),
                                  ),
                                  SizedBox(height: 10),
                                  CustomTextField(
                                    controller: passwordController,
                                    hintText: mLocaleData![
                                        ConfigKeysBody.registerPasswordHint]!,
                                    type: "password",
                                    isPassword: true,
                                    focusNode: focusNode3,
                                    focusNode2: focusNode4,
                                    validator: (value) =>
                                        validateInput(value, 'password'),
                                  ),
                                  SizedBox(height: 10),
                                  CustomTextField(
                                    controller: cpasswordController,
                                    hintText: mLocaleData![ConfigKeysBody
                                        .registerConfirmPasswordHint]!,
                                    type: "password",
                                    isPassword: true,
                                    focusNode: focusNode4,
                                    validator: (value) => validateInput(
                                        value, 'confirm_password',
                                        password: passwordController.text),
                                  ),
                                  SizedBox(height: Get.height * 0.01),
                                ],
                              )),
                          SizedBox(height: Get.height * 0.04),
                          Obx(
                            () {
                              return CustomButton(
                                  title: mLocaleData![
                                      ConfigKeysBody.registerButtonText]!,
                                  loading: signupController.isLoading.value,
                                  width: width * 0.4,
                                  height: height * 0.07,
                                  onPress: _register);
                            },
                          ),
                          SizedBox(height: Get.height * 0.04),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                mLocaleData![
                                    ConfigKeysBody.registerAccountText]!,
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                              SizedBox(width: Get.width * 0.01),
                              GestureDetector(
                                onTap: () {
                                  Get.back();
                                },
                                child: Text(
                                  mLocaleData![
                                      ConfigKeysBody.registerLoginText]!,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.white),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    )
                  ]),
            ),
          ),
        ));
  }

  _register() async {
    if (!_formKey.currentState!.validate()) {
      return;
    } else {
      signupController.signup(
        nameController.text.trim(),
        emailController.text.trim(),
        passwordController.text.trim(),
      );
    }
  }
}

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:trivia_quiz_app/constants/config/config_keys_body.dart';
import 'package:trivia_quiz_app/constants/config/config_keys_title.dart';
import 'package:trivia_quiz_app/constants/locale/trivia_quiz_app.dart';
import 'package:trivia_quiz_app/res/asset/image.dart';
import 'package:trivia_quiz_app/res/color/color.dart';
import 'package:trivia_quiz_app/res/component/auth_custom_textfield.dart';
import 'package:trivia_quiz_app/res/component/custom_button.dart';
import 'package:trivia_quiz_app/res/font/app_fonts.dart';
import 'package:trivia_quiz_app/res/routes/routes_name.dart';
import 'package:trivia_quiz_app/view_model/controller/auth_controllers/google_controller.dart';
import 'package:trivia_quiz_app/view_model/controller/auth_controllers/login_controller.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  FocusNode focusNodeEmail = FocusNode();
  FocusNode focusNodePassword = FocusNode();
  final _formKey = GlobalKey<FormState>();
  final loginController = Get.find<LoginController>();
  final googleSinginController = Get.put(GoogleController());
  final mLocaleData = TriviaQuizApp.mLocate[ConfigKeysTitle.loginScreen];

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
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: Get.height * 0.04),
                    Row(
                      children: [
                        Center(
                          child: Image.asset(
                            ImageAssets.quizSplashLogo,
                            height: Get.height * 0.1,
                            width: Get.width * 0.2,
                          ),
                        ),
                        SizedBox(width: Get.width * 0.03),
                        Text(
                          mLocaleData![ConfigKeysBody.loginTitle]!,
                          style: AppFonts.bold36(),
                        ),
                      ],
                    ),
                    SizedBox(height: Get.height * 0.06),
                    Text(
                      mLocaleData![ConfigKeysBody.loginSubtitle]!,
                      style: AppFonts.bold28(),
                    ),
                    Text(
                      mLocaleData![ConfigKeysBody.loginSubtitleText]!,
                      style: AppFonts.light16(color: AppColors.lightGrey),
                    ),
                    SizedBox(height: Get.height * 0.04),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          emailField(),
                          SizedBox(height: Get.height * 0.01),
                          passwordField(),
                          SizedBox(height: Get.height * 0.01),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        SizedBox.shrink(),
                        Spacer(),
                        GestureDetector(
                          onTap: () {
                            Get.toNamed(RoutesName.forgotPassword);
                          },
                          child: Text(
                            mLocaleData![ConfigKeysBody.loginForgotPassword]!,
                            style: AppFonts.normal14().copyWith(
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: Get.height * 0.04),
                    Obx(
                      () {
                        return CustomButton(
                          title: mLocaleData![ConfigKeysBody.loginButtonText]!,
                          onPress: _login,
                          loading: loginController.isLoading.value,
                        );
                      },
                    ),
                    SizedBox(height: Get.height * 0.04),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          mLocaleData![ConfigKeysBody.loginAccountText]!,
                          style: AppFonts.normal16(),
                        ),
                        SizedBox(width: Get.width * 0.01),
                        GestureDetector(
                          onTap: () {
                            Get.toNamed(RoutesName.registerView);
                          },
                          child: Text(
                            mLocaleData![ConfigKeysBody.loginRegisterText]!,
                            style: AppFonts.bold16()
                                .copyWith(fontStyle: FontStyle.italic),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: Get.height * 0.02),
                    Obx(
                      () {
                        return googleSignInButton();
                      },
                    ),
                  ]),
            ),
          ),
        ));
  }

  Center googleSignInButton() {
    return Center(
      child: GestureDetector(
        onTap: () => googleSinginController.signInWithGoogle(),
        child: Container(
          height: Get.height * 0.08,
          width: Get.width * 0.8,
          padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
          decoration: BoxDecoration(
            color: Color(0xFFEA4335),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                // ignore: deprecated_member_use
                color: Colors.grey.withOpacity(0.5),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              googleSinginController.isLoading.value
                  ? SizedBox.shrink()
                  : Icon(
                      FontAwesomeIcons.google,
                      size: 20,
                      color: Colors.white,
                    ),
              SizedBox(width: 10),
              googleSinginController.isLoading.value
                  ? CircularProgressIndicator(
                      backgroundColor: Colors.white,
                    )
                  : Text(
                      mLocaleData![ConfigKeysBody.loginGoogleText]!,
                      style: AppFonts.bold16(),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  AuthTextField passwordField() {
    return AuthTextField(
      controller: passwordController,
      hintText: mLocaleData![ConfigKeysBody.loginPasswordHint]!,
      type: "password",
      focusNode: focusNodePassword,
    );
  }

  AuthTextField emailField() {
    return AuthTextField(
      controller: emailController,
      hintText: mLocaleData![ConfigKeysBody.loginEmailHint]!,
      type: "email",
      focusNode: focusNodeEmail,
      focusNode2: focusNodePassword,
    );
  }

  void _login() async {
    if (!_formKey.currentState!.validate()) {
      return;
    } else {
      loginController.login(
          emailController.text.trim(), passwordController.text.trim());
    }
  }
}

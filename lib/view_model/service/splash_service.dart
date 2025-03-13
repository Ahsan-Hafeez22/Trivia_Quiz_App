import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trivia_quiz_app/res/routes/routes_name.dart';
import 'package:trivia_quiz_app/view_model/service/session_controller.dart';

class SplashService {
  void isLogin(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    if (user != null) {
      // User is signed in, navigate to home page
      SessionController().uid = user.uid;
      Get.toNamed(RoutesName.homeView);
    } else {
      // User is not signed in, navigate to login page
      Get.toNamed(RoutesName.loginView);
    }
  }
}

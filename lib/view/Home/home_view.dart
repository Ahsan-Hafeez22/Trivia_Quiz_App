import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trivia_quiz_app/res/asset/image.dart';
import 'package:trivia_quiz_app/res/component/custom_button.dart';
import 'package:trivia_quiz_app/res/font/app_fonts.dart';
import 'package:trivia_quiz_app/res/routes/routes_name.dart';
import 'package:trivia_quiz_app/utils/utils.dart';
import 'package:trivia_quiz_app/view_model/service/auth_service.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final _auth = AuthService();
  User? user;
  @override
  void initState() {
    user = _auth.getCurrentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = _auth.getCurrentUser();
    return Scaffold(
        appBar: AppBar(
          // backgroundColor: Colors.,
          backgroundColor: Colors.black,
          title: Text(
            'Trivia Quiz App',
            style: AppFonts.bold24(),
          ),

          automaticallyImplyLeading: false,
          actions: [
            IconButton(
                onPressed: () {
                  Get.toNamed(RoutesName.editView);
                },
                icon: Icon(
                  Icons.edit,
                  color: Colors.white,
                )),
            IconButton(
                onPressed: () async {
                  Utils.showAlertBox(
                      context, "Alert", "Do you really want to Sign Out",
                      () async {
                    await _auth.signOut();
                    Utils.snackbarMessage(
                        'Sign out', 'User sign out successfully');
                    Get.offAllNamed(RoutesName.splashScreen);
                  }, primaryColor: Colors.blue);
                },
                icon: Icon(
                  Icons.logout,
                  color: Colors.white,
                )),
          ],
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFED213A),
                Color(0xFF93291E),
              ],
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SafeArea(
              child: Column(
                children: [
                  SizedBox(height: Get.height * 0.15),
                  Center(
                    child: Text(
                      'Welcome ${user!.displayName}',
                      style: AppFonts.bold24(),
                    ),
                  ),
                  Center(
                    child: Image.asset(
                      ImageAssets.homeLogo,
                      height: Get.height * 0.4,
                      width: Get.width * 0.6,
                      fit: BoxFit.cover,
                    ),
                  ),
                  CustomButton(
                      title: 'Start',
                      width: Get.width * 0.6,
                      onPress: () {
                        Get.toNamed(RoutesName.quizSelectionView);
                      })
                ],
              ),
            ),
          ),
        ));
  }
}

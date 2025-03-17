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
            icon: const Icon(
              Icons.edit,
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: () async {
              Get.toNamed(RoutesName.historyScreen);
            },
            icon: const Icon(
              Icons.history,
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: () async {
              Utils.showAlertBox(
                  context, "Alert", "Do you really want to Sign Out", () async {
                await _auth.signOut();
                Utils.snackbarMessage(
                    'Sign out', 'User signed out successfully');
                Get.offAllNamed(RoutesName.splashScreen);
              }, primaryColor: Colors.blue);
            },
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
          ),
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // SizedBox(height: Get.height * 0.02),

                // Profile Section
                // GestureDetector(
                // onTap: () => Get.toNamed(RoutesName.editView),
                //   child: Card(
                //     color: Colors.black,
                //     child: Padding(
                //       padding: const EdgeInsets.all(8.0),
                // child: Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     CircleAvatar(
                //       radius: 32,
                //       backgroundImage: user?.photoURL != null
                //           ? NetworkImage(user!.photoURL!)
                //           : const AssetImage(ImageAssets.avatar)
                //               as ImageProvider,
                //     ),
                //     const SizedBox(width: 16),
                //     Column(
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //       children: [
                //         Text(
                //           'Welcome, ${user?.displayName ?? "Guest"}!',
                //           style: AppFonts.bold18(),
                //         ),
                //         Text(
                //           user?.email ?? 'No email available',
                //           style: TextStyle(
                //               color: Colors.white70, fontSize: 12),
                //         ),
                //       ],
                //     ),
                //         ],
                //       ),
                //     ),
                //   ),
                // ),
                GestureDetector(
                  onTap: () => Get.toNamed(RoutesName.editView),
                  child: Container(
                    height: Get.height * 0.125,
                    width: double.infinity,
                    color: Colors.grey[700],
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 32,
                          backgroundColor: Colors.grey[700],
                          backgroundImage: user?.photoURL != null
                              ? NetworkImage(user!.photoURL!)
                              : const AssetImage(ImageAssets.avatar)
                                  as ImageProvider,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Flexible(
                                child: Text(
                                  user?.displayName ?? "Guest",
                                  style: AppFonts.bold18(),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines:
                                      1, // Ensures it truncates if too long
                                  softWrap: true,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Flexible(
                                child: Text(
                                  user?.email ?? 'No email available',
                                  style: const TextStyle(
                                      color: Colors.white70, fontSize: 12),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1, // Ensures email doesn't overflow
                                  softWrap: true,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Center(
                  child: Image.asset(
                    ImageAssets.homeLogo,
                    height: Get.height * 0.2,
                    width: Get.width * 0.3,
                    fit: BoxFit.cover,
                  ),
                ),

                Center(
                  child: Text(
                    'Choose a category to test your knowledge with an exciting quiz! Challenge yourself and see how much you know. Ready to begin?',
                    style: AppFonts.normal14(),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 0,
                  alignment: WrapAlignment.center,
                  children: [
                    _quizCategoryTile(
                        Icons.science, "Science & Nature", Colors.blue),
                    _quizCategoryTile(
                        Icons.computer, "General Knowledge", Colors.purple),
                    _quizCategoryTile(Icons.pets, "Animal", Colors.cyan),
                    _quizCategoryTile(Icons.sports, "Sport", Colors.green),
                    _quizCategoryTile(Icons.color_lens, "Art", Colors.cyan),
                    _quizCategoryTile(
                        Icons.car_repair_outlined, "Vehicles", Colors.orange),
                    _quizCategoryTile(Icons.movie, "Celebrities", Colors.red),
                  ],
                ),

                SizedBox(height: Get.height * 0.04),

                // Start Quiz Button
                CustomButton(
                  title: 'Start Now',
                  width: Get.width * 0.4,
                  buttonColor: Colors.white,
                  textColor: Colors.black,
                  onPress: () {
                    Get.toNamed(RoutesName.quizSelectionView);
                  },
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget for Quiz Categories
  Widget _quizCategoryTile(IconData icon, String title, Color color) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(RoutesName.quizSelectionView,
            arguments: {'category': title});
      },
      child: Chip(
        backgroundColor: color,
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 18),
            const SizedBox(width: 6),
            Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}

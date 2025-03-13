import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
import 'package:trivia_quiz_app/res/asset/image.dart';
import 'package:trivia_quiz_app/res/color/color.dart';
import 'package:trivia_quiz_app/res/component/custom_button.dart';
import 'package:trivia_quiz_app/res/component/text_field.dart';
import 'package:trivia_quiz_app/res/font/app_fonts.dart';
import 'package:trivia_quiz_app/res/routes/routes_name.dart';
import 'package:trivia_quiz_app/utils/form_validation.dart';
import 'package:trivia_quiz_app/view_model/service/auth_service.dart';

class EditUserScreen extends StatefulWidget {
  const EditUserScreen({super.key});

  @override
  State<EditUserScreen> createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final FocusNode focusNode1 = FocusNode();
  final FocusNode focusNode2 = FocusNode();
  final FocusNode focusNode3 = FocusNode();
  final FocusNode focusNode4 = FocusNode();
  final _formKey = GlobalKey<FormState>();
  final auth = AuthService();
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  // final ImagePicker _picker = ImagePicker();

  File? _selectedImage;
  String? profilePhotoUrl;

  @override
  void dispose() {
    super.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneNumberController.dispose();
  }

  void getUserData() {
    final user = auth.getCurrentUser();
    if (user != null) {
      firebaseFirestore
          .collection('users')
          .doc(user.uid)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          Map<String, dynamic> data =
              documentSnapshot.data() as Map<String, dynamic>;

          String fullName = data['name'] ?? '';
          List<String> nameParts = fullName.split(' ');
          String firstName = nameParts.isNotEmpty ? nameParts.first : '';
          String lastName =
              nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';
          log('Data received from the Firebase');
          setState(() {
            firstNameController.text = firstName;
            lastNameController.text = lastName;
            emailController.text = data['email'] ?? '';
            phoneNumberController.text = data['phone_number'] ?? '';
            profilePhotoUrl = data['profile_picture'] ?? '';
          });
        } else {
          log('Document does not exist on the database');
        }
      });
    }
  }

  Future<void> postDataToFireStore(
      String firstName, String lastName, String phoneNumber) async {
    if (_formKey.currentState!.validate()) {
      final user = auth.getCurrentUser();
      if (user != null) {
        try {
          await firebaseFirestore.collection('users').doc(user.uid).update({
            'name': '$firstName $lastName',
            'phone_number': phoneNumber,
            // if (profilePhotoUrl != null)
            //   'profile_picture': profilePhotoUrl, // Ensure this is updated,
          });
          await auth.updateUserProfile(
            fullName: '$firstName $lastName',
          );

          Get.snackbar("Success", "Profile updated successfully",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.green,
              colorText: Colors.white);
          Get.toNamed(RoutesName.homeView);
        } catch (e) {
          Get.snackbar("Error", e.toString(),
              backgroundColor: Colors.red, colorText: Colors.white);
        }
      }
    }
  }

  // Future<void> pickImage(ImageSource source) async {
  //   final pickedFile = await _picker.pickImage(source: source);
  //   if (pickedFile != null) {
  //     File imageFile = File(pickedFile.path);

  //     // Upload to Firebase Storage
  //     String downloadUrl = await uploadImageToFirebase(imageFile);

  //     setState(() {
  //       _selectedImage = imageFile;
  //       profilePhotoUrl = downloadUrl; // Store the new URL
  //     });
  //   } else {
  //     log("No image selected.");
  //   }
  // }

  // Future<String> uploadImageToFirebase(File imageFile) async {
  //   try {
  //     final user = auth.getCurrentUser();
  //     if (user == null) return '';

  //     String filePath = 'profile_pictures/${user.uid}.jpg';
  //     UploadTask uploadTask =
  //         FirebaseStorage.instance.ref().child(filePath).putFile(imageFile);

  //     TaskSnapshot snapshot = await uploadTask;
  //     return await snapshot.ref.getDownloadURL();
  //   } catch (e) {
  //     log("Error uploading image: $e");
  //     return '';
  //   }
  // }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFbdc3c7),
            Color(0xFF2c3e50),
          ],
        ),
      ),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(CupertinoIcons.back, color: Colors.white),
              onPressed: () => Get.back(),
            ),
            backgroundColor: Colors.black,
            title: Text('Edit Profile', style: AppFonts.bold24()),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.transparent,
                        radius: 50,
                        backgroundImage: _selectedImage != null
                            ? FileImage(_selectedImage!)
                            : (profilePhotoUrl != null &&
                                        profilePhotoUrl!.isNotEmpty
                                    ? NetworkImage(profilePhotoUrl!)
                                    : const AssetImage(ImageAssets.avatar))
                                as ImageProvider,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: IconButton(
                          onPressed: () {},
                          // => pickImage(ImageSource.gallery),
                          icon:
                              const Icon(Icons.camera_alt, color: Colors.white),
                          color: Colors.black54,
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: Get.height * 0.02),
                Text('Update your profile details below...',
                    style: AppFonts.normal16(color: Colors.black)),
                SizedBox(height: Get.height * 0.02),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      CustomTextField(
                        controller: firstNameController,
                        hintText: "First Name",
                        type: "name",
                        focusNode: focusNode1,
                        focusNode2: focusNode2,
                        validator: (value) => validateInput(value, 'name'),
                      ),
                      const SizedBox(height: 10),
                      CustomTextField(
                        controller: lastNameController,
                        hintText: "Last Name",
                        type: "name",
                        focusNode: focusNode2,
                        focusNode2: focusNode3,
                        validator: (value) => validateInput(value, 'name'),
                      ),
                      const SizedBox(height: 10),
                      CustomTextField(
                        controller: emailController,
                        hintText: "Email",
                        type: "email",
                        focusNode: focusNode3,
                        focusNode2: focusNode4,
                        validator: (value) => validateInput(value, 'email'),
                      ),
                      const SizedBox(height: 10),
                      CustomTextField(
                        controller: phoneNumberController,
                        hintText: "Phone Number",
                        type: "phone",
                        focusNode: focusNode4,
                        validator: (value) => validateInput(value, 'phone'),
                      ),
                      const SizedBox(height: 20),
                      CustomButton(
                        title: 'Update Profile',
                        onPress: () {
                          postDataToFireStore(
                              firstNameController.text.trim(),
                              lastNameController.text.trim(),
                              phoneNumberController.text.trim());
                        },
                        width: Get.width * 0.5,
                        buttonColor: AppColors.blue,
                        textColor: Colors.white,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:trivia_quiz_app/utils/utils.dart';
import 'package:trivia_quiz_app/view_model/controller/internet/internet_controller.dart';
import 'package:trivia_quiz_app/view_model/service/session_controller.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final internetController = Get.find<InternetController>();

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Create user with email and password
  Future<User?> createUserWithEmailAndPassword(
      String username, String email, String password) async {
    if (!internetController.hasInternet.value) {
      Utils.toastMessage('No internet connection');
      return null;
    }
    try {
      // Create the Firebase Auth user
      final credentials = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // If user is created successfully in Firebase Auth
      if (credentials.user != null) {
        await credentials.user!.reload();
        await credentials.user!.updateDisplayName(username);

        try {
          // Try to add user to Firestore
          await users.doc(credentials.user!.uid).set({
            'uid': credentials.user!.uid,
            'name': username,
            'email': credentials.user!.email,
            'online_status': '',
            'profile_picture': '',
            'phone_number': '',
            'provider': 'Email Address',
            'created_at': DateTime.now(),
          });
          log("User Added to Firestore");
        } catch (firestoreError) {
          // Log Firestore error but still return the user
          log("Failed to add user to Firestore: $firestoreError");
          Utils.toastMessage(
              "User created but profile data couldn't be saved. Please update your profile later.");
        }
        return credentials.user;
      }

      return null;
    } on FirebaseAuthException catch (e) {
      log("Error creating user: ${e.code}");
      Utils.snackbarMessage('Error', exceptionHandler(e.code.toString()));
      return null;
    } catch (e) {
      log("Error creating user: $e");
      Utils.snackbarMessage(
          'Error', "An unexpected error occurred. Please try again.");
      return null;
    }
  }

  // Login user with email and password
  Future<User?> loginUserWithEmailAndPassword(
      String email, String password) async {
    try {
      final credentials = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credentials.user;
    } on FirebaseAuthException catch (e) {
      log("Error login user: ${e.code}");
      Utils.snackbarMessage('Error', exceptionHandler(e.code));
    } catch (e) {
      log("Error login user: $e");
      Utils.snackbarMessage(
          'Error', "An unexpected error occurred. Please try again.");
    }
    return null;
  }

  // Sign out user
  // Future<void> signOut() async {
  //   try {
  //     await _auth.signOut();
  //   } catch (e) {
  //     log("Error logging out user: $e");
  //     Utils.snackbarMessage('Error', "Error signing out. Please try again.");
  //   }
  // }

  // Reset Password user
  Future<void> forgotPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      log("Error sending email to user: $e");
      Utils.snackbarMessage(
          'Error', "Error sending email to user. Please try again.");
    }
  }

  Future<User?> signInWithGoogle() async {
    if (!internetController.hasInternet.value) {
      Utils.toastMessage('No internet connection');
      return null;
    }
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null; // User canceled login

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      final User? user = userCredential.user;

      if (user != null) {
        await storeUserData(user);
      }

      return user;
    } catch (e) {
      log("Google Sign-In Error: $e");
      Utils.snackbarMessage("Error", "Google Sign-In failed. Try again.");
      return null;
    }
  }

  bool isUserSignedOut() {
    return FirebaseAuth.instance.currentUser == null;
  }

  void checkUserStatus() {
    if (isUserSignedOut()) {
      log("User is signed out");
    } else {
      log("User is signed in");
    }
  }

  // Logout user
  Future<void> signOut() async {
    try {
      User? user = _auth.currentUser;

      if (user != null) {
        for (UserInfo userInfo in user.providerData) {
          if (userInfo.providerId == 'google.com') {
            // If the user signed in using Google, sign out from Google
            await _googleSignIn.signOut();
            SessionController().uid = "";
            log("Successfully signed out from Google");
          }
        }

        // Sign out from Firebase (always needed)
        await _auth.signOut();
        SessionController().uid = "";

        log("Successfully signed out from Firebase");
      } else {
        log("No user is currently signed in.");
      }
    } catch (e) {
      log("Error logging out user: $e");
      Utils.snackbarMessage('Error', "Error signing out. Please try again.");
    }
  }

  Future<void> storeUserData(User user) async {
    final usersRef = FirebaseFirestore.instance.collection('users');

    final doc = await usersRef.doc(user.uid).get();

    if (!doc.exists) {
      await usersRef.doc(user.uid).set({
        'uid': user.uid,
        'name': user.displayName ?? "",
        'email': user.email,
        'profile_picture': user.photoURL ?? "",
        'online_status': 'online',
        'phone_number': '',
        'created_at': DateTime.now(),
        'provider': 'Google'
      });
      log("Successfull sign in with google => User Added to Firestore");
    }
  }

  Future<void> updateUserProfile(
      {String? fullName, String? photoURL, String? phoneNumber}) async {
    // final usersRef = FirebaseFirestore.instance.collection('users');
    final user = getCurrentUser();
    if (user == null) return;
    // final doc = await usersRef.doc(user.uid).get();
    if (fullName != null) await user.updateDisplayName(fullName);
    // if (photoURL != null) await user.updatePhotoURL(photoURL);
// user.updatePhoneNumber(phoneNumber);
    // if (!doc.exists) {
    //   Map<String, dynamic> updateData = {
    //     'name': fullName,
    //     'profile_picture': photoURL,
    //   };
    //   if (phoneNumber != null) updateData['phone_number'] = phoneNumber;

    //   if (doc.exists) {
    //     await usersRef.doc(user.uid).update(updateData);
    //   } else {
    //     await usersRef.doc(user.uid).set(updateData);
    //     log("User added to Firestore.");
    //   }

    //   log("User profile updated successfully.");
    // }
  }
}

// Error handler function
String exceptionHandler(String code) {
  switch (code) {
    case 'email-already-in-use':
      return 'This email is already registered. Please use a different email or try logging in.';
    case 'invalid-email':
      return 'The email address is not valid. Please enter a valid email.';
    case 'weak-password':
      return 'Password is too weak. Please use a stronger password with at least 6 characters.';
    case 'user-disabled':
      return 'This user account has been disabled. Please contact support.';
    case 'user-not-found':
      return 'No user found with this email. Please check your email or create an account.';
    case 'wrong-password':
      return 'Incorrect password. Please try again or reset your password.';
    case 'invalid-credential':
    case 'invalid-credentials':
      return 'Invalid login credentials. Please check your email and password.';
    case 'operation-not-allowed':
      return 'This operation is not allowed. Please contact support.';
    case 'account-exists-with-different-credential':
      return 'An account already exists with the same email but different sign-in credentials.';
    case 'too-many-requests':
      return 'Too many failed login attempts. Please try again later or reset your password.';
    case 'network-request-failed':
      return 'Network error. Please check your internet connection and try again.';
    case 'requires-recent-login':
      return 'This operation requires recent authentication. Please log in again before retrying.';
    default:
      return 'An error occurred: $code. Please try again.';
  }
}

// Auth state wrapper to use in your main app
// class AuthStateWrapper extends StatelessWidget {
//   final Widget loadingWidget;
//   final Widget loginWidget;
//   final Widget homeWidget;

//   const AuthStateWrapper({
//     Key? key,
//     required this.loadingWidget,
//     required this.loginWidget,
//     required this.homeWidget,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final authService = AuthService();

//     return StreamBuilder<User?>(
//       stream: authService.authStateChanges,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return loadingWidget;
//         }

//         if (snapshot.hasData && snapshot.data != null) {
//           // User is logged in
//           return homeWidget;
//         }

//         // User is not logged in
//         return loginWidget;
//       },
//     );
//   }
// }

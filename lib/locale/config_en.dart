import 'package:trivia_quiz_app/constants/config/config_keys_body.dart';
import 'package:trivia_quiz_app/constants/config/config_keys_title.dart';

const configEn = {
  ConfigKeysTitle.loginScreen: {
    ConfigKeysBody.loginTitle: "Login",
    ConfigKeysBody.loginSubtitle: "Welcome Back!",
    ConfigKeysBody.loginSubtitleText:
        "Log in to continue your quiz journey and test your knowledge.!",
    ConfigKeysBody.loginEmailHint: "Email",
    ConfigKeysBody.loginPasswordHint: "Password",
    ConfigKeysBody.loginForgotPassword: "Forgot Password?",
    ConfigKeysBody.loginButtonText: "Login",
    ConfigKeysBody.loginAccountText: "Don't have an account",
    ConfigKeysBody.loginRegisterText: "Register Now!",
    ConfigKeysBody.loginGoogleText: "Continue with Google",
  },
  ConfigKeysTitle.registerScreen: {
    ConfigKeysBody.registerTitle: "Register Now!",
    ConfigKeysBody.registerSubtitleText:
        "Register yourself to continue your quiz journey and test your knowledge.",
    ConfigKeysBody.registerNameHint: "Name",
    ConfigKeysBody.registerEmailHint: "Email",
    ConfigKeysBody.registerPasswordHint: "Password",
    ConfigKeysBody.registerConfirmPasswordHint: "Confirm Password",
    ConfigKeysBody.registerButtonText: "Register",
    ConfigKeysBody.registerLoginText: "Login Now!",
    ConfigKeysBody.registerAccountText: "Already have an account",
  },
  ConfigKeysTitle.forgotPasswordScreen: {
    ConfigKeysBody.forgotPasswordTitle: "Forgot Password",
    ConfigKeysBody.forgotPasswordSubtitle:
        "A link will be sent to your email address where you can change your password.",
    ConfigKeysBody.forgotPasswordEmailHint: "Email",
    ConfigKeysBody.forgotPasswordButtonText: "Recover",
  }
};

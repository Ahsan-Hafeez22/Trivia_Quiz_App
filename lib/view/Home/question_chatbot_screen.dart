import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trivia_quiz_app/res/font/app_fonts.dart';

class QuestionChatBotScreen extends StatefulWidget {
  const QuestionChatBotScreen({super.key});

  @override
  State<QuestionChatBotScreen> createState() => _QuestionChatBotScreenState();
}

class _QuestionChatBotScreenState extends State<QuestionChatBotScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          "Questions Information",
          style: AppFonts.bold24(),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            CupertinoIcons.back,
            color: Colors.white,
          ),
        ),
      ),
      body: Center(
        child: Text('Question'),
      ),
    );
  }
}

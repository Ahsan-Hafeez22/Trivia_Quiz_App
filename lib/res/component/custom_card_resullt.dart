import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:trivia_quiz_app/res/font/app_fonts.dart';

Card customResultCard({
  required BuildContext context,
  required double scorePercentage,
  required int correctAnswerCount,
  required int incorrectAnswerCount,
  required int totalQuestionCount,
  Timestamp? dateTime, // Nullable parameter
  double? textSize = 32,
  double? width = 150,
  double? height = 150,
}) {
  // Use current date-time if `dateTime` is null
  DateTime dt = dateTime?.toDate() ?? DateTime.now();

  // Format date and time
  String formattedDate = DateFormat('EEEE, MMM dd, yyyy').format(dt);
  String formattedTime = DateFormat('hh:mm a').format(dt);

  return Card(
    color: Colors.grey[100],
    elevation: 4,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Text(
            '$formattedDate $formattedTime',
            style: AppFonts.light12(color: Colors.black),
          ),
          Text(
            "Quiz Results",
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          SizedBox(height: Get.height * 0.04),

          // Score circle
          Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _getScoreColor(scorePercentage),
              boxShadow: [
                BoxShadow(
                  color: _getScoreColor(scorePercentage).withOpacity(0.5),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Center(
              child: Text(
                "${scorePercentage.toStringAsFixed(0)}%",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: textSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Score details
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _scoreItem(context, Icons.check_circle_outline, Colors.green,
                  correctAnswerCount.toString(), "Correct"),
              _scoreItem(context, Icons.cancel_outlined, Colors.red,
                  incorrectAnswerCount.toString(), "Incorrect"),
              _scoreItem(context, Icons.question_answer_outlined, Colors.blue,
                  totalQuestionCount.toString(), "Total"),
            ],
          ),
        ],
      ),
    ),
  );
}

Widget _scoreItem(BuildContext context, IconData icon, Color color,
    String value, String label) {
  return Column(
    children: [
      Icon(icon, color: color, size: 32),
      SizedBox(height: Get.height * 0.02),
      Text(
        value,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      Text(
        label,
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 14,
        ),
      ),
    ],
  );
}

Color _getScoreColor(double percentage) {
  if (percentage >= 80) {
    return Colors.green;
  } else if (percentage >= 60) {
    return Colors.blue;
  } else if (percentage >= 40) {
    return Colors.orange;
  } else {
    return Colors.red;
  }
}

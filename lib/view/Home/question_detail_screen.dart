import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:trivia_quiz_app/model/quiz_model.dart';
import 'package:trivia_quiz_app/res/font/app_fonts.dart';
import 'package:trivia_quiz_app/res/routes/routes_name.dart';

class QuestionsDetailScreen extends StatefulWidget {
  const QuestionsDetailScreen({super.key});

  @override
  QuestionsDetailScreenState createState() => QuestionsDetailScreenState();
}

class QuestionsDetailScreenState extends State<QuestionsDetailScreen> {
  List<dynamic> resultList = [];
  var unescape = HtmlUnescape();

  @override
  void initState() {
    super.initState();
    final Map<String, dynamic>? arguments = Get.arguments;
    if (arguments != null && arguments.containsKey('resultList')) {
      resultList = (arguments['resultList'] as List<Result>).map((item) {
        return {
          'category': unescape.convert(item.category),
          'question': unescape.convert(item.question),
          'correctAnswer': unescape.convert(item.correctAnswer),
          'incorrectAnswers': List<String>.from(item.incorrectAnswers),
          'difficulty': item.difficulty.toString().split('.').last,
        };
      }).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          "Questions & Answers",
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
      body: resultList.isEmpty
          ? const Center(child: Text("No questions available"))
          : ListView.builder(
              itemCount: resultList.length,
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, index) {
                final item = resultList[index];

                final String category = item['category'];
                final String question = item['question'];
                final String correctAnswer = item['correctAnswer'];
                final List<String> incorrectAnswers = item['incorrectAnswers'];
                final String difficultyStr = item['difficulty'];

                final List<String> allAnswers = [
                  ...incorrectAnswers,
                  correctAnswer
                ];
                allAnswers.sort();

                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: _getDifficultyColor(difficultyStr),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                difficultyStr.toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Text(
                              category,
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 16,
                                fontStyle: FontStyle.italic,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            GestureDetector(
                              onTap: () =>
                                  Get.toNamed(RoutesName.questionChatBotScreen),
                              child: Icon(
                                Icons.screen_search_desktop_outlined,
                                color: Colors.green,
                                size: 30,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "Q${index + 1}: $question",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Divider(),
                        const SizedBox(height: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Answers:",
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(height: 8),
                            ...allAnswers.map((answer) => Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Row(
                                    children: [
                                      Icon(
                                        answer == correctAnswer
                                            ? Icons.check_circle
                                            : Icons.circle_outlined,
                                        color: answer == correctAnswer
                                            ? Colors.green
                                            : Colors.grey,
                                        size: 18,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          unescape.convert(answer),
                                          style: TextStyle(
                                            color: answer == correctAnswer
                                                ? Colors.green
                                                : Colors.black,
                                            fontWeight: answer == correctAnswer
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return Colors.green;
      case 'medium':
        return Colors.orange;
      case 'hard':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }
}

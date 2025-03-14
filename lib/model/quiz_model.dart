// ignore_for_file: constant_identifier_names

import 'dart:convert';

// Function to parse JSON
QuizModel quizModelFromJson(Map<String, dynamic> json) =>
    QuizModel.fromJson(json);

String quizModelToJson(QuizModel data) => json.encode(data.toJson());

class QuizModel {
  int responseCode;
  List<Result> results;

  QuizModel({
    required this.responseCode,
    required this.results,
  });

  factory QuizModel.fromJson(Map<String, dynamic> json) => QuizModel(
        responseCode: json["response_code"] ?? 0, // Default to 0 if null
        results: json["results"] != null
            ? List<Result>.from(json["results"].map((x) => Result.fromJson(x)))
            : [], // Return empty list if null
      );

  Map<String, dynamic> toJson() => {
        "response_code": responseCode,
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
      };
}

class Result {
  Type type;
  Difficulty difficulty;
  String category;
  String question;
  String correctAnswer;
  List<String> incorrectAnswers;

  Result({
    required this.type,
    required this.difficulty,
    required this.category,
    required this.question,
    required this.correctAnswer,
    required this.incorrectAnswers,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        type: typeValues.map[json["type"]] ?? Type.MULTIPLE,
        difficulty:
            difficultyValues.map[json["difficulty"]] ?? Difficulty.MEDIUM,
        category: json["category"] ?? "Unknown",
        question: json["question"] ?? "No Question",
        correctAnswer: json["correct_answer"] ?? "Unknown",
        incorrectAnswers: json["incorrect_answers"] != null
            ? List<String>.from(json["incorrect_answers"].map((x) => x))
            : [],
      );

  Map<String, dynamic> toJson() => {
        "type": typeValues.reverse[type],
        "difficulty": difficultyValues.reverse[difficulty],
        "category": category,
        "question": question,
        "correct_answer": correctAnswer,
        "incorrect_answers": List<dynamic>.from(incorrectAnswers.map((x) => x)),
      };
}

// Enums with safe mapping
enum Difficulty { EASY, MEDIUM, HARD }

final difficultyValues = EnumValues({
  "easy": Difficulty.EASY,
  "medium": Difficulty.MEDIUM,
  "hard": Difficulty.HARD
});

enum Type { MULTIPLE, BOOLEAN }

final typeValues =
    EnumValues({"multiple": Type.MULTIPLE, "boolean": Type.BOOLEAN});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}

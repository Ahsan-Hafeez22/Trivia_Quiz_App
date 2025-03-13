class AppUrls {
  static String buildQuizApiUrl({
    required int amount,
    String? category,
    String? difficulty,
    String? type,
  }) {
    String baseUrl = "https://opentdb.com/api.php?amount=$amount";

    if (category != null && category != "Any Category") {
      baseUrl += "&category=${_getCategoryId(category)}";
    }
    if (difficulty != null && difficulty != "Any Difficulty") {
      baseUrl += "&difficulty=${difficulty.toLowerCase()}";
    }
    if (type != null && type != "Any Type") {
      baseUrl += "&type=${_getTypeValue(type)}";
    }

    return baseUrl;
  }
}

//helper methods:
Map<String, String> categoryMap = {
  'General Knowledge': '9',
  'Science & Nature': '17',
  'Animal': '27',
  'Sport': '21',
  'Art': '25',
  'Celebrities': '26',
  'Vehicles': '28',
};

String _getCategoryId(String category) {
  return categoryMap[category] ??
      "9"; // Default to 'General Knowledge' if not found
}

String _getTypeValue(String type) {
  return type == "True/False" ? "boolean" : "multiple";
}

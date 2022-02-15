import 'question.dart';

class QuestionBrain {
  final List<Question> _questionBank = [
    Question("f&s", "Fire & Safety",
        "1. Was the fire detection system free of alarms or signs of tampering?"),
    Question("f&s", "Fire & Safety",
        "2. What was the condition of the fire main and ancillaries such as pipework hydrants and valves?"),
    Question("lifesaving", "Lifesaving",
        "1. How many lifeboats is the vessel equipped with?"),
    Question("lifesaving", "Lifesaving",
        "2. What type of lifeboat is the vessel fitted with?"),
    Question("engine", "Engine Room",
        "1. Was the main engine in good working condition?"),
    Question("engine", "Engine Room",
        "2. What condition did the Main Engine appear to be in?")
  ];

  // Takes questionID from the user selection on the questionnaire hub and searches
  // for all questions in the question bank with a matching ID, to display them
  // in the questionnaire section.
  List<String> getQuestions(String questionID) {
    List<String> userQuestions = [];
    for (var question in _questionBank) {
      if (question.questionID == questionID) {
        userQuestions.add(question.questionText);
      }
    }
    return userQuestions;
  }

  String getPageTitle(String questionID) {
    String title = "Untitled";
    for (var question in _questionBank) {
      if (question.questionID == questionID) {
        title = question.questionTitle;
      }
    }
    print(title);
    return title;
  }
}

import 'question.dart';

class QuestionBrain {
  final List<Question> _questionBank = [
    Question(
        "f&s",
        "Fire & Safety",
        "1. Was the fire detection system free of alarms or signs of tampering?",
        false),
    Question(
        "f&s",
        "Fire & Safety",
        "2. What was the condition of the fire main and ancillaries such as pipework hydrants and valves?",
        false),
    Question("lifesaving", "Lifesaving",
        "1. How many lifeboats is the vessel equipped with?", false),
    Question("lifesaving", "Lifesaving",
        "2. What type of lifeboat is the vessel fitted with?", false),
    Question("engine", "Engine Room",
        "1. Was the main engine in good working condition?", false),
    Question("engine", "Engine Room",
        "2. What condition did the Main Engine appear to be in?", false)
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
    String title = "Idwal Vessel Inspection";
    for (var question in _questionBank) {
      if (question.questionID == questionID) {
        title = question.questionTitle;
      }
    }
    return title;
  }

  // Creates an integer based on the amount of questions per section.
  int getQuestionAmount(String questionID) {
    int questionAmount = 0;
    for (var question in _questionBank) {
      if (question.questionID == questionID) {
        questionAmount++;
      }
    }
    return questionAmount;
  }

  //Returns the amount of questions that have been answered per section.
  int getAnswerAmount(String questionID) {
    int answerAmount = 0;
    for (var question in _questionBank) {
      if (question.questionID == questionID && question.answered == true) {
        answerAmount++;
      }
    }
    return answerAmount;
  }

  // Allows for questions to be added to the question bank.
  void addQuestionToBank(String questionID, String questionTitle,
      String questionText, bool answered) {
    _questionBank
        .add(Question(questionID, questionTitle, questionText, answered));
  }

  // Returns the current percentage of question completion for use on the home screen.
  double questionPercentage(String questionID) {
    return getAnswerAmount(questionID) / getQuestionAmount(questionID);
  }
}

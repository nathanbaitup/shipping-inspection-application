import 'package:flutter_test/flutter_test.dart';
import 'package:shipping_inspection_app/sectors/questions/question_brain.dart';

QuestionBrain questionBrain = QuestionBrain();

void main() {
  // Tests that the question list is correctly populated based off the questionID.
  group('Question List Retrievals', () {
    test("Should retrieve 0 questions", () {
      final List<String> questions = questionBrain.getQuestions('random');

      expect(questions.length, 0);
    });

    test(
        "Should retrieve 2 lifesaving questions with the second questions matching",
        () {
      final List<String> questions = questionBrain.getQuestions('lifesaving');
      const String testQuestion =
          "2. What type of lifeboat is the vessel fitted with?";
      expect(questions.length, 2);
      expect(questions[1], testQuestion);
    });
  });

  // Tests that for a questionID input, the correct page title is returned to be displayed
  // and if an incorrect ID is given, it defaults to Idwal Vessel Inspection.
  group('Page Title Retrieval', () {
    test("Should retrieve Engine Room as title", () {
      final String title = questionBrain.getPageTitle('engine');
      expect(title, 'Engine Room');
    });

    test("Should retrieve default title of Idwal Shipping", () {
      final String title = questionBrain.getPageTitle('random');
      expect(title, 'Idwal Vessel Inspection');
    });
  });

  // Tests that the total number of questions from the question bank can be queried.
  group('Question amount retrievals', () {
    test("Should retrieve amount of 2 from f&s section", () {
      var amount = questionBrain.getQuestionAmount('f&s');
      expect(amount, '2');
    });
  });

  // Tests that questions can be added to the question bank, and checks that
  // the total amount of questions that have been answered can be queried.
  group('Adding a question to the question bank', () {
    test("Should add question section with ID addQTest to the question bank",
        () {
      questionBrain.addQuestionToBank(
          'addQTest', 'Question Title', 'test question 1', false);
      final List<String> questions = questionBrain.getQuestions('addQTest');
      expect(questions.length, 1);
    });

    test(
        "Should add 4 questions with ID idwalNewQ to the question bank, and find 4 unanswered questions.",
        () {
      questionBrain.addQuestionToBank(
          'idwalNewQ', 'Question Title', 'test question 1', false);
      questionBrain.addQuestionToBank(
          'idwalNewQ', 'Question Title', 'test question 2', false);
      questionBrain.addQuestionToBank(
          'idwalNewQ', 'Question Title', 'test question 3', false);
      questionBrain.addQuestionToBank(
          'idwalNewQ', 'Question Title', 'test question 4', false);

      final List<String> questions = questionBrain.getQuestions('idwalNewQ');
      expect(questions.length, 4);

      var unansweredQuestions = questionBrain.getQuestionAmount('idwalNewQ');
      expect(unansweredQuestions, '4');
    });

    test(
        "Should add 4 questions with ID answeredTest to the question bank, and find 4 total questions, 3 answered questions.",
        () {
      questionBrain.addQuestionToBank(
          'answeredTest', 'Question Title', 'test question 1', true);
      questionBrain.addQuestionToBank(
          'answeredTest', 'Question Title', 'test question 2', true);
      questionBrain.addQuestionToBank(
          'answeredTest', 'Question Title', 'test question 3', true);
      questionBrain.addQuestionToBank(
          'answeredTest', 'Question Title', 'test question 4', false);

      var unansweredQuestions = questionBrain.getQuestionAmount('answeredTest');
      expect(unansweredQuestions, '4');

      var answeredQuestions = questionBrain.getAnswerAmount('answeredTest');
      expect(answeredQuestions, '3');
    });
  });
}

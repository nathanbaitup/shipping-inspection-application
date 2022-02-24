import 'package:flutter_test/flutter_test.dart';
import 'package:shipping_inspection_app/sectors/questions/question.dart';
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

  group('Question amount retrievals', () {
    test("Should retrieve amount of 2 from f&s section", () {
      var amount = questionBrain.getQuestionAmount('f&s');
      expect(amount, '2');
    });
  });
}

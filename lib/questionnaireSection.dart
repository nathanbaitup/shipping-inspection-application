import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';

class QuestionnaireSection extends StatefulWidget {
  const QuestionnaireSection({Key? key}) : super(key: key);

  @override
  _QuestionnaireSectionState createState() => _QuestionnaireSectionState();
}

class _QuestionnaireSectionState extends State<QuestionnaireSection> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            const Text(
                "This section contains questions on the fire and safety inspection."),
            // Column specifically for adding the questions to the questionnaire.
            // Will be updated to work dynamically to get IDs of the questions and display
            // In the same page rather than a separate page for each question.
            Column(
              children: const <Widget>[
                Text("Questions:"),
              ],
            ),

            // REFERENCE ACCESSED 13/02/2022
            //Used for the flutter image slideshow widget.
            ImageSlideshow(
              width: double.infinity,
              height: 200.0,
              initialPage: 0,
              children: [
                Image.asset('images/f&s1.png'),
                Image.asset('images/f&s2.png'),
              ],
            ),
            // END REFERENCE

            //The buttons to take an image, view the question within AR and to save a surveyors answers.
            ElevatedButton(
              onPressed: () {},
              child: const Text('Add Images'),
            ),
            ElevatedButton(
              onPressed: () {},
              child: const Text('View in AR'),
            ),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Save Responses'),
            ),
          ],
        ),
      ),
    );
  }
}

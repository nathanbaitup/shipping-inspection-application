import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:shipping_inspection_app/utils/camera_screen.dart';

//TODO: 1. Get access to this page by parsing the page to load from the questionnaire hub page.
// TODO: 2. Based on the button press, parse in the key to display the corresponding questions.

class QuestionnaireSection extends StatefulWidget {
  const QuestionnaireSection({Key? key}) : super(key: key);

  @override
  _QuestionnaireSectionState createState() => _QuestionnaireSectionState();
}

class _QuestionnaireSectionState extends State<QuestionnaireSection> {
  //TODO: create a variable that updates the state based on if AR or camera button is pressed to update the camera view.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: <Widget>[
              const Center(
                child: Text(
                    "This section contains questions on the fire and safety inspection."),
              ),

              // Column specifically for adding the questions to the questionnaire.
              //TODO: Update to dynamic data
              // Will be updated to work dynamically to get IDs of the questions and display
              // In the same page rather than a separate page for each question.
              Column(
                children: const <Widget>[
                  Text(
                    "Questions:",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                      "1.Was the fire detection system free of alarms or signs of tampering?"),
                  SizedBox(height: 5),
                  Text(
                      "2.What was the condition of the fire main and ancillaries such as pipework hydrants and valves?"),
                ],
              ),

              const SizedBox(
                height: 50,
                width: 350,
                child: Divider(color: Colors.grey),
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
              const SizedBox(height: 20),

              //The buttons to take an image, view the question within AR and to save a surveyors answers.
              ElevatedButton(
                onPressed: () async {
                  //TODO: allow variable of what button has been pressed to be parsed into the camera screen to display the camera page layout.
                  await availableCameras().then(
                    (value) => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CameraScreen(
                          cameras: value,
                          buttonID: 'addImage',
                        ),
                      ),
                    ),
                  );
                },
                child: const Text('Add Images'),
              ),
              ElevatedButton(
                onPressed: () async {
                  //TODO: allow variable of what button has been pressed to be parsed into the camera screen to display the AR page layout.
                  await availableCameras().then(
                    (value) => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CameraScreen(
                          cameras: value,
                          buttonID: 'ar',
                        ),
                      ),
                    ),
                  );
                },
                child: const Text('View in AR'),
                style: ElevatedButton.styleFrom(primary: Colors.orangeAccent),
              ),
              ElevatedButton(
                onPressed: () {},
                child: const Text('Save Responses'),
                style: ElevatedButton.styleFrom(primary: Colors.green),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

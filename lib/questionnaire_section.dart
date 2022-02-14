import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:shipping_inspection_app/utils/camera_screen.dart';
import 'package:shipping_inspection_app/utils/questions/question_brain.dart';

QuestionBrain questionBrain = new QuestionBrain();

class QuestionnaireSection extends StatefulWidget {
  const QuestionnaireSection({Key? key}) : super(key: key);

  @override
  _QuestionnaireSectionState createState() => _QuestionnaireSectionState();
}

class _QuestionnaireSectionState extends State<QuestionnaireSection> {
  List<Image> imageViewer = [];
  List<String> questionsToAsk = [];
  List<Text> displayQuestions = [];

  // Uses the question brain to get all the questions needed to display on the page
  // and then creates a text widget for each question to be displayed.
  void addDisplayQuestions() {
    //TODO: change f&s from hardcoded to parsed in data, need questionnaire hub to do this.
    questionsToAsk = questionBrain.getQuestions('f&s');
    for (var question in questionsToAsk) {
      displayQuestions.add(Text(question));
    }
  }

  @override
  void initState() {
    super.initState();
    addDisplayQuestions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: <Widget>[
              const SizedBox(height: 20),
              const Center(
                child: Text(
                    "This section contains questions on the fire and safety inspection.",
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 20),

              // Column specifically for adding the questions to the questionnaire.
              const Text(
                "Questions:",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 5),
              Column(
                children: displayQuestions,
              ),
              const SizedBox(
                height: 70,
                width: 350,
                child: Divider(color: Colors.grey),
              ),

              if (imageViewer.isEmpty)
                const Text(
                    'No images are available, please capture an image to be displayed here.')
              else
                // REFERENCE ACCESSED 13/02/2022
                //Used for the flutter image slideshow widget.
                ImageSlideshow(
                  width: double.infinity,
                  height: 200.0,
                  initialPage: 0,
                  children: imageViewer,
                ),
              // END REFERENCE
              const SizedBox(height: 20),
              //The buttons to take an image, view the question within AR and to save a surveyors answers.
              ElevatedButton(
                onPressed: () async => await availableCameras().then(
                  (value) async {
                    final capturedImages = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CameraScreen(
                          cameras: value,
                          buttonID: 'addImage',
                        ),
                      ),
                    );
                    setState(() => imageViewer = imageViewer + capturedImages);
                  },
                ),
                child: const Text('Add Images'),
              ),
              ElevatedButton(
                onPressed: () async => await availableCameras().then(
                  (value) async {
                    final capturedImages = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CameraScreen(
                                cameras: value,
                                buttonID: 'ar',
                              )),
                    );
                    setState(() => imageViewer = imageViewer + capturedImages);
                  },
                ),
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

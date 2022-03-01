import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shipping_inspection_app/utils/camera_screen.dart';
import 'package:shipping_inspection_app/sectors/questions/question_brain.dart';
import 'package:shipping_inspection_app/utils/colours.dart';
import 'package:shipping_inspection_app/sectors/history/globals.dart'
    as globals;

import '../ar/ar_hub.dart';

QuestionBrain questionBrain = QuestionBrain();

class SurveySection extends StatefulWidget {
  final String questionID;
  const SurveySection({required this.questionID, Key? key}) : super(key: key);

  @override
  _SurveySectionState createState() => _SurveySectionState();
}

class _SurveySectionState extends State<SurveySection> {
  List<Image> imageViewer = [];
  List<String> questionsToAsk = [];
  List<Text> displayQuestions = [];
  String pageTitle = '';

  // Uses the question brain to get the page title and all the questions needed to display on the page
  // and then creates a text widget for each question to be displayed.
  void addDisplayQuestions() {
    pageTitle = questionBrain.getPageTitle(widget.questionID);
    questionsToAsk = questionBrain.getQuestions(widget.questionID);
    for (var question in questionsToAsk) {
      displayQuestions.add(Text(question));
    }
  }

  void addEnterRecord() {
    globals.addRecord("enter", "current", DateTime.now(), pageTitle);
  }

  // Initializes the state and gets the questions, page title and record for the history feature.
  @override
  void initState() {
    super.initState();
    addDisplayQuestions();
    addEnterRecord();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pageTitle),
        titleTextStyle: const TextStyle(color: LightColors.sPurple),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: Transform.scale(
          scale: 0.7,
          child: FloatingActionButton(
            onPressed: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: <Widget>[
              const SizedBox(height: 20),
              Center(
                child: Text(
                    "This section relates to the inspection of $pageTitle.",
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 20),

              // Column specifically for adding the questions to the survey.
              const Text(
                "Survey:",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 5),
              Center(
                child: Column(
                  children: displayQuestions,
                ),
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
                onPressed: () async {
                  if (await Permission.camera.status.isDenied) {
                    await Permission.camera.request();
                    debugPrint(
                        "Camera Permissions are required to access Camera.");
                  } else {
                    await availableCameras().then(
                      (value) async {
                        final capturedImages = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CameraScreen(
                              cameras: value,
                              buttonID: 'addImage',
                              questionID: widget.questionID,
                            ),
                          ),
                        );
                        setState(
                            () => imageViewer = imageViewer + capturedImages);
                      },
                    );
                  }
                },
                child: const Text('Add Images'),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (await Permission.camera.status.isDenied) {
                    await Permission.camera.request();
                    debugPrint(
                        "Camera Permissions are required to access QR Scanner");
                  } else {
                    await availableCameras().then(
                      (value) async {
                        final capturedImages = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ArHub(
                              questionID: widget.questionID,
                              openThroughQR: false,
                            ),
                          ),
                        );
                        setState(
                            () => imageViewer = imageViewer + capturedImages);
                      },
                    );
                  }
                },
                child: const Text('View in AR'),
                style: ElevatedButton.styleFrom(primary: LightColors.sPurpleL),
              ),
              ElevatedButton(
                onPressed: () {},
                child: const Text('Save Responses'),
                style: ElevatedButton.styleFrom(primary: LightColors.sPurpleLL),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

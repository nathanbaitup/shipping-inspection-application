import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shipping_inspection_app/utils/camera_screen.dart';
import 'package:shipping_inspection_app/sectors/questions/question_brain.dart';
import 'package:shipping_inspection_app/utils/colours.dart';
import '../drawer/drawer_globals.dart' as globals;

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
  List<Widget> displayQuestions = [];
  String pageTitle = '';

  // Initializes the state and gets the questions, page title and record for the history feature.
  @override
  void initState() {
    super.initState();
    addDisplayQuestions();
    addEnterRecord();
  }

  @override
  Widget build(BuildContext context) {
    // Gets the height and width of the current device.
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      // Sets up the app bar to take the user back to the previous page
      appBar: AppBar(
        title: const Text('Idwal Vessel Inspection'),
        titleTextStyle: const TextStyle(color: LightColors.sPurple),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: Transform.scale(
          scale: 0.7,
          child: FloatingActionButton(
            heroTag: 'on_back',
            onPressed: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back),
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: SafeArea(
          child: Column(
            children: <Widget>[
              // Creates a header with the page title.
              Container(
                height: screenHeight * 0.12,
                width: screenWidth,
                padding: const EdgeInsets.all(0.0),
                decoration: const BoxDecoration(
                  color: LightColors.sLavender,
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(30.0),
                    bottomLeft: Radius.circular(30.0),
                  ),
                ),
                // The page title.
                child: Center(
                  child: Text(
                    pageTitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 28,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Gives a description on the survey section.
              Center(
                child: Text(
                  "This section relates to the inspection of $pageTitle.",
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic),
                ),
              ),

              const SizedBox(height: 10),

              // Opens the survey section in an AR view.
              ElevatedButton(
                onPressed: () async => openARSection(),
                style:
                    ElevatedButton.styleFrom(primary: LightColors.sDarkYellow),
                child: const Text('Open section in AR'),
              ),

              const SizedBox(height: 20),

              // Allows rest of the display to be scrollable to be able to see and answer the questions,
              // add and save images.
              Container(
                height: screenHeight * 0.6,
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      // Displays the survey title and adds divided the title from the questions.
                      Column(
                        children: const <Widget>[
                          Text(
                            "Survey:",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                            width: 100,
                            child: Divider(
                              thickness: 1.5,
                              color: LightColors.sGreen,
                            ),
                          ),
                          SizedBox(height: 10),
                        ],
                      ),

                      // Displays the questions into the view.
                      Column(children: displayQuestions),
                      const SizedBox(
                        height: 70,
                        width: 350,
                        child: Divider(color: Colors.grey),
                      ),

                      // Sets a rounded box as default if there are no images taken
                      // else displays the image viewer.
                      if (imageViewer.isEmpty)
                        Container(
                          decoration: const BoxDecoration(
                            color: LightColors.sGrey,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          child: const SizedBox(
                            width: double.infinity,
                            height: 150,
                            child: Center(
                              child: Text(
                                "No images to display. Take an image to display here.",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic),
                              ),
                            ),
                          ),
                        )
                      else
                        // REFERENCE accessed 13/02/2022
                        // Used for the flutter image slideshow widget.
                        ImageSlideshow(
                          children: imageViewer,
                        ),
                      // END REFERENCE
                      const SizedBox(height: 20),
                      //The buttons to take an image, view the question within AR and to save a surveyors answers.
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          ElevatedButton(
                            onPressed: () async => openCamera(),
                            child: const Text('Add Images'),
                          ),
                          const SizedBox(width: 20),
                          ElevatedButton(
                            onPressed: () async => saveSurvey(),
                            child: const Text('Save Responses'),
                            style: ElevatedButton.styleFrom(
                                primary: Colors.lightGreen),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Uses the question brain to get the page title and all the questions needed to display on the page
  // and then creates a text widget for each question to be displayed.
  void addDisplayQuestions() {
    pageTitle = questionBrain.getPageTitle(widget.questionID);
    questionsToAsk = questionBrain.getQuestions(widget.questionID);

    for (var question in questionsToAsk) {
      displayQuestions.add(
        Column(
          children: <Widget>[
            // Creates a container for each question and the space to answer
            // a question.
            Container(
              margin: const EdgeInsets.all(10.0),
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(color: LightColors.sPurple),
                borderRadius: const BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
              child: Column(
                children: <Widget>[
                  // The question pulled from the question bank.
                  Text(
                    question,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  // The text field to allow a question to be answered.
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextField(
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }

  // Function that adds a record of what a user has pressed onto the history page.
  void addEnterRecord() {
    globals.addRecord(
        "enter", globals.getUsername(), DateTime.now(), pageTitle);
  }

  // Checks if the camera permission has been granted and opens the camera
  // capturing the images taken to show in the image viewer on return.
  void openCamera() async {
    if (await Permission.camera.status.isDenied) {
      await Permission.camera.request();
      debugPrint("Camera Permissions are required to access Camera.");
    } else {
      globals.addRecord(
          "opened", globals.getUsername(), DateTime.now(), 'camera');
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
          setState(() => imageViewer = imageViewer + capturedImages);
        },
      );
    }
  }

  // Checks if the camera permission has been granted and opens the AR hub for
  // the intended section loading the questions based on the current page to
  // display within the AR view.
  void openARSection() async {
    if (await Permission.camera.status.isDenied) {
      await Permission.camera.request();
      debugPrint("Camera Permissions are required to access QR Scanner");
    } else {
      globals.addRecord("opened", globals.getUsername(), DateTime.now(),
          '$pageTitle AR session through button press');
      await availableCameras().then(
        (value) async {
          List<String> arContentPush = [pageTitle] + questionsToAsk;
          final capturedImages = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ArHub(
                questionID: widget.questionID,
                arContent: arContentPush,
                openThroughQR: false,
              ),
            ),
          );
          setState(() => imageViewer = imageViewer + capturedImages);
        },
      );
    }
  }

  // Saves the images, and survey responses to the database.
  void saveSurvey() async {
    globals.addRecord("add", globals.getUsername(), DateTime.now(), pageTitle);

    // TODO: implement save functionality to save images and responses to database.
  }
}

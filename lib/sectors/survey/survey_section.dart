import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shipping_inspection_app/shared/loading.dart';
import 'package:shipping_inspection_app/utils/camera_screen.dart';
import 'package:shipping_inspection_app/sectors/questions/question_brain.dart';
import 'package:shipping_inspection_app/utils/colours.dart';
import '../ar/new_ar_hub.dart';
import '../drawer/drawer_globals.dart' as globals;

import '../questions/answers.dart';

// The question brain to load all the questions.
QuestionBrain questionBrain = QuestionBrain();
bool loading = false;

late String questionID;
List<String> questionsToAsk = [];
List<Answer> _answers = [];
List<Answer> answersList = [];

class SurveySection extends StatefulWidget {
  final String vesselID;
  final String questionID;
  final List<Image> capturedImages;
  const SurveySection(
      {required this.questionID,
      required this.capturedImages,
      required this.vesselID,
      Key? key})
      : super(key: key);

  @override
  _SurveySectionState createState() => _SurveySectionState();
}

class _SurveySectionState extends State<SurveySection> {
  List<Image> imageViewer = [];
  List<Widget> displayQuestions = [];
  String pageTitle = '';

  // Initializes the state and gets the questions, page title and record for the history feature.
  @override
  void initState() {
    _initializeSection();
    _getResultsFromFirestore();
    _addEnterRecord();
    _initializeImageViewer();
    super.initState();

    // pulls all results from firebase if there are any.
    //TODO: change this so that it also adds the text to the inputs when pulling information.
    // _getImagesFromFirebase();
  }

  @override
  Widget build(BuildContext context) {
    // Gets the height and width of the current device.
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    if (loading) {
      return const Scaffold(body: Loading());
    } else {
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
                  onPressed: () async => _openARSection(),
                  style: ElevatedButton.styleFrom(
                      primary: LightColors.sDarkYellow),
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

                        // For each question in the list of questions to ask, it
                        // adds the question to the view and if answered, adds the
                        // answer too.
                        Column(
                          children: [
                            for (var i = 0; i < questionsToAsk.length; i++)
                              DisplayQuestions(
                                  question: questionsToAsk[i], counter: i)
                          ],
                        ),
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
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
                              onPressed: () async => _openCamera(),
                              child: const Text('Add Images'),
                            ),
                            const SizedBox(width: 20),
                            ElevatedButton(
                              onPressed: () async => _saveSurvey(),
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
  }

  // Sets the section ID, page title and the questions relating to the section.
  void _initializeSection() {
    questionID = widget.questionID;
    pageTitle = questionBrain.getPageTitle(questionID);
    questionsToAsk = questionBrain.getQuestions(questionID);
    answersList = [];
  }

  // Sets up the image viewer so if images have been taken within the AR view,
  // they will be added to the image viewer.
  void _initializeImageViewer() {
    if (widget.capturedImages.isNotEmpty) {
      imageViewer = imageViewer + widget.capturedImages;
    }
  }

  // Function that adds a record of what a user has pressed onto the history page.
  void _addEnterRecord() {
    globals.addRecord(
        "enter", globals.getUsername(), DateTime.now(), pageTitle);
  }

  // Checks if the camera permission has been granted and opens the camera
  // capturing the images taken to show in the image viewer on return.
  void _openCamera() async {
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
                vesselID: widget.vesselID,
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
  void _openARSection() async {
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
              builder: (context) => NewARHub(
                vesselID: widget.vesselID,
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
  void _saveSurvey() async {
    globals.addRecord("add", globals.getUsername(), DateTime.now(), pageTitle);
    _saveResultsToFirestore();
    // TODO: implement save functionality to save AR images to cloud storage.
  }

  // Awaits for the Survey Responses collection and if it doesn't exist,
  // it creates the collection then adds the survey ID, questions and answers to
  // be stored and used in future app instances.
  void _saveResultsToFirestore() async {
    setState(() {
      loading = true;
    });
    try {
      for (var i = 0; i < _answers.length; i++) {
        await FirebaseFirestore.instance.collection('Survey_Responses').add({
          'sectionID': widget.questionID,
          'vesselID': widget.vesselID,
          'numberOfQuestions':
              questionBrain.getQuestionAmount(widget.questionID),
          'answeredQuestions': _answers.length,
          'question': _answers[i].question,
          'answer': _answers[i].answer,
          'timestamp': FieldValue.serverTimestamp()
        });
      }
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Data successfully saved.")));
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Unable to save data, please try again.")));
    }
    // Reloads the page by popping the current page from the navigator and
    // pushing it back into the context with the updated data.
    Navigator.pop(context);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SurveySection(
                questionID: questionID,
                capturedImages: imageViewer,
                vesselID: widget.vesselID)));
    setState(() {
      loading = false;
    });
  }

  // TODO: Check how many answers there are per question and only take the latest response from timestamp.
  // TODO: load images from firebase storage (another function required).
  Future<List<Answer>> _getResultsFromFirestore() async {
    setState(() {
      loading = true;
    });
    try {
      // Creates a instance reference to the Survey_Responses collection.
      CollectionReference reference =
          FirebaseFirestore.instance.collection('Survey_Responses');
      // Pulls all data where the vesselID and sectionID match.
      QuerySnapshot querySnapshot = await reference
          .where('vesselID', isEqualTo: widget.vesselID)
          .where('sectionID', isEqualTo: widget.questionID)
          .get();
      // Queries the snapshot to retrieve all questions and answers stored and
      // add them to answersList.
      setState(() {
        for (var document in querySnapshot.docs) {
          answersList.add(Answer(
            document['question'],
            document['answer'],
            document['sectionID'],
          ));
        }
      });
    } catch (error) {
      debugPrint("Error: $error");
    }
    setState(() {
      loading = false;
    });
    return answersList;
  }

  // Future<List<Image>> _getImagesFromFirebase() async {
  //   List<Image> imageViewer = [];
  //   try {
  //     final Reference storageRef =
  //         FirebaseStorage.instance.ref().child('images').child(widget.vesselID);
  //     storageRef.listAll().then((result) => {print('')});
  //   } catch (error) {
  //     debugPrint("Error: $error");
  //   }
  //   return imageViewer;
  // }
}

// TODO: update the order in which things are displayed so the question order is correct.
// Uses the question brain to get the page title and all the questions needed to display on the page
// and then creates a text widget for each question to be displayed.
class DisplayQuestions extends StatefulWidget {
  final String question;
  final int counter;
  const DisplayQuestions(
      {Key? key, required this.question, required this.counter})
      : super(key: key);

  @override
  _DisplayQuestionsState createState() => _DisplayQuestionsState();
}

class _DisplayQuestionsState extends State<DisplayQuestions> {
  @override
  void initState() {
    super.initState();
    _setupFocusNode();
    _answers = [];
    debugPrint('$answersList');
  }

  @override
  void dispose() {
    super.dispose();
    focusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
                widget.question,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              // The text field to allow a question to be answered.

              answersList.length > widget.counter &&
                      answersList[widget.counter].sectionID == questionID
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        readOnly: true,
                        initialValue: answersList[widget.counter].answer,
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        focusNode: focusNode,
                        onChanged: (String value) {
                          setState(() {
                            questionText = widget.question;
                            answer = value;
                          });
                        },
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ],
    );
  }

  // Retrieve the user input for answering a question.
  FocusNode focusNode = FocusNode();
  String questionText = '';
  String answer = '';

  // Creates a focus node that checks if focus has been lost on a text field to
  // add the user value to the answers list.
  void _setupFocusNode() {
    focusNode.addListener(() {
      if (!focusNode.hasFocus) {
        setState(() {
          _answers.removeWhere((value) => value.question == questionText);
          _answers.add(Answer(questionText, answer, questionID));
        });
      }
    });
  }
}

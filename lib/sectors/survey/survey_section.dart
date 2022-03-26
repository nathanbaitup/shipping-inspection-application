import 'package:flutter/material.dart';

// Third Party dependencies.
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:camera/camera.dart';

// Package dependencies.
import 'package:shipping_inspection_app/shared/loading.dart';
import 'package:shipping_inspection_app/sectors/camera/camera_screen.dart';
import 'package:shipping_inspection_app/sectors/questions/question_brain.dart';
import 'package:shipping_inspection_app/utils/colours.dart';
import 'package:shipping_inspection_app/sectors/ar/new_ar_hub.dart';
import 'package:shipping_inspection_app/sectors/questions/answers.dart';
import '../ar/ar_onboarding_screen.dart';
import '../drawer/drawer_globals.dart' as globals;

// The question brain to load all the questions.
QuestionBrain questionBrain = QuestionBrain();
// Updates the state to a loading indicator if set to true.
bool loading = false;
// The section ID.
late String questionID;
// The questions relating to a specific section.
List<String> _questionsToAnswer = [];
// The answer responses from the survey containing the question and answer.
List<Answer> _answers = [];
// The retrieved answers from firebase to be displayed if there are responses.
List<Answer> answersList = [];

class SurveySection extends StatefulWidget {
  final String vesselID;
  // Images that have been taken within the AR view. This can be removed once AR screenshots can be saved to firebase.
  final List<Image> capturedImages;
  final String questionID;
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
  // List of all images to display.
  List<Image> imageViewer = [];
  String pageTitle = '';

  // Initializes the state and gets the questions, page title and record for the history feature.
  @override
  void initState() {
    _initializeSection();
    // Pulls both text and images from Firebase.
    _getImagesFromFirebase();
    _getResultsFromFirestore();
    // Adds a record of the user history.
    _addEnterRecord();
    // Sets up the image viewer. Can be removed one images can be saved from AR into firebase.
    _initializeImageViewer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Gets the height and width of the current device.
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // If loading is required, then return the loading page.
    if (loading) {
      return const Scaffold(body: Loading());
    } else {
      return Scaffold(
        // Sets up the app bar to take the user back to the previous page
        appBar: AppBar(
          title: const Text('Idwal Vessel Inspection'),
          backgroundColor: Colors.white,
          titleTextStyle: const TextStyle(color: LightColors.sPurple),
          centerTitle: true,
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
                        // Displays the survey title and adds a divider to the title from the questions.
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

                        // For each question in the list of questions to answer, it
                        // adds the question to the view and if answered, adds the
                        // answer too.
                        Column(
                          children: [
                            for (var i = 0; i < _questionsToAnswer.length; i++)
                              DisplayQuestions(
                                  question: _questionsToAnswer[i], counter: i)
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
                              style: ElevatedButton.styleFrom(
                                  primary: LightColors.sPurpleL),
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
    _questionsToAnswer = questionBrain.getQuestions(questionID);
    // Resets the answers list to empty.
    answersList = [];
  }

  // Sets up the image viewer so if images have been taken within the AR view,
  // they will be added to the image viewer.
  // Can be removed once AR images save to firebase.
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
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CameraScreen(
                cameras: value,
                questionID: widget.questionID,
                vesselID: widget.vesselID,
              ),
            ),
          );
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
          List<String> arContentPush = [pageTitle] + _questionsToAnswer;
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
          'questionNumber': _answers[i].questionNumber,
          'timestamp': FieldValue.serverTimestamp()
        });
      }
      setState(() {
        loading = false;
      });
      // Creates a toast to say save successful.
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Data successfully saved.")));
    } catch (error) {
      // Creates a toast to say that data cannot be saved.
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
            vesselID: widget.vesselID),
      ),
    );
    setState(() {
      loading = false;
    });
  }

  // Gets results of a survey based on the current vesselID and sectionID to
  // display the answer to the question within the survey section.
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
      for (var document in querySnapshot.docs) {
        answersList.add(Answer(
          document['question'],
          document['answer'],
          document['sectionID'],
          document['questionNumber'],
        ));
      }
      setState(() {
        // REFERENCE accessed 20/03/2022 https://stackoverflow.com/a/53549197
        // Used to sort the list by the question number to ensure questions and
        // answers are displayed in order.
        answersList
            .sort((a, b) => a.questionNumber.compareTo(b.questionNumber));
        // END REFERENCE
      });
    } catch (error) {
      debugPrint("Error: $error");
    }
    setState(() {
      loading = false;
    });
    // returns the answer list.
    return answersList;
  }

  // Creates a reference to firebase storage using the current vesselID and sectionID
  // and gets a list of all the images stored. Calls function _addToImageViewer
  // to add all stored images to the image viewer.
  void _getImagesFromFirebase() async {
    setState(() {
      loading = true;
    });
    try {
      final Reference storageRef = FirebaseStorage.instance
          .ref('images/${widget.vesselID}/${widget.questionID}');
      // REFERENCE accessed 20/03/2022 https://stackoverflow.com/a/56402109
      // Used to list all the images within the correct folder.
      storageRef.listAll().then((result) => {
            for (var imageRef in result.items) {_addToImageViewer(imageRef)}
          });
      // END REFERENCE
    } catch (error) {
      debugPrint("Error: $error");
      setState(() {
        loading = false;
      });
    }
    setState(() {
      loading = false;
    });
  }

  // Gets the URL of an image from Firebase and then adds the image to the imageViewer list.
  // Is called in _getImagesFromFirebase().
  Future<List<Image>> _addToImageViewer(imageRef) async {
    imageRef.getDownloadURL().then((url) {
      setState(() {
        imageViewer.add(
          Image.network(url),
        );
      });
    });
    return imageViewer;
  }
}

// Uses the question brain to get the page title and all the questions needed to display on the page
// and then creates a text widget for each question to be displayed.
class DisplayQuestions extends StatefulWidget {
  // The question to be displayed in a widget.
  final String question;
  // A counter to increment over what question to display.
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
    // Resets the answers list.
    _answers = [];
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

              // Checks if the answersList is greater than the counter and
              // if the sectionID's match to display the stored answer within the
              // text field and set it to read only, else displays an empty text field.
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
                            // Gets the question number from the question.
                            questionNumber =
                                int.parse(widget.question.split('.')[0]);
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
  int questionNumber = 0;

  // Creates a focus node that checks if focus has been lost on a text field to
  // add the user value to the answers list.
  void _setupFocusNode() {
    focusNode.addListener(() {
      if (!focusNode.hasFocus) {
        setState(() {
          // Removes the answer from the answer list if a user updates the value
          // and adds the new value.
          _answers.removeWhere((value) => value.question == questionText);
          _answers
              .add(Answer(questionText, answer, questionID, questionNumber));
        });
      }
    });
  }
}

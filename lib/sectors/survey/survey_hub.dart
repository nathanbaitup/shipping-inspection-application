import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shipping_inspection_app/sectors/drawer/drawer_help.dart';
import 'package:shipping_inspection_app/sectors/questions/question_brain.dart';
import 'package:shipping_inspection_app/sectors/questions/question_totals.dart';
import 'package:shipping_inspection_app/sectors/survey/survey_section.dart';
import 'package:shipping_inspection_app/utils/app_colours.dart';
import '../drawer/drawer_globals.dart' as app_globals;

import '../camera/qr_scanner_controller.dart';

QuestionBrain questionBrain = QuestionBrain();

late String vesselID;

class SurveyHub extends StatefulWidget {
  final String vesselID;
  const SurveyHub({Key? key, required this.vesselID}) : super(key: key);

  @override
  _SurveyHubState createState() => _SurveyHubState();
}

class _SurveyHubState extends State<SurveyHub> {
  @override
  void initState() {
    super.initState();
    vesselID = widget.vesselID;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: SafeArea(
            child: Center(
              child: Column(
                children: <Widget>[
                  Container(
                      height: screenHeight * 0.12,
                      width: screenWidth,
                      padding: const EdgeInsets.all(0.0),
                      decoration: const BoxDecoration(
                          color: AppColours.appLavender,
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(30.0),
                            bottomLeft: Radius.circular(30.0),
                          )),
                      child: const Center(
                        child: Text(
                          "AR Hub",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 28,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )),
                  Container(
                    height: screenHeight * 0.12,
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10.0),
                          decoration: const BoxDecoration(
                            color: AppColours.appPurple,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          child: const Text(
                            "QR Camera",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            primary: Colors.white,
                            backgroundColor: AppColours.appYellow,
                            elevation: 2,
                            shape: const CircleBorder(),
                          ),
                          child: const Text(
                            "?",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MenuHelp(),
                              ),
                            );
                          },
                        ),
                        const Spacer(),
                        SizedBox(
                          width: screenWidth * 0.35,
                          child: TextButton(
                              style: TextButton.styleFrom(
                                primary: Colors.white,
                                backgroundColor: AppColours.appPurpleLighter,
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0)),
                              ),
                              child: const Text(
                                "Open QR Camera",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              onPressed: () async => openCamera()),
                        ),
                      ],
                    ),
                  ),
                  const Divider(
                    thickness: 1,
                    height: 1,
                  ),
                  Container(
                    height: screenHeight * 0.12,
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10.0),
                          decoration: const BoxDecoration(
                            color: AppColours.appPurple,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          child: const Text(
                            "Sections",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            primary: Colors.white,
                            backgroundColor: AppColours.appYellow,
                            elevation: 2,
                            shape: const CircleBorder(),
                          ),
                          child: const Text(
                            "?",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MenuHelp(),
                              ),
                            );
                          },
                        ),
                        Expanded(
                            child: SizedBox(
                          height: 35,
                          child: TextFormField(
                              decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: const BorderSide(
                                        color: Colors.grey, width: 1.5),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  prefixIcon: const Icon(
                                    Icons.search,
                                    size: 20,
                                  ),
                                  hintText: "Search",
                                  contentPadding: EdgeInsets.zero),
                              style: const TextStyle(
                                fontSize: 14,
                              )),
                        ))
                      ],
                    ),
                  ),
                  Container(
                    height: screenHeight * 0.45,
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: const [
                          SurveySectionWidget(
                              sectionName: "Fire & Safety",
                              sectionMethod: "f&s"),
                          SurveySectionWidget(
                              sectionName: "Lifesaving",
                              sectionMethod: "lifesaving"),
                          SurveySectionWidget(
                              sectionName: "Engine Room",
                              sectionMethod: "engine"),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  // Checks if camera permissions have been granted and takes the user to the QR
  // camera, updating the history page to allow for tracking.
  void openCamera() async {
    if (await Permission.camera.status.isDenied) {
      await Permission.camera.request();
      debugPrint("Camera Permissions are required to access QR Scanner");
    } else {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => QRScanner(
            vesselID: vesselID,
          ),
        ),
      );
      // Adds a record of the QR camera being opened to the history page.
      app_globals.addRecord(
          'opened', app_globals.getUsername(), DateTime.now(), 'QR camera');
      await FirebaseFirestore.instance
          .collection("History_Logging")
          .add({
            'title': "Opening QR camera",
            'username': app_globals.getUsername(),
            'time': DateTime.now(),
            'permission': "QR camera",
          })
          .then((value) => debugPrint("Record has been added"))
          .catchError((error) => debugPrint("Failed to add record: $error"));
    }
  }
}

class SurveySectionWidget extends StatefulWidget {
  final String sectionName;
  final String sectionMethod;

  const SurveySectionWidget(
      {Key? key, required this.sectionName, required this.sectionMethod})
      : super(key: key);

  @override
  _SurveySectionWidgetState createState() => _SurveySectionWidgetState();
}

class _SurveySectionWidgetState extends State<SurveySectionWidget> {
  // A list to store the total amount and answered amount of questions.
  List<QuestionTotals> questionTotals = [];
  int numberOfQuestions = 0;
  int answeredQuestions = 0;

  @override
  void initState() {
    super.initState();
    _getResultsFromFirestore(widget.sectionMethod);
  }

  @override
  Widget build(BuildContext context) {
    final double screenSize = MediaQuery.of(context).size.width;
    return Row(children: [
      Container(
          width: screenSize * 0.35,
          padding: const EdgeInsets.only(
            top: 20,
            bottom: 20,
          ),
          margin: const EdgeInsets.only(
            top: 5,
            bottom: 5,
          ),
          decoration: const BoxDecoration(
            color: AppColours.appPurpleLight,
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: Center(
            child: Text(
              widget.sectionName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          )),
      Container(
          width: screenSize * 0.2,
          padding: const EdgeInsets.only(
            top: 20,
            bottom: 20,
          ),
          margin: const EdgeInsets.only(
            right: 10,
            left: 10,
          ),
          decoration: const BoxDecoration(
            color: AppColours.appPurpleLight,
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: Center(
            child: Text(
              "$answeredQuestions of $numberOfQuestions",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          )),
      SizedBox(
        width: screenSize * 0.275,
        child: TextButton(
          style: TextButton.styleFrom(
            primary: Colors.white,
            backgroundColor: AppColours.appPurpleLighter,
            elevation: 2,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
          ),
          onPressed: () {
            _loadQuestion(context, widget.sectionMethod);
          },
          child: const Text("Open"),
        ),
      )
    ]);
  }

  // Loads a list of all the answered questions from firebase to see the total
  // amount of questions answered per section and saves them in a list.
  Future<List<QuestionTotals>> _getResultsFromFirestore(
      String sectionID) async {
    // The list to store all the total amount of questions and answered questions.
    List<QuestionTotals> questionTotals = [];
    int totalAnswered = 0;
    try {
      // Creates a instance reference to the Survey_Responses collection.
      CollectionReference reference =
          FirebaseFirestore.instance.collection('Survey_Responses');
      // Pulls all data where the vesselID and sectionID match.
      QuerySnapshot querySnapshot =
          await reference.where('vesselID', isEqualTo: vesselID).get();
      // Queries the snapshot to retrieve the section ID, the number of questions,
      // in the section and the number of answered questions and saves to
      // questionTotals.
      setState(() {
        for (var document in querySnapshot.docs) {
          questionTotals.add(QuestionTotals(document['sectionID'],
              document['numberOfQuestions'], document['answeredQuestions']));
        }

        // Sets the total amount of questions questions from Firebase.
        for (var i = 0; i < questionTotals.length; i++) {
          if (questionTotals[i].sectionID == sectionID) {
            totalAnswered++;
          }
        }
        // Sets the total number of questions and answered amount.
        numberOfQuestions = questionBrain.getQuestionAmount(sectionID);
        answeredQuestions = totalAnswered;

        // Checks if the number of answered questions is greater than the total
        // number of questions and sets the answered questions to the total
        // number of questions.
        if (answeredQuestions > numberOfQuestions) {
          answeredQuestions = numberOfQuestions;
        }
      });
    } catch (error) {
      debugPrint("Error: $error");
    }
    return questionTotals;
  }

  // Takes the user to the required survey section when pressing on an active survey.
  void _loadQuestion(BuildContext context, String questionID) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SurveySection(
          vesselID: vesselID,
          questionID: questionID,
        ),
      ),
    ).then(onGoBack);
  }

  // REFERENCE accessed 29/03/2022 https://www.nstack.in/blog/flutter-refresh-on-navigator-pop-or-go-back/
  // Used to update the state of the progress widget once a survey section has been
  // updated, representing the current amount of responses.
  FutureOr<dynamic> onGoBack(dynamic value) {
    _getResultsFromFirestore(widget.sectionMethod);
    setState(() {});
  }
// END REFERENCE
}

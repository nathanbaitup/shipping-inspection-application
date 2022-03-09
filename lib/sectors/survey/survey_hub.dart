import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shipping_inspection_app/sectors/questions/question_brain.dart';
import 'package:shipping_inspection_app/sectors/survey/survey_section.dart';
import '../drawer/drawer_globals.dart' as globals;

import '../../utils/qr_scanner_controller.dart';

QuestionBrain questionBrain = QuestionBrain();

class SurveyHub extends StatefulWidget {
  const SurveyHub({Key? key}) : super(key: key);

  @override
  _SurveyHubState createState() => _SurveyHubState();
}

class _SurveyHubState extends State<SurveyHub> {
  // Takes the user to the required survey section when pressing on an active survey.
  void loadQuestion(String questionID) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SurveySection(questionID: questionID),
      ),
    );
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
          builder: (context) => const QRScanner(),
        ),
      );
      globals.addRecord(
          'opened', globals.getUsername(), DateTime.now(), 'QR camera');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  "Survey Hub",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Table(
                  children: [
                    const TableRow(
                      children: [
                        Text(
                          "Sections",
                          textScaleFactor: 1.5,
                        ),
                        Text(
                          "Progress",
                          textScaleFactor: 1.5,
                        ),
                        Text(
                          "Survey Link",
                          textScaleFactor: 1.5,
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        const Text(
                          "Fire & Safety",
                          textScaleFactor: 1.5,
                        ),
                        Text(
                          "${questionBrain.getAnswerAmount("f&s")} of ${questionBrain.getQuestionAmount("f&s")}",
                          textScaleFactor: 1.5,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            loadQuestion('f&s');
                          },
                          child: const Text("Go to this Section?"),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        const Text(
                          "Lifesaving",
                          textScaleFactor: 1.5,
                        ),
                        Text(
                          "${questionBrain.getAnswerAmount("lifesaving")} of ${questionBrain.getQuestionAmount("lifesaving")}",
                          textScaleFactor: 1.5,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            loadQuestion('lifesaving');
                          },
                          child: const Text("Go to this Section?"),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        const Text(
                          "Engine Room",
                          textScaleFactor: 1.5,
                        ),
                        Text(
                          "${questionBrain.getAnswerAmount("engine")} of ${questionBrain.getQuestionAmount("engine")}",
                          textScaleFactor: 1.5,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            loadQuestion('engine');
                          },
                          child: const Text("Go to this Section?"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                  child: const Text("Open Camera"),
                  onPressed: () async => openCamera()),
            ],
          ),
        ),
      ),
    );
  }
}

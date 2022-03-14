import 'package:ar_flutter_plugin/datatypes/config_planedetection.dart';
import 'package:ar_flutter_plugin/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_anchor_manager.dart';
import 'package:flutter/material.dart';
// ---------- AR Plugins ----------
import 'package:ar_flutter_plugin/ar_flutter_plugin.dart';
import 'package:ar_flutter_plugin/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_session_manager.dart';

import '../../utils/colours.dart';
import '../questions/question_brain.dart';
import '../survey/survey_section.dart';
import '../drawer/drawer_globals.dart' as history_globals;

QuestionBrain questionBrain = QuestionBrain();

class NewARHub extends StatefulWidget {
  final String questionID;
  final List<String> arContent;
  final bool openThroughQR;
  const NewARHub({
    Key? key,
    required this.questionID,
    required this.openThroughQR,
    required this.arContent,
  }) : super(key: key);

  @override
  _NewARHubState createState() => _NewARHubState();
}

class _NewARHubState extends State<NewARHub> {
  late ARSessionManager arSessionManager;
  late ARObjectManager arObjectManager;
  late ARAnchorManager arAnchorManager;

  @override
  void dispose() {
    super.dispose();
    arSessionManager.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _returnToSectionScreen();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.arContent[0]),
        ),
        body: Stack(
          children: [
            ARView(
              onARViewCreated: onARViewCreated,
              planeDetectionConfig: PlaneDetectionConfig.horizontalAndVertical,
            ),
            Row(
              children: [
                ARQuestionWidget(
                  arContent: widget.arContent,
                ),
                ARContentWidget(
                  arContent: widget.arContent,
                ),
              ],
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  children: [
                    RawMaterialButton(
                      onPressed: () {
                        history_globals.addRecord(
                            "pressed",
                            history_globals.getUsername(),
                            DateTime.now(),
                            'take screenshot');
                      },
                      elevation: 5.0,
                      fillColor: LightColors.sPurple,
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(15.0),
                      child: const Icon(
                        Icons.photo_camera,
                        size: 35.0,
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(),
                    RawMaterialButton(
                      onPressed: () async => _returnToSectionScreen(),
                      elevation: 5.0,
                      fillColor: LightColors.sPurpleL,
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(10.0),
                      child: const Icon(
                        Icons.check,
                        size: 35.0,
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(),
                    RawMaterialButton(
                      onPressed: () => _returnToSectionScreen(),
                      elevation: 5.0,
                      fillColor: LightColors.sPurpleLL,
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(10.0),
                      child: const Icon(
                        Icons.close,
                        size: 35.0,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      width: 75.0,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: const [],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ])
      )
    );
  }

  void onARViewCreated(
      ARSessionManager arSessionManager,
      ARObjectManager arObjectManager,
      ARAnchorManager arAnchorManager,
      ARLocationManager arLocationManager) {
    this.arSessionManager = arSessionManager;
    this.arObjectManager = arObjectManager;
    this.arAnchorManager = arAnchorManager;

    this.arSessionManager.onInitialize(
      showFeaturePoints: false,
      showPlanes: true,
      customPlaneTexturePath: "images/avatar.png",
      showWorldOrigin: true,
    );
    this.arObjectManager.onInitialize();
  }

  // Returns the user to the survey_section screen, ensuring they are returned to the section they are currently surveying.
  void _returnToSectionScreen() async {
    // If the user opened a section through the QR scanner, then only one screen
    // needs to be removed from the stack.
    if (widget.openThroughQR) {
      Navigator.pop(context);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => SurveySection(questionID: widget.questionID),
        ),
        (Route<dynamic> route) => true,
      );
      // If opened manually, two screens need to be removed otherwise there
      // will be two section screens open with the user needing to close both screens.
    } else {
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => SurveySection(questionID: widget.questionID),
        ),
        (Route<dynamic> route) => true,
      );
    }
    history_globals.addRecord("pressed", history_globals.getUsername(),
        DateTime.now(), 'return to section');
  }
}

class ARQuestionWidget extends StatelessWidget {
  const ARQuestionWidget({Key? key, required this.arContent}) : super(key: key);

  final List<String> arContent;

  @override
  Widget build(BuildContext context) {
    final double cWidth = MediaQuery.of(context).size.width * 0.32;
    return Column(children: [
      Container(
        width: cWidth,
        margin: const EdgeInsets.all(10.0),
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: LightColors.sPurple,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(20))),
        child: Text(
          "Section: " + arContent[0],
          style: const TextStyle(
            color: LightColors.sPurple,
          ),
        ),
      )
    ]);
  }
}

class ARContentWidget extends StatefulWidget {
  final List<String> arContent;

  const ARContentWidget({Key? key, required this.arContent}) : super(key: key);

  @override
  _MyARContentState createState() => _MyARContentState();
}

class _MyARContentState extends State<ARContentWidget> {
  int widgetQuestionID = 1;

  void _updateWidgetQuestion() {
    setState(() {
      int newQuestion = widgetQuestionID + 1;
      if (newQuestion > (widget.arContent.length - 1)) {
        newQuestion = 1;
      }
      widgetQuestionID = newQuestion;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double cWidth = MediaQuery.of(context).size.width * 0.58;
    return Column(children: [
      InkWell(
        child: Container(
          width: cWidth,
          margin: const EdgeInsets.all(10.0),
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: LightColors.sPurple,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(20))),
          child: Text(
            "Question: " + widget.arContent[widgetQuestionID],
            style: const TextStyle(
              color: LightColors.sPurple,
            ),
          ),
        ),
        onTap: () {
          _updateWidgetQuestion();
        },
      )
    ]);
  }
}

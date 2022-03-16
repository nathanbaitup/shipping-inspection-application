import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shipping_inspection_app/sectors/drawer/drawer_help.dart';
import 'package:shipping_inspection_app/sectors/questions/question_brain.dart';
import 'package:shipping_inspection_app/sectors/survey/survey_section.dart';
import 'package:shipping_inspection_app/utils/colours.dart';
import '../drawer/drawer_globals.dart' as history_global;

import '../../utils/qr_scanner_controller.dart';

QuestionBrain questionBrain = QuestionBrain();

class SurveyHub extends StatefulWidget {
  const SurveyHub({Key? key}) : super(key: key);

  @override
  _SurveyHubState createState() => _SurveyHubState();
}

class _SurveyHubState extends State<SurveyHub> {
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
      // Adds a record of the QR camera being opened to the history page.
      history_global.addRecord(
          'opened', history_global.getUsername(), DateTime.now(), 'QR camera');
    }
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
                          color: LightColors.sLavender,
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
                            color: LightColors.sPurple,
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
                            backgroundColor: LightColors.sDarkYellow,
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
                                backgroundColor: LightColors.sPurpleLL,
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
                            color: LightColors.sPurple,
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
                            backgroundColor: LightColors.sDarkYellow,
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
                          SurveySectionWidget(
                              sectionName: "Placeholder",
                              sectionMethod: "engine"),
                          SurveySectionWidget(
                              sectionName: "Placeholder",
                              sectionMethod: "engine"),
                          SurveySectionWidget(
                              sectionName: "Placeholder",
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
}

// Takes the user to the required survey section when pressing on an active survey.
void loadQuestion(BuildContext context, String questionID) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => SurveySection(
        questionID: questionID,
        capturedImages: const [],
      ),
    ),
  );
}

class SurveySectionWidget extends StatelessWidget {
  const SurveySectionWidget(
      {Key? key, required this.sectionName, required this.sectionMethod})
      : super(key: key);

  final String sectionName;
  final String sectionMethod;

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
            color: LightColors.sPurpleL,
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: Center(
            child: Text(
              sectionName,
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
            color: LightColors.sPurpleL,
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: Center(
            child: Text(
              "${questionBrain.getAnswerAmount(sectionMethod)} of ${questionBrain.getQuestionAmount(sectionMethod)}",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          )),
      SizedBox(
        width: screenSize * 0.3,
        child: TextButton(
          style: TextButton.styleFrom(
            primary: Colors.white,
            backgroundColor: LightColors.sPurpleLL,
            elevation: 2,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
          ),
          onPressed: () {
            loadQuestion(context, sectionMethod);
          },
          child: const Text("Open"),
        ),
      )
    ]);
  }
}

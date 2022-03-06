import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shipping_inspection_app/utils/colours.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

import '../questions/question_brain.dart';
import '../survey/survey_section.dart';

// Used to get the page title for a Section based off the questionID.
// TODO: this will change the title for a singular view, all AR components need to be separated and called from the AR hub.
QuestionBrain questionBrain = QuestionBrain();

// REFERENCE ACCESSED 24/02/2022 https://pub.dev/packages/arcore_flutter_plugin
// Used to implement ARCore into the application with the default options.
// This acts as a basic example of what can be done with AR, we will use the controller to build
// upon the example for our application.

// For AR to work in an emulator, emulator with AR google play services is required.

class ArHub extends StatefulWidget {
  final String questionID;
  final List<String> arContent;
  final bool openThroughQR;
  const ArHub({required this.questionID, required this.openThroughQR, required this.arContent, Key? key})
      : super(key: key);

  @override
  _ArHubState createState() => _ArHubState();
}

class _ArHubState extends State<ArHub> {
  final GlobalKey _key = GlobalKey();
  late ArCoreController arCoreController;
  late bool openThroughQR;
  late String pageTitle;
  List<String> imagePaths = [];
  List<Image> imageViewer = [];

  @override
  void initState() {
    super.initState();
    // Sets if the AR page has been opened through AR to true or false for navigation.
    openThroughQR = widget.openThroughQR;
    pageTitle = questionBrain.getPageTitle(widget.questionID);
  }

  // Returns the user to the survey_section screen, ensuring they are returned to the section they are currently surveying.
  void _returnToSectionScreen() async {
    // If the user opened a section through the QR scanner, then only one screen
    // needs to be removed from the stack.
    if (openThroughQR) {
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
  }

  @override
  Widget build(BuildContext context) {
    // WillPopScope overrides the on back press to ensure the user is taken back
    // to the survey_section screen, and not the QR camera.
    return WillPopScope(
      onWillPop: () async {
        _returnToSectionScreen();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(pageTitle),
        ),
        body: SafeArea(
          child: RepaintBoundary(
            key: _key,
            // Stack View is used to place widgets on top of the camera view to display questions to the user.
            child: Stack(
              children: <Widget>[
                ArCoreView(
                  onArCoreViewCreated: _onArCoreViewCreated,
                  enableTapRecognizer: true,
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
                            _takeScreenshot();
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
                          onPressed: () => Navigator.pop(context, imageViewer),
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
                              children: imageViewer,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ----------- THIS IS THE AR CREATOR -----------
  // Use the controller to add items to the screen.
  // eg: the surveyor scans a QR code, that opens this controller with the questions and item being inspected on the screen.
  void _onArCoreViewCreated(ArCoreController controller) async {
    arCoreController = controller;

    _addSphere(arCoreController);
    _addCylinder(arCoreController);
    _addCube(arCoreController);
  }

  // Creates a sphere and adds to the creator view.
  void _addSphere(ArCoreController controller) async {
    final material =
        ArCoreMaterial(color: const Color.fromARGB(120, 66, 134, 244));
    final sphere = ArCoreSphere(
      materials: [material],
      radius: 0.1,
    );
    final node = ArCoreNode(
      shape: sphere,
      position: vector.Vector3(0, 0, -1.5),
    );
    controller.addArCoreNode(node);
  }

  // Creates a cylinder and adds to the creator view.
  void _addCylinder(ArCoreController controller) async {
    final material = ArCoreMaterial(
      color: Colors.red,
      reflectance: 1.0,
    );
    final cylinder = ArCoreCylinder(
      materials: [material],
      radius: 0.5,
      height: 0.3,
    );
    final node = ArCoreNode(
      shape: cylinder,
      position: vector.Vector3(0.0, -0.5, -2.0),
    );
    controller.addArCoreNode(node);
  }

  // Creates a cube and adds to the creator view.
  void _addCube(ArCoreController controller) async {
    final material = ArCoreMaterial(
      color: const Color.fromARGB(120, 66, 134, 244),
      metallic: 1.0,
    );
    final cube = ArCoreCube(
      materials: [material],
      size: vector.Vector3(0.5, 0.5, 0.5),
    );
    final node = ArCoreNode(
      shape: cube,
      position: vector.Vector3(-0.5, 0.5, -3.5),
    );
    controller.addArCoreNode(node);
  }

  @override
  void dispose() {
    arCoreController.dispose();
    super.dispose();
  }

  // REFERENCE ACCESSED 25/02/2022 https://www.kindacode.com/article/how-to-programmatically-take-screenshots-in-flutter/
  // Used to take a screenshot of the current widget displayed.
  void _takeScreenshot() async {
    RenderRepaintBoundary boundary =
        _key.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage();
    final directory = (await getApplicationDocumentsDirectory()).path;
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();

    File imgFile = File('$directory/screenshot.png');
    imagePaths.add(imgFile.path);
    imgFile.writeAsBytes(pngBytes).then((value) async {
      setState(() {
        imageViewer.add(Image.file(
          File(imgFile.path),
          width: 75.0,
          height: 75.0,
        ));
      });
    });
  }
// END REFERENCE


}

class ARQuestionWidget extends StatelessWidget {
  ARQuestionWidget({Key? key, required this.arContent}) : super(key: key);

  final List<String> arContent;

  @override
  Widget build(BuildContext context) {
    final double c_width = MediaQuery.of(context).size.width*0.32;
    return Column(
        children: [
          Container(
            width: c_width,
            margin: const EdgeInsets.all(10.0),
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: LightColors.sPurple,
                ),
                borderRadius: BorderRadius.all(Radius.circular(20))
            ),
            child: Text(
              "Section: " + arContent[0],
              style: const TextStyle(
                color: LightColors.sPurple,
              ),
            ),
          )
        ]
    );
  }

}

class ARContentWidget extends StatelessWidget {
  ARContentWidget({Key? key, required this.arContent}) : super(key: key);

  final List<String> arContent;

  @override
  Widget build(BuildContext context) {
    final double c_width = MediaQuery.of(context).size.width*0.58;
    return Column(
        children: [
          InkWell(
            child: Container(
              width: c_width,
              margin: const EdgeInsets.all(10.0),
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: LightColors.sPurple,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(20))
              ),
              child: Flexible(
                child: Text(
                "Question: " + arContent[1],
                  style: const TextStyle(
                    color: LightColors.sPurple,
                  ),
                ),
              ),
            ),
            onTap: () {
              print("change question");
            },
          )
        ]
    );
  }

}

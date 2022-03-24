import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vector_math;

// ---------- AR Plugins ----------
import 'package:ar_flutter_plugin/ar_flutter_plugin.dart';
import 'package:ar_flutter_plugin/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin/datatypes/config_planedetection.dart';
import 'package:ar_flutter_plugin/datatypes/hittest_result_types.dart';
import 'package:ar_flutter_plugin/datatypes/node_types.dart';
import 'package:ar_flutter_plugin/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin/models/ar_anchor.dart';
import 'package:ar_flutter_plugin/models/ar_hittest_result.dart';
import 'package:ar_flutter_plugin/models/ar_node.dart';

import '../../utils/colours.dart';
import '../questions/question_brain.dart';
import '../survey/survey_section.dart';
import '../drawer/drawer_globals.dart' as history_globals;

QuestionBrain questionBrain = QuestionBrain();

class NewARHub extends StatefulWidget {
  final String vesselID;
  final String questionID;
  final List<String> arContent;
  final bool openThroughQR;

  const NewARHub({
    Key? key,
    required this.vesselID,
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
  List<Image> imageViewer = [];

  // Nodes are the actual objects themselves shown within the AR view on device.
  // These function by correlating to an anchor to display at a fixed point as decided by the user.
  List<ARNode> nodes = [];

  // Anchors are places where the user has tapped on the AR scene, where an object
  // Should be displayed based on its plane and axis.
  List<ARAnchor> anchors = [];

  @override
  void dispose() {
    super.dispose();
    // Ensures the arSession is closed correctly when leaving the scene.
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
            body: Stack(children: [
              ARView(
                onARViewCreated: _onARViewCreated,
                planeDetectionConfig:
                    PlaneDetectionConfig.horizontalAndVertical,
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
                        onPressed: () => _takeScreenshot(),
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
                        onPressed: () => _onReset(),
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
            ])));
  }

  // REFERENCE accessed 14/03/2022 https://github.com/CariusLars/ar_flutter_plugin
  // Used the examples provided to create an AR view that can be interacted with
  // and manipulated on the screen.

  // Initialises the AR view.
  void _onARViewCreated(
      ARSessionManager arSessionManager,
      ARObjectManager arObjectManager,
      ARAnchorManager arAnchorManager,
      ARLocationManager arLocationManager) {
    this.arSessionManager = arSessionManager;
    this.arObjectManager = arObjectManager;
    this.arAnchorManager = arAnchorManager;

    // Sets up the AR environment allowing for items to be added and moved around
    // on the plane view.
    this.arSessionManager.onInitialize(
          // Shows where a point has been detected within AR.
          showFeaturePoints: false,
          // Show where object can be placed and the texture for the object.
          // TODO: set to false after testing is completed.
          showPlanes: true,
          customPlaneTexturePath: "images/triangle.png",
          // Allow object to move
          handlePans: true,
          // Allow object to rotation
          handleRotation: true,
        );

    // Sets up the AR object manager to manage an object being added or moved in
    // the AR scene.
    this.arObjectManager.onInitialize();
    // On each press adds a new object onto the AR session.
    this.arSessionManager.onPlaneOrPointTap = _onPlaneOrPointTap;
  }

  // Function that handles adding an object to the AR scene.
  // Currently adds a model of a duck following the example.
  // TODO: update code to only allow for one item to be displayed.
  // TODO: display the item automatically and not with a tap.
  // TODO: allow for multiple items to be loaded dynamically based on the question ID.
  Future<void> _onPlaneOrPointTap(List<ARHitTestResult> userTapResults) async {
    // Gets the users hit point and sets the first tap to a plane type.
    var arObjectResult = userTapResults
        .firstWhere((pointHit) => pointHit.type == ARHitTestResultType.plane);

    // Makes the users tapped point a new anchor point ready to add the node object.
    var newAnchor =
        ARPlaneAnchor(transformation: arObjectResult.worldTransform);

    // Adds the new anchor to the AnchorManager and returns true.
    bool? didAddAnchor = await arAnchorManager.addAnchor(newAnchor);

    // Checks if anchor has been added to add the object to the anchors list
    // to ensure that the node object is displayed correctly on the screen.
    if (didAddAnchor == true) {
      anchors.add(newAnchor);

      // ----- CREATING AN AR OBJECT -----
      // The node is what is displayed to the user in the AR view, linked to an anchor point.
      var newNode = ARNode(
        // Sets the type of object
        type: NodeType.webGLB,
        // Where the object is rendered from.
        // TODO: Change the object uri to dynamically load the correct model or image based on what is being surveyed.
        uri:
            "https://github.com/KhronosGroup/glTF-Sample-Models/raw/master/2.0/Duck/glTF-Binary/Duck.glb",
        // Sets the overall size of the object on the device.
        scale: vector_math.Vector3(0.2, 0.2, 0.2),
        // Sets the position to the anchor point created when pressing on the plane.
        position: vector_math.Vector3(0.0, 0.0, 0.0),
        // Sets the rotation to follow the plane axis.
        rotation: vector_math.Vector4(1.0, 0.0, 0.0, 0.0),
      );

      // Takes the node just created and links it to the anchor as added by the
      // user to display where pressed.
      bool? didAddNodeToAnchor =
          await arObjectManager.addNode(newNode, planeAnchor: newAnchor);
      // Checks if the node could be added to the anchor then saves the node object
      // to the nodes list.
      if (didAddNodeToAnchor == true) {
        nodes.add(newNode);
      } else {
        arSessionManager.onError("Failed to add node to anchor.");
      }
    } else {
      arSessionManager.onError("Failed to add anchor.");
    }
  }

  // -- REFERENCE START https://github.com/CariusLars/ar_flutter_plugin
  Future<void> onTakeScreenshot() async {
    var imageProv = await arSessionManager.snapshot();
    setState(() {});

    imageViewer.add(Image(
      image: imageProv,
      width: 75.0,
      height: 75.0,
    ));

    await showDialog(
      context: context,
      builder: (_) {
        // After 1 second the preview image is closed.
        Future.delayed(
          const Duration(seconds: 1),
          () {
            Navigator.of(context).pop();
          },
        );
        return Dialog(
          child: InkWell(
            child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(image: imageProv, fit: BoxFit.cover)),
            ),
            onTap: () {
              Navigator.of(context).pop();
              setState(() {});
            },
          ),
        );
      },
    );
  }
  // REFERENCE END --

  // Removes all nodes and anchors on the screen to return to a clean view.
  Future<void> _onReset() async {
    for (var node in nodes) {
      arObjectManager.removeNode(node);
    }
    for (var anchor in anchors) {
      arAnchorManager.removeAnchor(anchor);
    }
    nodes = [];
    anchors = [];
  }
  // END REFERENCE

  void _takeScreenshot() async {
    onTakeScreenshot();
    history_globals.addRecord("pressed", history_globals.getUsername(),
        DateTime.now(), 'take screenshot');
  }

  // TODO: implement save functionality to save AR images to cloud storage.
  // Not fully implemented, needs to save image to firebase but currently not sure
  // how to do so from an image provider.
  void _saveImagesToFirebase() async {
    // test to see what kind of output is created from the image provider.
    var image = imageViewer[0].image;
    debugPrint('IMAGE: $image');
  }

  // Returns the user to the survey_section screen, ensuring they are returned to the section they are currently surveying.
  void _returnToSectionScreen() async {
    _saveImagesToFirebase();
    // If the user opened a section through the QR scanner, then only one screen
    // needs to be removed from the stack.
    if (widget.openThroughQR) {
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => SurveySection(
              vesselID: widget.vesselID,
              questionID: widget.questionID,
              capturedImages: imageViewer),
        ),
        (Route<dynamic> route) => true,
      );
      // If opened manually, two screens need to be removed otherwise there
      // will be two section screens open with the user needing to close both screens.
    } else {
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => SurveySection(
              vesselID: widget.vesselID,
              questionID: widget.questionID,
              capturedImages: imageViewer),
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

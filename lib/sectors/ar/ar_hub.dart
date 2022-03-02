import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shipping_inspection_app/utils/colours.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

// REFERENCE ACCESSED 24/02/2022 https://pub.dev/packages/arcore_flutter_plugin
// Used to implement ARCore into the application with the default options.
// This acts as a basic example of what can be done with AR, we will use the controller to build
// upon the example for our application.

// For AR to work in an emulator, emulator with AR google play services is required.

class ArHub extends StatefulWidget {
  const ArHub({Key? key}) : super(key: key);

  @override
  _ArHubState createState() => _ArHubState();
}

class _ArHubState extends State<ArHub> {
  final GlobalKey _key = GlobalKey();
  late ArCoreController arCoreController;
  List<String> imagePaths = [];
  List<Image> imageViewer = [];

  // Changed from the ArCoreView being the body to a stack so we can place widgets on top of the AR view.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View in AR'),
      ),
      body: SafeArea(
        child: RepaintBoundary(
          key: _key,
          child: Stack(
            children: <Widget>[

              ArCoreView(
                onArCoreViewCreated: _onArCoreViewCreated,
                enableTapRecognizer: true,
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
                        padding: const EdgeInsets.all(20.0),
                        child: const Icon(
                          Icons.photo_camera,
                          size: 35.0,
                          color: Colors.white,
                        ),
                      ),

                      const Spacer(),

                      RawMaterialButton(
                        onPressed: () => Navigator.pop(context, imageViewer),
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
    super.dispose();
    arCoreController.dispose();
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

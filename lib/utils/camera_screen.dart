import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../sectors/ar/ar_hub.dart';

//TODO: Convert camera layouts from portrait to landscape.
class CameraScreen extends StatefulWidget {
  final List<CameraDescription> cameras;
  // The name of the button that was pressed on the questionnaire section page.
  // Used to decide what screen is shown to the user on each button press.
  final String buttonID;
  final String questionID;
  const CameraScreen(
      {required this.cameras,
      required this.buttonID,
      required this.questionID,
      Key? key})
      : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  List<Image> imageViewer = [];

  void captureImage() async {
    try {
      // REFERENCE ACCESSED 14/02/2022 https://docs.flutter.dev/cookbook/plugins/picture-using-camera
      // Used to capture the image displayed on screen.
      final image = await _controller.takePicture();
      //END REFERENCE

      // Displays the image within a preview window to allow a surveyor to take multiple images
      // if required.
      setState(() {
        imageViewer.add(Image.file(
          File(image.path),
          width: 75.0,
          height: 75.0,
        ));
      });
    } catch (error) {
      const AlertDialog(title: Text("Error capturing image"));
    }
  }

  // REFERENCE ACCESSED 14/02/2022 https://www.youtube.com/watch?v=GpV5sPHEHGs
  // Used to implement camera functionality that displays a camera capture to the user.
  late CameraController _controller;

  @override
  void initState() {
    super.initState();
    // Initializes the camera to automatically open the rear camera and set the resolution to its maximum.
    _controller = CameraController(
      widget.cameras[0],
      ResolutionPreset.max,
      enableAudio: false,
    );
    _controller.initialize().then((value) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  // Unmounts the controller from the state after use.
  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
  // END REFERENCE

  @override
  Widget build(BuildContext context) {
    // If the camera permissions have not been requested a loading indicator is displayed.
    // and permissions are requested.
    if (!_controller.value.isInitialized) {
      return const SizedBox(
        child: Center(child: CircularProgressIndicator()),
      );
    }
    // If the AR button is pressed, then display the AR camera to the user.
    if (widget.buttonID == 'ar') {
      return ArHub(questionID: widget.questionID);
    }
    // Default camera viewer.
    return SafeArea(
      child: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Center(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height / 1.27,
                  width: MediaQuery.of(context).size.width - 10,
                  child: CameraPreview(_controller),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SizedBox(
                  width: 75.0,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: imageViewer,
                    ),
                  ),
                ),
                RawMaterialButton(
                  onPressed: () async => captureImage(),
                  elevation: 5.0,
                  fillColor: Colors.purple,
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(15.0),
                  child: const Icon(
                    Icons.photo_camera,
                    size: 35.0,
                    color: Colors.white,
                  ),
                ),
                RawMaterialButton(
                  onPressed: () => Navigator.pop(context, imageViewer),
                  elevation: 5.0,
                  fillColor: Colors.grey,
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(10.0),
                  child: const Icon(
                    Icons.check,
                    size: 35.0,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

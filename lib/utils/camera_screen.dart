import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraScreen extends StatefulWidget {
  final List<CameraDescription> cameras;
  const CameraScreen({required this.cameras, Key? key}) : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  List<Icon> imageViewer = [];

  // REFERENCE ACCESSED 14/02/2022 https://www.youtube.com/watch?v=GpV5sPHEHGs
  // Used to implement the camera to display
  late CameraController controller;
  late String imagePath;

  @override
  void initState() {
    super.initState();
    // Initializes the camera to automatically open the rear camera and set the resolution to its maximum.
    controller = CameraController(
      widget.cameras[0],
      ResolutionPreset.max,
      enableAudio: false,
    );
    controller.initialize().then((value) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }
  // END REFERENCE

  @override
  Widget build(BuildContext context) {
    // If the camera permissions have not been requested a loading indicator is displayed.
    if (!controller.value.isInitialized) {
      return const SizedBox(
        child: Center(child: CircularProgressIndicator()),
      );
    }
    return SafeArea(
      child: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Center(
                child: SizedBox(
                  height: 600.0,
                  width: 400.0,
                  child: CameraPreview(controller),
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
                Center(
                  child: RawMaterialButton(
                    onPressed: () {
                      //TODO: change adding of icons to photos when gotten the photo to capture.
                      setState(() {
                        imageViewer.add(
                          const Icon(Icons.check, color: Colors.green),
                        );
                      });
                    },
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
                ),
                RawMaterialButton(
                  onPressed: () {
                    //TODO: update this to take image pathnames when returning to the questionnaire.
                    Navigator.pop(context);
                  },
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

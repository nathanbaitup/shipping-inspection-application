import 'dart:io';
import 'package:camera/camera.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../sectors/survey/survey_section.dart';

// TODO: cleanup this dart file in a separate branch for code quality.
class CameraScreen extends StatefulWidget {
  final List<CameraDescription> cameras;
  final String vesselID;
  final String questionID;
  const CameraScreen(
      {required this.cameras,
      required this.questionID,
      required this.vesselID,
      Key? key})
      : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  List<Image> imageViewer = [];
  List<String> imagePaths = [];
  late File _imageFile;

  void captureImage() async {
    try {
      // REFERENCE ACCESSED 14/02/2022 https://docs.flutter.dev/cookbook/plugins/picture-using-camera
      // Used to capture the image displayed on screen.
      final image = await _controller.takePicture();
      //END REFERENCE

      // Displays the image within a preview window to allow a surveyor to take multiple images
      // if required.
      setState(() {
        imagePaths.add(image.path);
        _imageFile = File(image.path);
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

  // REFERENCE accessed 16/03/2022 https://stackoverflow.com/a/64764390
  // Used to save a file to firebase.
  // Saves the images taken into a folder with the ID of the vessel being inspected on firebase storage.
  void saveImagesToFirebaseStorage() async {
    for (var i = 0; i < imageViewer.length; i++) {
      String filename = 'image-$i-${DateTime.now().toString()}';
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference firebaseStorageRef = storage.ref().child(
          'images/${widget.vesselID}/${widget.questionID}/$filename.jpeg');
      UploadTask uploadTask = firebaseStorageRef.putFile(_imageFile);
      await uploadTask.then((value) => value.ref.getDownloadURL());
    }
  }
  //END REFERENCE

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
                  onPressed: () async {
                    try {
                      saveImagesToFirebaseStorage();
                    } catch (e) {
                      debugPrint("Error: $e");
                    }
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SurveySection(
                            questionID: widget.questionID,
                            capturedImages: imageViewer,
                            vesselID: widget.vesselID),
                      ),
                    );
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

import 'dart:io';
import 'package:camera/camera.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../../utils/app_colours.dart';
import '../survey/survey_section.dart';

// TODO: cleanup this dart file in a separate branch for code quality.
class CameraScreen extends StatefulWidget {
  // A list of all available cameras on the phone.
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
  // Displays images in a small scrollable view finder on the camera screen.
  List<Image> imageViewer = [];
  // Saves a list of all image paths to be uploaded to firebase.
  List<String> imagePaths = [];
  // The camera controller.
  late CameraController _controller;
  // Accessed in the camera controller to set the image file to. Saves the individual
  // image to firebase.
  late File _imageFile;
  // Displays a loading indicator if needed.
  bool loading = false;

  @override
  void initState() {
    super.initState();
    _initializeCameraController();
  }

  // Unmounts the controller from the state after use.
  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // If the camera permissions have not been requested a loading indicator is displayed.
    // and permissions are requested.
    if (!_controller.value.isInitialized || loading == true) {
      return const SizedBox(
        child: Center(child: CircularProgressIndicator()),
      );
    }
    // Creates an material design app following the applications theme.
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: AppColours.appPurple,
          secondary: AppColours.appPurpleLighter,
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Surveyor Camera"),
          leading: Transform.scale(
            scale: 0.7,
            child: FloatingActionButton(
              heroTag: 'on_back',
              onPressed: () => Navigator.pop(context),
              backgroundColor: AppColours.appPurpleLighter,
              child: const Icon(Icons.arrow_back),
            ),
          ),
        ),
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              // Contains the camera view.
              SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: CameraPreview(_controller),
              ),

              // Contains buttons to capture an image and go back to the survey section,
              // and an image viewer to see previews of images.
              Positioned.fill(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      // The image preview window displayed at the bottom left of the screen.
                      Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: SizedBox(
                          width: 80.0,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: imageViewer,
                            ),
                          ),
                        ),
                      ),

                      // Button that captures an image.
                      RawMaterialButton(
                        onPressed: () async => _captureImage(),
                        elevation: 5.0,
                        fillColor: AppColours.appPurple,
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(15.0),
                        child: const Icon(
                          Icons.photo_camera,
                          size: 35.0,
                          color: Colors.white,
                        ),
                      ),

                      // Button that saves the images and returns to the survey.
                      RawMaterialButton(
                        onPressed: () async => _saveAndReturnToSurvey(),
                        elevation: 5.0,
                        fillColor: AppColours.appPurpleLighter,
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // REFERENCE accessed 14/02/2022 https://www.youtube.com/watch?v=GpV5sPHEHGs
  // Used to implement camera functionality that displays a camera capture to the user.
  void _initializeCameraController() {
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
  // END REFERENCE

  // Captures the camera image and displays the image within a preview window
  // allowing for multiple images to be captured.
  void _captureImage() async {
    try {
      // REFERENCE accessed 14/02/2022 https://docs.flutter.dev/cookbook/plugins/picture-using-camera
      // Used to capture the image displayed on screen.
      final image = await _controller.takePicture();
      //END REFERENCE

      // Updates the image viewer with the captured image.
      setState(() {
        imagePaths.add(image.path);
        _imageFile = File(image.path);
        imageViewer.add(
          Image.file(
            File(image.path),
            width: 75.0,
            height: 75.0,
          ),
        );
      });
      _saveImagesToFirebaseStorage(_imageFile);
    } catch (error) {
      const AlertDialog(title: Text("Error capturing image"));
    }
  }

  // Tries to save captured images to firebase and returns the surveyor to the survey.
  void _saveAndReturnToSurvey() async {
    _controller.dispose();
    // Deletes the camera from the navigation stack and reloads the survey section.
    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SurveySection(
            questionID: widget.questionID, vesselID: widget.vesselID),
      ),
    );
  }

  // REFERENCE accessed 16/03/2022 https://stackoverflow.com/a/64764390
  // Used to save a file to firebase.
  // Saves the taken image directly to firebase. Method can be refactored to save
  // At a different location if required.
  void _saveImagesToFirebaseStorage(File _imageFile) async {
    // Creates a firebase storage reference to save an image in a survey section
    // sub folder under the vessel ID.
    try {
      String _filename =
          'image-camera-${DateTime.now().microsecondsSinceEpoch}';
      Reference firebaseStorageRef = FirebaseStorage.instance
          .ref()
          .child('images/${widget.vesselID}/${widget.questionID}/$_filename');
      // Uploads the images to the firebase storage.
      UploadTask uploadTask = firebaseStorageRef.putFile(_imageFile);
      await uploadTask.then((value) => value.ref.getDownloadURL());
      // Creates a toast to say that data cannot be saved.
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Image Saved.")));
    } catch (e) {
      // Creates a toast to say that data cannot be saved.
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Unable to save data, please try again.")));
    }
  }
//END REFERENCE
}

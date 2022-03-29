import 'dart:io';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:shipping_inspection_app/shared/loading.dart';

import '../../utils/app_colours.dart';
import '../ar/new_ar_hub.dart';
import '../drawer/drawer_globals.dart' as history_globals;
import '../questions/question_brain.dart';

QuestionBrain questionBrain = QuestionBrain();

class QRScanner extends StatefulWidget {
  final String vesselID;
  const QRScanner({Key? key, required this.vesselID}) : super(key: key);

  @override
  _QRScannerState createState() => _QRScannerState();
}

class _QRScannerState extends State<QRScanner> {
  List<String> questionsToAsk = [];

  // REFERENCE ACCESSED 01/03/2022 https://pub.dev/packages/qr_code_scanner
  // Used dependency to implement scanning of QR codes.
  // Chose this dependency over the newer, supported version as it provides more access to creating a controller and also is a stable build,
  // with the new recommended dependency being unstable at the time of creation.

  // Required within onQRViewCreated widget.
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  // The result saved as a Barcode entity.
  Barcode? _qrResult;
  // The controller to access the QRView.
  QRViewController? _qrController;

  // Loading bool statement
  bool loading = false;

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      _qrController!.pauseCamera();
    } else if (Platform.isIOS) {
      _qrController!.resumeCamera();
    }
  }

  // Creates the QR controller where it checks if the scanned data can be used to
  // launch the correct AR section.
  void _onQRViewCreated(QRViewController qrController) {
    _qrController = qrController;
    qrController.scannedDataStream.listen((scannedResult) {
      setState(() {
        _qrResult = scannedResult;
      });
      _launchARSection('${_qrResult?.code}');
    });
  }
  // END REFERENCE

  // Styling for the QR Scanner Page.
  @override
  Widget build(BuildContext context) {
    return loading
        ? const Loading(color: Colors.black)
        : MaterialApp(
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
              body: Column(
                children: <Widget>[
                  Expanded(
                    flex: 5,
                    child: QRView(
                      key: qrKey,
                      onQRViewCreated: _onQRViewCreated,
                      overlay: QrScannerOverlayShape(
                        borderColor: AppColours.appPurple,
                        borderWidth: 10.0,
                        borderRadius: 10.0,
                        overlayColor: const Color.fromRGBO(0, 0, 0, 95),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  // Checks if the QR codes scanned are useful for use within the application,
  // and navigates to the page of the AR section to survey.
  _launchARSection(String qrResult) async {
    setState(() {
      loading = true;
      debugPrint(
          'loading animation triggered TRUE, _performChannlNameConnection');
    });

    if (_qrResult?.code == "f&s" ||
        _qrResult?.code == "engine" ||
        _qrResult?.code == "lifesaving") {
      // Uses the question brain to load the questions and title based on the scanned QR.
      questionsToAsk = questionBrain.getQuestions('${_qrResult?.code}');
      String arTitle = questionBrain.getPageTitle('${_qrResult?.code}');
      List<String> arContentPush = [arTitle] + questionsToAsk;

      // Removes and disposes the QR camera.
      Navigator.pop(context);
      _qrController?.dispose();

      loading = false;
      // Loads the AR session based on the scanned result.
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NewARHub(
            vesselID: widget.vesselID,
            questionID: '${_qrResult?.code}',
            arContent: arContentPush,
            openThroughQR: true,
            seenTutorial: false,
          ),
        ),
      );
      // Adds a message to say what page has been opened from the QR camera.
      history_globals.addRecord('opened', history_globals.getUsername(),
          DateTime.now(), '$arTitle AR session through QR camera');
    } else {
      debugPrint('Could not launch AR section');
    }
  }

  @override
  void dispose() {
    _qrController?.dispose();
    super.dispose();
  }
}

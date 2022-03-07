import 'dart:io';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../sectors/ar/ar_hub.dart';
import 'colours.dart';

class QRScanner extends StatefulWidget {
  const QRScanner({Key? key}) : super(key: key);

  @override
  _QRScannerState createState() => _QRScannerState();
}

class _QRScannerState extends State<QRScanner> {
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

  // Creates the QR controller where it sets the scanned data into the result.
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
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: LightColors.sPurple,
          secondary: LightColors.sPurple,
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Surveyor Camera"),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              flex: 5,
              child: QRView(
                key: qrKey,
                onQRViewCreated: _onQRViewCreated,
                overlay: QrScannerOverlayShape(
                  borderColor: LightColors.sPurple,
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
    if (_qrResult?.code == "f&s" ||
        _qrResult?.code == "engine" ||
        _qrResult?.code == "lifesaving") {
      Navigator.pop(context);
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              ArHub(questionID: '${_qrResult?.code}', arContent: [" "], openThroughQR: true),
        ),
      );
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

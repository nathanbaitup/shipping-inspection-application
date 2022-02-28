import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:url_launcher/url_launcher.dart';

import '../sectors/ar/ar_hub.dart';

class QRScanner extends StatefulWidget {
  const QRScanner({Key? key}) : super(key: key);

  @override
  _QRScannerState createState() => _QRScannerState();
}

class _QRScannerState extends State<QRScanner> {
  String _qrResult = '';

  // Launch a url - used for testing the QR Scanner worked.
  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch URL';
    }
  }

  // TODO: Ensure camera is closed when jumping activities.
  // TODO: Ensure QRCode can launch correctly without crashing.
  // TODO: Ensure when pressing the back button on device or burger returns to the questionnaire section and not the QR camera.
  // TODO: Remove QR Camera from navigator list.
  // TODO: Code cleanup
  // takes the result of the QR and tries to open the AR hub with the correct ID. If not, shall give an error.
  _launchARSection(String qrResult) async {
    if (_qrResult == "f&s" ||
        _qrResult == "engine" ||
        _qrResult == "lifesaving") {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ArHub(questionID: _qrResult),
        ),
      );
    } else {
      throw 'Could not launch AR section';
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("QR Scanner"),
        ),
        // REFERENCE ACCESSED 28/02/2022 https://pub.dev/packages/mobile_scanner
        // Used to access the widget to scan a QR code and read what has been scanned.
        body: Stack(
          children: <Widget>[
            MobileScanner(
              onDetect: ((barcode, args) {
                final String? result = barcode.rawValue;
                setState(() {
                  _qrResult = result!;
                });
              }),
            ),
            ElevatedButton(
              onPressed: () {
                //_launchURL(_qrResult);
                _launchARSection(_qrResult);
              },
              child: Text(_qrResult),
            ),
          ],
        ),
        // END REFERENCE
      ),
    );
  }
}

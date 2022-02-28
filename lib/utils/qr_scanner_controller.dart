import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScanner extends StatelessWidget {
  const QRScanner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("QR Scanner"),
        ),
        // REFERENCE ACCESSED 28/02/2022 https://pub.dev/packages/mobile_scanner
        // Used to access the widget to scan a QR code and read what has been scanned.
        body: MobileScanner(
          onDetect: ((barcode, args) {
            final String? code = barcode.rawValue;
            print("barcode: $code");
          }),
        ),
        // END REFERENCE
      ),
    );
  }
}

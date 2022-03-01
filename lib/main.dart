import 'package:flutter/material.dart';
import 'package:shipping_inspection_app/utils/colours.dart';
import 'package:shipping_inspection_app/userdashboard.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ShipApp());
}

class ShipApp extends StatefulWidget {
  const ShipApp({Key? key}) : super(key: key);

  @override
  _ShipAppState createState() => _ShipAppState();
}

class _ShipAppState extends State<ShipApp> {
  @override
  void initState() {
    super.initState();
    // Requests camera and microphone permissions on app load.
    requestPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shipping Application',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: LightColors.sPurple,
        secondary: LightColors.sPurple,
      )),
      home: const MyHomePage(title: 'Idwal Vessel Inspection App'),
    );
  }

  // Checks if permissions have been granted and asks the user for permission if not.
  // If permission is permanently denied, the user is taken to the app settings to toggle on or off.
  Future<void> requestPermissions() async {
    // REFERENCE ACCESSED 01/03/2022 https://pub.dev/packages/permission_handler
    // Used to request permissions needed to use the application as intended.
    final status = await [Permission.camera, Permission.microphone].request();

    if (status[0] == PermissionStatus.permanentlyDenied ||
        status[1] == PermissionStatus.permanentlyDenied) {
      debugPrint("camera is permanently denied");
      await openAppSettings();
    }
    // END REFERENCE
  }
}

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shipping_inspection_app/utils/colours.dart';
import 'package:shipping_inspection_app/userdashboard.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shipping_inspection_app/sectors/drawer/drawer_globals.dart' as globals;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
    globals.loadPrefs();
    // Requests camera and microphone permissions on app load.
    _requestPermissions();
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
  Future<void> _requestPermissions() async {
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

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shipping_inspection_app/userdashboard.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shipping_inspection_app/utils/app_colours.dart';
import 'package:shipping_inspection_app/sectors/drawer/drawer_globals.dart'
    as app_globals;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const ShipApp());
}

final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

// The vesselID used to differentiate surveys saved in the database.
String vesselID = '';

class ShipApp extends StatefulWidget {
  const ShipApp({Key? key}) : super(key: key);

  @override
  _ShipAppState createState() => _ShipAppState();
}

class _ShipAppState extends State<ShipApp> {
  @override
  void initState() {
    super.initState();
    app_globals.loadPrefs();
    // Requests camera and microphone permissions on app load.
    _requestPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
        valueListenable: themeNotifier,
        builder: (_, mode, __) {
          return MaterialApp(
              title: 'Shipping Application',
              theme: ThemeData(
                  colorScheme: ColorScheme.fromSwatch().copyWith(
                primary: AppColours.appPurple,
                secondary: AppColours.appPurple,
                brightness: Brightness.light,
                /* light theme settings */
              )),
              darkTheme: ThemeData(
                  colorScheme: ColorScheme.fromSwatch().copyWith(
                primary: AppColours.appPurple,
                secondary: AppColours.appPurple,
                brightness: Brightness.dark,
                /* dark theme settings */
              )),
              themeMode: mode,
              // Dark mode now follows system settings
              // Requires Android 10 (API level 29) or above to switch to dark mode
              debugShowCheckedModeBanner: false,
              // Checks if vesselID is empty, if true opens the welcome screen
              // else opens the application with the vesselID parsed in.
              home: vesselID.isEmpty
                  ? const WelcomePage()
                  : MyHomePage(
                      title: 'Idwal Vessel Inspection', vesselID: vesselID));
        });
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

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  // Stores the text value from the Text field.
  final _vesselController = TextEditingController();
  // Used to set if the vessel input field is empty or not to display an error.
  bool _validation = false;

  @override
  void dispose() {
    _vesselController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Gets the height and width of the current device.
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // Creates a header with the page title.
              Container(
                height: screenHeight * 0.12,
                width: screenWidth,
                padding: const EdgeInsets.all(0.0),
                decoration: const BoxDecoration(
                  color: AppColours.appLavender,
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(30.0),
                    bottomLeft: Radius.circular(30.0),
                  ),
                ),
                // The page title.
                child: const Center(
                  child: Text(
                    'Idwal Vessel Inspector',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 28,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    // Tries to load the Idwal logo, if fails displays empty text string.
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: Image.network(
                        'https://www.idwalmarine.com/hs-fs/hubfs/IDWAL-Logo-CMYK-Blue+White.png?width=2000&name=IDWAL-Logo-CMYK-Blue+White.png',
                        errorBuilder: (BuildContext context, Object exception,
                            StackTrace? stackTrace) {
                          return const Text('');
                        },
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Gives a description on the welcome page.
                    const Text(
                      "Hello! Welcome to the Idwal Vessel Inspection application.",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "To get started, please enter the vessel name/id you are inspecting below and press continue.",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w300,
                          fontStyle: FontStyle.italic),
                    ),
                    const SizedBox(height: 10),

                    // The text field to enter a vessel ID.
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: TextField(
                        controller: _vesselController,
                        decoration: InputDecoration(
                          labelText: 'Enter the Vessel name ',
                          errorText: _validation
                              ? 'Please enter a Vessel name or ID'
                              : null,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: app_globals.getTextColour(), width: 1),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Sets the vessel ID for use throughout the application and redirects
                    // to the home page.
                    ElevatedButton(
                      onPressed: () {
                        // Checks if the text controller is empty and displays a
                        // validation error, else sets the vesselID to be parsed
                        // into all pages of the application.
                        if (_vesselController.text.isEmpty) {
                          setState(() {
                            _validation = true;
                          });
                        } else {
                          setState(() {
                            _validation = false;
                          });
                          vesselID = _vesselController.text;
                          runApp(const ShipApp());
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          primary: AppColours.appPurple),
                      child: const Text('Continue to Application'),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

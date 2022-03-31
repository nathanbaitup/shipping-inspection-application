
// ===========================================
// Title: Drawer Settings
//
// Original Author: Matt Barnett
// Contributors: Matt Barnett, Nathan Baitup, Osama Ilyas
// Commented By: Matt Barnett
//
// Created: Feb 13, 2022 3:38pm
// Last Modified: Mar 31, 2022 7:29am
// ===========================================

// External Imports
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:settings_ui/settings_ui.dart';

// Internal Imports
import 'package:shipping_inspection_app/main.dart';
import 'package:shipping_inspection_app/sectors/drawer/settings/settings_channels.dart';
import 'package:shipping_inspection_app/sectors/drawer/settings/settings_sound.dart';
import 'package:shipping_inspection_app/sectors/drawer/settings/settings_username.dart';
import '../../utils/app_colours.dart';
import 'settings/settings_history.dart';

// App Globals
import 'package:shipping_inspection_app/sectors/drawer/drawer_globals.dart'
    as app_globals;


class MenuSettings extends StatefulWidget {
  const MenuSettings({Key? key}) : super(key: key);

  @override
  State<MenuSettings> createState() => _MenuSettingsState();
}

class _MenuSettingsState extends State<MenuSettings> {

  // Contains value for permissions switches reflective of whether or not
  // the application has the relevant permissions.
  bool cameraSwitch = false;
  bool micSwitch = false;

  // Contains the subtext for the username settings tile.
  String usernameSubtext = "";

  // Update switches based on permissions provided
  Future<void> updateSwitches() async {
    var cameraStatus = await Permission.camera.status;
    if (mounted) {
      setState(() {
        if (cameraStatus.isGranted) {
          cameraSwitch = true;
        } else {
          cameraSwitch = false;
        }
      });
    }

    var micStatus = await Permission.microphone.status;
    if (mounted) {
      setState(() {
        if (micStatus.isGranted) {
          micSwitch = true;
        } else {
          micSwitch = false;
        }
      });
    }
  }

  // Updates username settings tile subtext
  void updateText() {
    setState(() {
      usernameSubtext = "Currently '" + app_globals.getUsername() + "'";
    });
  }

  @override
  Widget build(BuildContext context) {
    updateSwitches();
    updateText();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: app_globals.getAppbarColour(),
        iconTheme: const IconThemeData(
          color: AppColours.appPurple,
        ),
      ),
      body: SettingsList(
        sections: [
          SettingsSection(
            title: Text(
              'Common',
              style: app_globals.getSettingsTitleStyle(),
            ),
            tiles: [

              // Shows current application language in subtext.
              SettingsTile(
                title: const Text('Language'),
                leading:
                    const Icon(Icons.language, color: AppColours.appPurple),
                value: const Text('English'),
                onPressed: (BuildContext context) {},
              ),

              // Creates new instance of history separate from the home hub.
              SettingsTile.navigation(
                title: const Text('History'),
                leading: const Icon(Icons.history, color: AppColours.appPurple),
                onPressed: (BuildContext context) {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) =>
                          const SettingsHistory()));
                },
              ),

              // Creates new instance of "SettingsChannels" page.
              SettingsTile.navigation(
                title: const Text('Channels'),
                leading:
                    const Icon(Icons.video_call, color: AppColours.appPurple),
                onPressed: (BuildContext context) {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) =>
                          const SettingsChannels()));
                },
              ),

              // Toggles whether or not the tutorial for the AR section appears
              // when accessing AR functionality.
              SettingsTile.switchTile(
                title: const Text('Tutorial'),
                leading: const Icon(Icons.book, color: AppColours.appPurple),
                activeSwitchColor: AppColours.appPurple,
                initialValue: app_globals.tutorialEnabled,
                onToggle: (bool value) {
                  app_globals.setTutorialEnabled(value);
                  if (app_globals.getTutorialEnabled()) {
                    // Save record that tutorial was enabled.
                    app_globals.addRecord("settings-enable", app_globals.getUsername(),
                        DateTime.now(), "AR Tutorial");
                  } else {
                    // Save record that tutorial was disabled.
                    app_globals.addRecord("settings-disable", app_globals.getUsername(),
                        DateTime.now(), "AR Tutorial");
                  }
                },
              ),

              // Toggles whether the application theme is inline with the device
              // theme. Directly impacts dark mode slider.
              SettingsTile.switchTile(
                title: const Text('Use System Theme'),
                activeSwitchColor: AppColours.appPurple,
                leading: const Icon(Icons.phone_android,
                    color: AppColours.appPurple),
                onPressed: (BuildContext context) {},
                initialValue: app_globals.getSystemThemeEnabled(),
                onToggle: (bool value) {

                  app_globals.toggleSystemThemeEnabled();

                  if (app_globals.getSystemThemeEnabled()) {

                    // If system theme is enabled, refresh application.
                    themeNotifier.value = ThemeMode.system;

                    // If system theme is dark, enable dark mode. Else, enable
                    // light mode.
                    if (MediaQuery.of(context).platformBrightness ==
                        Brightness.dark) {
                      app_globals.darkModeEnabled = true;
                    } else {
                      app_globals.darkModeEnabled = false;
                    }
                  } else {}
                  setState(() {});

                  // Save new settings changes to shared preferences.
                  app_globals.savePrefs();
                  value = app_globals.getSystemThemeEnabled();
                },
              ),

              // Adjusts whether the theme is dark or light mode independently
              // of the system theme.
              SettingsTile.switchTile(
                title: const Text('Dark Mode'),
                activeSwitchColor: AppColours.appPurple,
                enabled: !app_globals.getSystemThemeEnabled(),
                leading: Icon(
                    Icons.dark_mode,
                    color: app_globals.getIconColourCheck(
                        AppColours.appPurpleLight,
                        !app_globals.getSystemThemeEnabled()
                    )
                ),
                initialValue: app_globals.getDarkModeEnabled(),
                onToggle: (bool value) {

                  app_globals.toggleDarkModeEnabled();

                  // Refresh application state for to either dark or light mode.
                  if (app_globals.getDarkModeEnabled()) {
                    themeNotifier.value = ThemeMode.dark;
                  } else {
                    themeNotifier.value = ThemeMode.light;
                  }
                  setState(() {});

                  // Save new theme changes to shared preferences.
                  app_globals.savePrefs();
                  value = app_globals.getDarkModeEnabled();
                },
              ),

            ],
          ),

          SettingsSection(
            title: Text(
              'Account',
              style: app_globals.getSettingsTitleStyle(),
            ),
            tiles: [

              // Creates new instance of "SettingsUsername" page.
              SettingsTile.navigation(
                title: const Text('Username'),
                leading:
                    const Icon(Icons.text_format, color: AppColours.appPurple),
                value: Text(usernameSubtext),
                onPressed: (BuildContext context) {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) =>
                          const SettingsUsername()));
                },
              ),

            ],
          ),

          SettingsSection(
            title: Text(
              'System',
              style: app_globals.getSettingsTitleStyle(),
            ),
            tiles: [

              // Allows users to adjust the application's camera permissions
              // in conjunction to their current device.
              SettingsTile.switchTile(
                title: const Text('Camera'),
                activeSwitchColor: AppColours.appPurple,
                leading: const Icon(
                    Icons.camera_alt,
                    color: AppColours.appPurple
                ),
                initialValue: cameraSwitch,
                onToggle: (bool value) async {

                  // Get current status of camera permissions.
                  var status = await Permission.camera.status;

                  // If the application does not have access to the camera...
                  if (status.isDenied) {
                    // Request the user gives camera access
                    if (await Permission.camera.request().isGranted) {
                      // Add a record to show that camera permissions were granted
                      app_globals.addRecord("settings-permission-add",
                          app_globals.getUsername(), DateTime.now(), "Camera");
                      await FirebaseFirestore.instance
                          .collection("History_Logging")
                          .add({
                            'title': "Adding camera permissions",
                            'username': app_globals.getUsername(),
                            'time': DateTime.now(),
                            'permission': 'Camera',
                          })
                          .then((value) => debugPrint("Record has been added"))
                          .catchError((error) =>
                              debugPrint("Failed to add record: $error"));

                      // Save changes to shared preferences.
                      app_globals.savePrefs();

                      // Update the home page to reflect any settings pages.
                      app_globals.homeStateUpdate();

                      // Set settings tile switch to true to demonstrate that
                      // the camera permissions were granted.
                      cameraSwitch = true;

                      // Provide feedback to the user to demonstrate their action
                      // was successful.
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Camera Permission Granted!')),
                      );
                    } else {
                      // If the request was denied, set the switch to false and
                      // open the device's camera settings.
                      cameraSwitch = false;
                      openAppSettings();
                    }
                  } else {
                    // If the user already has granted camera permissions, open
                    // the device's camera settings so that they can manually
                    // adjust them.
                    openAppSettings();
                  }

                  setState(() {
                    value = cameraSwitch;
                  });
                },
              ),

              // Allows users to adjust the application's microphone permissions
              // in conjunction to their current device.
              SettingsTile.switchTile(
                title: const Text('Microphone'),
                activeSwitchColor: AppColours.appPurple,
                leading: const Icon(
                    Icons.mic,
                    color: AppColours.appPurple
                ),
                initialValue: micSwitch,
                onToggle: (bool value) async {

                  // Get current status of microphone permissions.
                  var status = await Permission.microphone.status;

                  // If the application does not have access to the microphone...
                  if (status.isDenied) {
                    // Request the user gives microphone access
                    if (await Permission.microphone.request().isGranted) {

                      // Add a record to show that microphone permissions
                      // were granted.
                      app_globals.addRecord("settings-permission-add",
                          app_globals.getUsername(), DateTime.now(), "Microphone");
                      await FirebaseFirestore.instance
                          .collection("History_Logging")
                          .add({
                            'title': "Adding microphone permissions",
                            'username': app_globals.getUsername(),
                            'time': DateTime.now(),
                            'permission': 'Microphone',
                          })
                          .then((value) => debugPrint("Record has been added"))
                          .catchError((error) =>
                              debugPrint("Failed to add record: $error"));

                      // Save changes to shared preferences.
                      app_globals.savePrefs();

                      // Update the home page to reflect any settings pages.
                      app_globals.homeStateUpdate();

                      // Set settings tile switch to true to demonstrate that
                      // the microphone permissions were granted.
                      micSwitch = true;

                      // Provide feedback to the user to demonstrate their action
                      // was successful.
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Microphone Permission Granted!')),
                      );
                    } else {
                      // If the request was denied, set the switch to false and
                      // open the device's microphone settings.
                      micSwitch = false;
                      openAppSettings();
                    }
                  } else {
                    // If the user already has granted microphone permissions,
                    // open the device's microphone settings so that they
                    // can manually adjust them.
                    openAppSettings();
                  }
                  setState(() {
                    value = micSwitch;
                  });
                },
              ),

              // Creates new instance of "SettingsSound" page.
              SettingsTile.navigation(
                title: const Text('Sound'),
                leading:
                    const Icon(Icons.volume_up, color: AppColours.appPurple),
                onPressed: (BuildContext context) {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) =>
                          const SettingsSound()));
                },
              ),

            ],
          ),

          // Here are credits given to the creators of the AR models that were
          // produced externally. All usage is licensed under Creative
          // Commons Attribution.
          SettingsSection(
            title: Text(
                "AR Model Credits",
                style: app_globals.getSettingsTitleStyle(),
            ),
            tiles: [
              SettingsTile(
                title: const Text(
                  '"Fire Extinguisher" (https://skfb.ly/onUZp) by oooFFFFEDDMODELS is licensed under Creative Commons Attribution (http://creativecommons.org/licenses/by/4.0/).',
                  style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                ),
              ),
              SettingsTile(
                title: const Text(
                  '"Valve II" (https://skfb.ly/6zxYE) by Víctor Hernández is licensed under Creative Commons Attribution (http://creativecommons.org/licenses/by/4.0/).',
                  style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                ),
              ),
              SettingsTile(
                title: const Text(
                  '"Lifeboat Compact" (https://skfb.ly/o6SXv) by jeffgeoff95 is licensed under Creative Commons Attribution (http://creativecommons.org/licenses/by/4.0/).',
                  style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

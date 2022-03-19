import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shipping_inspection_app/sectors/drawer/settings/settings_channels.dart';
import 'package:shipping_inspection_app/sectors/drawer/settings/settings_sound.dart';
import 'package:shipping_inspection_app/sectors/drawer/settings/settings_username.dart';
import 'package:shipping_inspection_app/utils/colours.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shipping_inspection_app/sectors/drawer/drawer_globals.dart' as globals;

import 'settings/settings_history.dart';

class MenuSettings extends StatefulWidget {
  const MenuSettings({Key? key}) : super(key: key);

  @override
  State<MenuSettings> createState() => _MenuSettingsState();
}

class _MenuSettingsState extends State<MenuSettings> {

  bool isSwitched = false;

  bool cameraSwitch = false;
  bool micSwitch = false;

  String usernameSubtext = "";

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

  void updateText() {
    setState(() {
      usernameSubtext = "Currently '" + globals.getUsername() + "'";
    });
  }

  @override
  Widget build(BuildContext context) {
    updateSwitches();
    updateText();
    return Scaffold(
      appBar: AppBar(
        
        iconTheme: const IconThemeData(
          color: LightColors.sPurple,
        ),
      ),

      body: SettingsList(
        sections: [

          SettingsSection(
            title: const Text(
                'Common',
                style: TextStyle(
                  color: Colors.black,
                  decorationColor: LightColors.sPurple,
                  decorationThickness: 2,
                  decoration: TextDecoration.underline
                ),
            ),
            tiles: [
              SettingsTile(
                title: const Text('Language'),
                leading: const Icon(Icons.language,
                    color: LightColors.sPurple),
                value: const Text('English'),
                onPressed: (BuildContext context) {},
              ),
              SettingsTile.navigation(
                title: const Text('History'),
                leading: const Icon(Icons.history,
                    color: LightColors.sPurple),
                onPressed: (BuildContext context) {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => const SettingsHistory()));
                },
              ),
              SettingsTile.navigation(
                title: const Text('Channels'),
                leading: const Icon(Icons.video_call,
                    color: LightColors.sPurple),
                onPressed: (BuildContext context) {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => const SettingsChannels()));
                },
              ),
              SettingsTile.switchTile(
                title: const Text('Night Mode'),
                activeSwitchColor: LightColors.sPurple,
                leading: const Icon(Icons.phone_android,
                    color: LightColors.sPurple),
                initialValue: isSwitched,
                onToggle: (value) {
                  setState(() {
                    isSwitched = value;
                  });
                },
              ),
            ],
          ),

          SettingsSection(
            title: const Text(
              'Account',
              style: TextStyle(
                  color: Colors.black,
                  decorationColor: Colors.purple,
                  decorationThickness: 2,
                  decoration: TextDecoration.underline
              ),
            ),
            tiles: [
              SettingsTile.navigation(
                title: const Text('Username'),
                leading: const Icon(Icons.text_format,
                    color: LightColors.sPurple),
                value: Text(usernameSubtext),
                onPressed: (BuildContext context) {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => const SettingsUsername()));
                },
              ),
            ],
          ),

          SettingsSection(
              title: const Text(
                'System',
                style: TextStyle(
                    color: Colors.black,
                    decorationColor: LightColors.sPurple,
                    decorationThickness: 2,
                    decoration: TextDecoration.underline
                ),
              ),
            tiles: [
              SettingsTile.switchTile(
                title: const Text('Camera'),
                activeSwitchColor: LightColors.sPurple,
                leading: const Icon(Icons.camera_alt,
                    color: LightColors.sPurple),
                onToggle: (bool value) async {
                  var status = await Permission.camera.status;
                  if (status.isDenied) {
                    if (await Permission.camera.request().isGranted) {
                      globals.addRecord("settings-permission-add", globals.getUsername(), DateTime.now(), "Camera");
                      cameraSwitch = true;
                      ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Camera Permission Granted!')),
                      );
                    } else {
                      cameraSwitch = false;
                      openAppSettings();
                    }
                  } else {
                  openAppSettings();
                  }
                  setState(() {
                    value = cameraSwitch;
                  });
                }, initialValue: cameraSwitch,

              ),

              SettingsTile.switchTile(
                title: const Text('Microphone'),
                activeSwitchColor: LightColors.sPurple,
                leading: const Icon(Icons.mic,
                    color: LightColors.sPurple),
                onToggle: (bool value) async {
                  var status = await Permission.microphone.status;
                  if (status.isDenied) {
                    if (await Permission.microphone.request().isGranted) {
                      globals.addRecord("settings-permission-add", globals.getUsername(), DateTime.now(), "Microphone");
                      micSwitch = true;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Microphone Permission Granted!')),
                      );
                    } else {
                      micSwitch = false;
                      openAppSettings();
                    }
                  } else {
                    openAppSettings();
                  }
                  setState(() {
                    value = micSwitch;
                  });
                }, initialValue: micSwitch,
              ),

              SettingsTile.navigation(
                title: const Text('Sound'),
                leading: const Icon(Icons.volume_up,
                    color: LightColors.sPurple),
                onPressed: (BuildContext context) {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => const SettingsSound()));
                },
              ),
            ]
          ),

        ]
      )
    );
  }

}
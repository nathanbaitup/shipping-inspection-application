import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shipping_inspection_app/sectors/drawer/settings/settings_sound.dart';
import 'package:shipping_inspection_app/sectors/drawer/settings/settings_username.dart';
import 'package:shipping_inspection_app/utils/colours.dart';
import 'package:permission_handler/permission_handler.dart';

class MenuSettings extends StatefulWidget {
  const MenuSettings({Key? key}) : super(key: key);

  @override
  State<MenuSettings> createState() => _MenuSettingsState();
}

class _MenuSettingsState extends State<MenuSettings> {

  bool isSwitched = false;

  bool cameraSwitch = false;
  bool micSwitch = false;

  Future<void> updateSwitches() async {
    var cameraStatus = await Permission.camera.status;
    if (cameraStatus.isGranted) {
      setState(() { cameraSwitch = true; });
    } else { setState(() { cameraSwitch = false; }); }

    var micStatus = await Permission.microphone.status;
    if (micStatus.isGranted) {
      setState(() { micSwitch = true; });
    } else { setState(() { micSwitch = false; }); }
  }

  @override
  Widget build(BuildContext context) {
    updateSwitches();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
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
                title: const Text('Status'),
                leading: const Icon(Icons.person,
                    color: LightColors.sPurple),
                value: const Text('Online'),
                onPressed: (BuildContext context) {},
              ),
              SettingsTile(
                title: const Text('Language'),
                leading: const Icon(Icons.language,
                    color: LightColors.sPurple),
                value: const Text('English'),
                onPressed: (BuildContext context) {},
              ),
              SettingsTile.switchTile(
                title: const Text('Use System Theme'),
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
                      cameraSwitch = true;
                      ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Camera Permission Granted!')),
                      );
                    } else {
                      cameraSwitch = false;
                    }
                  } else {
                  openAppSettings();
                  }
                  setState(() {
                    value = cameraSwitch;
                  });
                }, initialValue: cameraSwitch,

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
              SettingsTile.switchTile(
                title: const Text('Microphone'),
                activeSwitchColor: LightColors.sPurple,
                leading: const Icon(Icons.mic,
                    color: LightColors.sPurple),
                onToggle: (bool value) async {
                  var status = await Permission.microphone.status;
                  if (status.isDenied) {
                    if (await Permission.microphone.request().isGranted) {
                      micSwitch = true;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Microphone Permission Granted!')),
                      );
                    } else {
                      micSwitch = false;
                    }
                  } else {
                    openAppSettings();
                  }
                  setState(() {
                    value = micSwitch;
                  });
                }, initialValue: micSwitch,
              ),
            ]
          ),

        ]
      )
    );
  }

}
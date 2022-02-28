import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shipping_inspection_app/sectors/drawer/settings/settings_username.dart';
import 'package:shipping_inspection_app/utils/colours.dart';

class MenuSettings extends StatefulWidget {
  const MenuSettings({Key? key}) : super(key: key);

  @override
  State<MenuSettings> createState() => _MenuSettingsState();
}

class _MenuSettingsState extends State<MenuSettings> {

  bool isSwitched = false;

  @override
  Widget build(BuildContext context) {
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
                  print("PRESSED");
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
              SettingsTile.navigation(
                title: const Text('Camera'),
                leading: const Icon(Icons.camera_alt,
                    color: LightColors.sPurple),
                onPressed: (BuildContext context) {},
              ),
              SettingsTile.navigation(
                title: const Text('Sound'),
                leading: const Icon(Icons.volume_up,
                    color: LightColors.sPurple),
                onPressed: (BuildContext context) {},
              ),
              SettingsTile.navigation(
                title: const Text('Microphone'),
                leading: const Icon(Icons.mic,
                    color: LightColors.sPurple),
                onPressed: (BuildContext context) {},
              ),
            ]
          ),

        ]
      )
    );
  }

}
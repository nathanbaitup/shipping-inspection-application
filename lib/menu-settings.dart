import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';

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
          color: Colors.purple,
        ),
      ),

      body: SettingsList(
        sections: [

          SettingsSection(
            title: const Text(
                'Common',
                style: TextStyle(
                  color: Colors.black,
                  decorationColor: Colors.purple,
                  decorationThickness: 2,
                  decoration: TextDecoration.underline
                ),
            ),
            tiles: [
              SettingsTile(
                title: const Text('Status'),
                leading: const Icon(Icons.person,
                    color: Colors.purple),
                value: const Text('Online'),
                onPressed: (BuildContext context) {},
              ),
              SettingsTile(
                title: const Text('Language'),
                leading: const Icon(Icons.language,
                    color: Colors.purple),
                value: const Text('English'),
                onPressed: (BuildContext context) {},
              ),
              SettingsTile.switchTile(
                title: const Text('Use System Theme'),
                leading: const Icon(Icons.phone_android,
                    color: Colors.purple),
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
                'System',
                style: TextStyle(
                    color: Colors.black,
                    decorationColor: Colors.purple,
                    decorationThickness: 2,
                    decoration: TextDecoration.underline
                ),
              ),
            tiles: [
              SettingsTile.navigation(
                title: const Text('Camera'),
                leading: const Icon(Icons.camera_alt,
                    color: Colors.purple),
                onPressed: (BuildContext context) {},
              ),
              SettingsTile.navigation(
                title: const Text('Sound'),
                leading: const Icon(Icons.volume_up,
                    color: Colors.purple),
                onPressed: (BuildContext context) {},
              ),
              SettingsTile.navigation(
                title: const Text('Microphone'),
                leading: const Icon(Icons.mic,
                    color: Colors.purple),
                onPressed: (BuildContext context) {},
              ),
            ]
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
                    color: Colors.purple),
                onPressed: (BuildContext context) {},
              ),
              SettingsTile.navigation(
                title: const Text('Password'),
                leading: const Icon(Icons.password,
                    color: Colors.purple),
                onPressed: (BuildContext context) {},
              ),
              SettingsTile.navigation(
                title: const Text('Phone number'),
                leading: const Icon(Icons.phone,
                    color: Colors.purple),
                onPressed: (BuildContext context) {},
              ),
              SettingsTile.navigation(
                title: const Text('Email'),
                leading: const Icon(Icons.email,
                    color: Colors.purple),
                onPressed: (BuildContext context) {},
              ),
              SettingsTile.navigation(
                title: const Text('Sign out'),
                leading: const Icon(Icons.exit_to_app,
                    color: Colors.purple),
                onPressed: (BuildContext context) {},
              ),
            ],
          ),

        ]
      )
    );
  }

}
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
                title: Text('Status'),
                leading: Icon(Icons.person,
                    color: Colors.purple),
                value: Text('Online'),
                onPressed: (BuildContext context) {},
              ),
              SettingsTile(
                title: Text('Language'),
                leading: Icon(Icons.language,
                    color: Colors.purple),
                value: Text('English'),
                onPressed: (BuildContext context) {},
              ),
              SettingsTile.switchTile(
                title: Text('Use System Theme'),
                leading: Icon(Icons.phone_android,
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
                title: Text('Camera'),
                leading: Icon(Icons.camera_alt,
                    color: Colors.purple),
                onPressed: (BuildContext context) {},
              ),
              SettingsTile.navigation(
                title: Text('Sound'),
                leading: Icon(Icons.volume_up,
                    color: Colors.purple),
                onPressed: (BuildContext context) {},
              ),
              SettingsTile.navigation(
                title: Text('Microphone'),
                leading: Icon(Icons.mic,
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
                title: Text('Username'),
                leading: Icon(Icons.text_format,
                    color: Colors.purple),
                onPressed: (BuildContext context) {},
              ),
              SettingsTile.navigation(
                title: Text('Password'),
                leading: Icon(Icons.password,
                    color: Colors.purple),
                onPressed: (BuildContext context) {},
              ),
              SettingsTile.navigation(
                title: Text('Phone number'),
                leading: Icon(Icons.phone,
                    color: Colors.purple),
                onPressed: (BuildContext context) {},
              ),
              SettingsTile.navigation(
                title: Text('Email'),
                leading: Icon(Icons.email,
                    color: Colors.purple),
                onPressed: (BuildContext context) {},
              ),
              SettingsTile.navigation(
                title: Text('Sign out'),
                leading: Icon(Icons.exit_to_app,
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
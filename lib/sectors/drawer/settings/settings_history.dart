import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shipping_inspection_app/utils/colours.dart';

import '../drawer_history.dart';

class SettingsHistory extends StatefulWidget {
  const SettingsHistory({Key? key}) : super(key: key);

  @override
  State<SettingsHistory> createState() => _SettingsHistoryState();
}

class _SettingsHistoryState extends State<SettingsHistory> {


  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(
            color: LightColors.sPurple,
          ),
        ),

      body: Column(
        children: [

          Container(
            color: const Color(0xFFF0F0F0),
            padding: const EdgeInsets.only(
              top: 20,
            ),
            child: Center(
              child: TextButton (
                style: TextButton.styleFrom(
                  primary: Colors.white,
                  backgroundColor: LightColors.sPurpleL,
                  elevation: 2,
                  padding: const EdgeInsets.all(15.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0)),
                ),
                child: const Text("Check History Logs"),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => const MenuHistory()));
                },
              )
            ),
          ),

          Expanded(
            child: SettingsList(
              sections: [
                SettingsSection(
                  title: const Text(
                    'Log Preferences',
                    style: TextStyle(
                        color: Colors.black,
                        decorationColor: LightColors.sPurple,
                        decorationThickness: 2,
                        decoration: TextDecoration.underline
                    ),
                  ),
                  tiles: [
                    SettingsTile.switchTile(
                      title: const Text('Section Entering'),
                      leading: const Icon(Icons.history,
                          color: LightColors.sPurple),
                      initialValue: null,
                      onToggle: (bool value) {  },
                    ),
                    SettingsTile.switchTile(
                      title: const Text('Section Response'),
                      leading: const Icon(Icons.history,
                          color: LightColors.sPurple),
                      initialValue: null,
                      onToggle: (bool value) {  },
                    ),
                    SettingsTile.switchTile(
                      title: const Text('Settings Change'),
                      leading: const Icon(Icons.history,
                          color: LightColors.sPurple),
                      initialValue: null,
                      onToggle: (bool value) {  },
                    ),
                    SettingsTile.switchTile(
                      title: const Text('QR Usage'),
                      leading: const Icon(Icons.history,
                          color: LightColors.sPurple),
                      initialValue: null,
                      onToggle: (bool value) {  },
                    ),
                    SettingsTile.switchTile(
                      title: const Text('Communications'),
                      leading: const Icon(Icons.history,
                          color: LightColors.sPurple),
                      initialValue: null,
                      onToggle: (bool value) {  },
                    ),
                  ],
                ),
              ]
            ),
          )

        ]
      )
    );
  }

}

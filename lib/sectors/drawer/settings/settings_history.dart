import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shipping_inspection_app/utils/colours.dart';

import '../drawer_history.dart';
import 'package:shipping_inspection_app/sectors/drawer/drawer_globals.dart' as globals;

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
                      title: const Text("Section Entering"),
                      leading: const Icon(Icons.door_back_door_outlined,
                          color: LightColors.sPurple),
                      initialValue: globals.historyPrefs[0],
                      activeSwitchColor: LightColors.sPurple,
                      onToggle: (bool value) {
                        globals.changeHistoryPref("Section Entering", !globals.historyPrefs[0]);
                        setState(() { value = globals.historyPrefs[0]; });
                      },
                    ),
                    SettingsTile.switchTile(
                      title: const Text("Section Response"),
                      leading: const Icon(Icons.newspaper,
                          color: LightColors.sPurple),
                      initialValue: globals.historyPrefs[1],
                      activeSwitchColor: LightColors.sPurple,
                      onToggle: (bool value) {
                        globals.changeHistoryPref("Section Response", !globals.historyPrefs[1]);
                        setState(() { value = globals.historyPrefs[1]; });
                      },
                    ),
                    SettingsTile.switchTile(
                      title: const Text("Settings Change"),
                      leading: const Icon(Icons.settings,
                          color: LightColors.sPurple),
                      initialValue: globals.historyPrefs[2],
                      activeSwitchColor: LightColors.sPurple,
                      onToggle: (bool value) {
                        globals.changeHistoryPref("Settings Change", !globals.historyPrefs[2]);
                        setState(() { value = globals.historyPrefs[2]; });
                      },
                    ),
                    SettingsTile.switchTile(
                      title: const Text("QR Usage"),
                      leading: const Icon(Icons.qr_code,
                          color: LightColors.sPurple),
                      initialValue: globals.historyPrefs[3],
                      activeSwitchColor: LightColors.sPurple,
                      onToggle: (bool value) {
                        globals.changeHistoryPref("QR Usage", !globals.historyPrefs[3]);
                        setState(() { value = globals.historyPrefs[3]; });
                      },
                    ),
                    SettingsTile.switchTile(
                      title: const Text("Communications"),
                      leading: const Icon(Icons.phone,
                          color: LightColors.sPurple),
                      initialValue: globals.historyPrefs[4],
                      activeSwitchColor: LightColors.sPurple,
                      onToggle: (bool value) {
                        globals.changeHistoryPref("Communications", !globals.historyPrefs[4]);
                        setState(() { value = globals.historyPrefs[4]; });
                      },
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

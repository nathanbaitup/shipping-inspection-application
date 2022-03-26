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

Color initButtonColourClear() {
  Color newColor;
  if(globals.historyEnabled) {
    newColor = LightColors.sRed;
  } else {
    newColor = Colors.grey;
  }
  return newColor;
}

Color initButtonColourCheck() {
  Color newColor;
  if(globals.historyEnabled) {
    newColor = LightColors.sPurpleL;
  } else {
    newColor = Colors.grey;
  }
  return newColor;
}

Color initPrefsColourCheck() {
  Color newColor;
  if(globals.historyEnabled) {
    newColor = LightColors.sPurple;
  } else {
    newColor = Colors.grey;
  }
  return newColor;
}

class _SettingsHistoryState extends State<SettingsHistory> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          backgroundColor: globals.getAppbarColour(),
          iconTheme: const IconThemeData(
            color: LightColors.sPurple,
          ),
        ),

      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          SettingsList(
              shrinkWrap: true,
              sections: [
                SettingsSection(
                    title: Text(
                      'Logs',
                      style: TextStyle(
                          color: globals.getTextColour(),
                          decorationColor: LightColors.sPurple,
                          decorationThickness: 2,
                          decoration: TextDecoration.underline
                      ),
                    ),
                    tiles: [
                      SettingsTile.switchTile(
                        title: const Text("History Logging"),
                        leading: const Icon(Icons.history,
                            color: LightColors.sPurple),
                        initialValue: globals.historyEnabled,
                        activeSwitchColor: LightColors.sPurple,
                        onToggle: (bool value) {
                          globals.historyEnabled = !globals.historyEnabled;
                          setState(() {  value = globals.historyEnabled; });
                        },
                      )
                    ]
                ),
                SettingsSection(
                  title: Text(
                    'Log Preferences',
                    style: TextStyle(
                        color: globals.getTextColour(),
                        decorationColor: LightColors.sPurple,
                        decorationThickness: 2,
                        decoration: TextDecoration.underline
                    ),
                  ),
                  tiles: [
                    SettingsTile.switchTile(
                      title: const Text("Section Entering"),
                      leading: Icon(Icons.door_back_door_outlined,
                          color: initPrefsColourCheck()),
                      initialValue: globals.historyPrefs[0],
                      activeSwitchColor: LightColors.sPurple,
                      enabled: globals.historyEnabled,
                      onToggle: (bool value) {
                        globals.changeHistoryPref("Section Entering", !globals.historyPrefs[0]);
                        setState(() { value = globals.historyPrefs[0]; });
                        globals.savePrefs();
                      },
                    ),
                    SettingsTile.switchTile(
                      title: const Text("Section Response"),
                      leading: Icon(Icons.newspaper,
                          color: initPrefsColourCheck()),
                      initialValue: globals.historyPrefs[1],
                      activeSwitchColor: LightColors.sPurple,
                      enabled: globals.historyEnabled,
                      onToggle: (bool value) {
                        globals.changeHistoryPref("Section Response", !globals.historyPrefs[1]);
                        setState(() { value = globals.historyPrefs[1]; });
                      },
                    ),
                    SettingsTile.switchTile(
                      title: const Text("Settings Change"),
                      leading: Icon(Icons.settings,
                          color: initPrefsColourCheck()),
                      initialValue: globals.historyPrefs[2],
                      activeSwitchColor: LightColors.sPurple,
                      enabled: globals.historyEnabled,
                      onToggle: (bool value) {
                        globals.changeHistoryPref("Settings Change", !globals.historyPrefs[2]);
                        setState(() { value = globals.historyPrefs[2]; });
                        globals.savePrefs();
                      },
                    ),
                    SettingsTile.switchTile(
                      title: const Text("QR Usage"),
                      leading: Icon(Icons.qr_code,
                          color: initPrefsColourCheck()),
                      initialValue: globals.historyPrefs[3],
                      activeSwitchColor: LightColors.sPurple,
                      enabled: globals.historyEnabled,
                      onToggle: (bool value) {
                        globals.changeHistoryPref("QR Usage", !globals.historyPrefs[3]);
                        setState(() { value = globals.historyPrefs[3]; });
                        globals.savePrefs();
                      },
                    ),
                    SettingsTile.switchTile(
                      title: const Text("Communications"),
                      leading: Icon(Icons.phone,
                          color: initPrefsColourCheck()),
                      initialValue: globals.historyPrefs[4],
                      activeSwitchColor: LightColors.sPurple,
                      enabled: globals.historyEnabled,
                      onToggle: (bool value) {
                        globals.changeHistoryPref("Communications", !globals.historyPrefs[4]);
                        setState(() { value = globals.historyPrefs[4]; });
                        globals.savePrefs();
                      },
                    ),
                  ],
                ),
              ]
          ),

          Container(
            color: globals.getSettingsBgColour(),
            padding: const EdgeInsets.only(
              top: 10,
              bottom: 10,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                    primary: Colors.white,
                    backgroundColor: initButtonColourCheck(),
                    elevation: 2,
                    padding: const EdgeInsets.all(15.0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0)),
                  ),
                  child: const Text("Check History"),
                  onPressed: globals.historyEnabled
                      ? () => {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) => const MenuHistory()))
                      }
                      : null
                ),

                const SizedBox(
                  width: 20,
                ),

                TextButton(
                  style: TextButton.styleFrom(
                    primary: Colors.white,
                    backgroundColor: initButtonColourClear(),
                    elevation: 2,
                    padding: const EdgeInsets.all(15.0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0)),
                  ),
                  child: const Text("Clear History"),
                  onPressed: globals.historyEnabled
                      ? () => {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("Clear History"),
                              content: const Text("Are you sure you want to clear all history?"),
                              actions: [
                                ElevatedButton(
                                  onPressed: () {
                                    globals.records = [];
                                    Navigator.pop(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: LightColors.sRed,
                                  ),
                                  child: const Text('Clear')
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: LightColors.sPurpleL,
                                  ),
                                  child: const Text('Cancel')
                                ),
                              ]
                            );
                          },
                        )
                      }
                      : null
                )
              ]
            ),
          ),


          Expanded(
            child: Container(
              color: globals.getSettingsBgColour(),
            )
          )

        ]
      )
    );
  }

}

import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';

import '../../../shared/history_cleardialog.dart';
import '../../../utils/app_colours.dart';
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
        resizeToAvoidBottomInset : false,
        appBar: AppBar(
          backgroundColor: globals.getAppbarColour(),
          iconTheme: const IconThemeData(
            color: AppColours.appPurple,
          ),
        ),

        body: Column(children: [
          SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                SettingsList(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    sections: [
                      SettingsSection(
                          title: Text(
                            'Logs',
                            style: globals.getSettingsTitleStyle(),
                          ),
                          tiles: [
                            SettingsTile.switchTile(
                              title: const Text("History Logging"),
                              leading: const Icon(Icons.history,
                                  color: AppColours.appPurple),
                              initialValue: globals.historyEnabled,
                              activeSwitchColor: AppColours.appPurple,
                              onToggle: (bool value) {
                                globals.historyEnabled =
                                    !globals.historyEnabled;
                                if(globals.historyEnabled) {
                                  globals.addRecord(
                                      "settings-enable",
                                      globals.getUsername(),
                                      DateTime.now(),
                                      "History Logging"
                                  );
                                } else {
                                  globals.addRecord(
                                      "settings-disable",
                                      globals.getUsername(),
                                      DateTime.now(),
                                      "History Logging"
                                  );
                                }
                                setState(() {
                                  value = globals.historyEnabled;
                                });
                              },
                            )
                          ]),
                      SettingsSection(
                        title: Text(
                          'Log Preferences',
                          style: globals.getSettingsTitleStyle(),
                        ),
                        tiles: [
                          SettingsTile.switchTile(
                            title: const Text("Section Entering"),
                            leading: Icon(Icons.door_back_door_outlined,
                                color: globals.getIconColourCheck(
                                    AppColours.appPurpleLight,
                                    globals.historyEnabled)),
                            initialValue: globals.historyPrefs[0],
                            activeSwitchColor: AppColours.appPurple,
                            enabled: globals.historyEnabled,
                            onToggle: (bool value) {
                              globals.changeHistoryPref(
                                  "Section Entering", !globals.historyPrefs[0]);
                              setState(() {
                                value = globals.historyPrefs[0];
                              });
                              globals.savePrefs();
                            },
                          ),
                          SettingsTile.switchTile(
                            title: const Text("Section Response"),
                            leading: Icon(Icons.newspaper,
                                color: globals.getIconColourCheck(
                                    AppColours.appPurpleLight,
                                    globals.historyEnabled)),
                            initialValue: globals.historyPrefs[1],
                            activeSwitchColor: AppColours.appPurple,
                            enabled: globals.historyEnabled,
                            onToggle: (bool value) {
                              globals.changeHistoryPref(
                                  "Section Response", !globals.historyPrefs[1]);
                              setState(() {
                                value = globals.historyPrefs[1];
                              });
                            },
                          ),
                          SettingsTile.switchTile(
                            title: const Text("Settings Change"),
                            leading: Icon(Icons.settings,
                                color: globals.getIconColourCheck(
                                    AppColours.appPurpleLight,
                                    globals.historyEnabled)),
                            initialValue: globals.historyPrefs[2],
                            activeSwitchColor: AppColours.appPurple,
                            enabled: globals.historyEnabled,
                            onToggle: (bool value) {
                              globals.changeHistoryPref(
                                  "Settings Change", !globals.historyPrefs[2]);
                              setState(() {
                                value = globals.historyPrefs[2];
                              });
                              globals.savePrefs();
                            },
                          ),
                          SettingsTile.switchTile(
                            title: const Text("QR Usage"),
                            leading: Icon(Icons.qr_code,
                                color: globals.getIconColourCheck(
                                    AppColours.appPurpleLight,
                                    globals.historyEnabled)),
                            initialValue: globals.historyPrefs[3],
                            activeSwitchColor: AppColours.appPurple,
                            enabled: globals.historyEnabled,
                            onToggle: (bool value) {
                              globals.changeHistoryPref(
                                  "QR Usage", !globals.historyPrefs[3]);
                              setState(() {
                                value = globals.historyPrefs[3];
                              });
                              globals.savePrefs();
                            },
                          ),
                          SettingsTile.switchTile(
                            title: const Text("Communications"),
                            leading: Icon(Icons.phone,
                                color: globals.getIconColourCheck(
                                    AppColours.appPurpleLight,
                                    globals.historyEnabled)),
                            initialValue: globals.historyPrefs[4],
                            activeSwitchColor: AppColours.appPurple,
                            enabled: globals.historyEnabled,
                            onToggle: (bool value) {
                              globals.changeHistoryPref(
                                  "Communications", !globals.historyPrefs[4]);
                              setState(() {
                                value = globals.historyPrefs[4];
                              });
                              globals.savePrefs();
                            },
                          ),
                          SettingsTile.switchTile(
                            title: const Text("Channels"),
                            leading: Icon(Icons.videocam,
                                color: globals.getIconColourCheck(
                                    AppColours.appPurpleLight,
                                    globals.historyEnabled)),
                            initialValue: globals.historyPrefs[5],
                            activeSwitchColor: AppColours.appPurple,
                            enabled: globals.historyEnabled,
                            onToggle: (bool value) {
                              globals.changeHistoryPref(
                                  "Channels", !globals.historyPrefs[5]);
                              setState(() {
                                value = globals.historyPrefs[5];
                              });
                              globals.savePrefs();
                            },
                          ),
                        ],
                      ),
                    ]),
                Container(
                  height: 75,
                  color: globals.getSettingsBgColour(),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                            style: TextButton.styleFrom(
                              primary: Colors.white,
                              backgroundColor: globals.getButtonColourCheck(
                                  AppColours.appPurpleLight, globals.historyEnabled),
                              elevation: 2,
                              padding: const EdgeInsets.all(15.0),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0)),
                            ),
                            child: const Text("Check History"),
                            onPressed: globals.historyEnabled
                                ? () => {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  const MenuHistory()))
                                    }
                                : null),
                        const SizedBox(
                          width: 20,
                        ),
                        TextButton(
                            style: TextButton.styleFrom(
                              primary: Colors.white,
                              backgroundColor: globals.getButtonColourCheck(
                                  AppColours.appRed, globals.historyEnabled),
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
                                          return historyClearDialog(context);
                                        },
                                      )
                                    }
                                : null)
                      ]),
                ),
              ])),
          Expanded(
            child: Container(
              color: globals.getSettingsBgColour(),
            ),
          )
        ]));
  }

}

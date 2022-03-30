

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../shared/history_cleardialog.dart';
import '../../utils/app_colours.dart';
import '../drawer/drawer_history.dart';
import '../drawer/settings/settings_history.dart';
import '../drawer/drawer_globals.dart' as app_globals;

Expanded historyButtons(BuildContext context) {

  return Expanded(
      child: Row(
    children: [
      TextButton(
        style: TextButton.styleFrom(
          primary: Colors.white,
          backgroundColor: AppColours.appGrey,
          elevation: 2,
          shape: const CircleBorder(),
        ),
        child: const Icon(Icons.settings),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SettingsHistory(),
            ),
          );
        },
      ),
      const Spacer(),
      Row(children: [
        SizedBox(
          height: 40,
          child: TextButton(
              style: TextButton.styleFrom(
                primary: Colors.white,
                backgroundColor: app_globals.getButtonColourCheck(
                    AppColours.appRed,
                    app_globals.getHistoryEnabled()),
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0)),
              ),
              child: const Text("Clear"),
              onPressed: app_globals.getHistoryEnabled()
                  ? () => {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return historyClearDialog(context);
                  },
                )
              }
                  : null),
        ),
        TextButton(
            style: TextButton.styleFrom(
              primary: Colors.white,
              backgroundColor: app_globals.getButtonColourCheck(
                  AppColours.appBlue,
                  app_globals.getHistoryEnabled()),
              elevation: 2,
              shape: const CircleBorder(),
            ),
            child: const Icon(Icons.history),
            onPressed: app_globals.getHistoryEnabled()
                ? () => {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                  const MenuHistory(),
                ),
              ),
            }
                : null),
      ])
    ]
  ));
}
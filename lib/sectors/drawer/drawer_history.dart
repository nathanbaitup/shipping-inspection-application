import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'drawer_globals.dart' as globals;
import 'package:shipping_inspection_app/utils/colours.dart';

class MenuHistory extends StatefulWidget {
  const MenuHistory({Key? key}) : super(key: key);

  @override
  State<MenuHistory> createState() => _MenuHistoryState();
}

class _MenuHistoryState extends State<MenuHistory> {
  List<RecordWidget> formatRecords() {
    List<RecordWidget> recordListTiles = [];
    for (var i = 0; i < globals.records.length; i++) {
      var currentRecord = globals.records[i];
      List<String> currentRecordText = List<String>.filled(5, "");
      var blockRecord = false;

      switch (currentRecord.type) {

        // CATEGORY: Section Response Logging
        case "add":
          {
            if (globals.historyPrefs[1]) {
              currentRecordText[0] = currentRecord.user;
              currentRecordText[1] = " added a response to section ";
              currentRecordText[2] = currentRecord.section;
              currentRecordText[3] = " at ";
              currentRecordText[4] = DateFormat('kk:mm (yyyy-MM-dd)')
                  .format(currentRecord.dateTime);
            } else {
              blockRecord = true;
            }
          }
          break;

        // CATEGORY: Section Entering Logging
        case "enter":
          {
            if (globals.historyPrefs[0]) {
              currentRecordText[0] = currentRecord.user;
              currentRecordText[1] = " visited the ";
              currentRecordText[2] = currentRecord.section;
              currentRecordText[3] = " section at ";
              currentRecordText[4] = DateFormat('kk:mm (yyyy-MM-dd)')
                  .format(currentRecord.dateTime);
            } else {
              blockRecord = true;
            }
          }
          break;

        // CATEGORY: Communications Logging
        case "call":
          {
            if (globals.historyPrefs[4]) {
              currentRecordText[0] = currentRecord.user;
              currentRecordText[1] = " joined channel '";
              currentRecordText[2] = currentRecord.section;
              currentRecordText[3] = "' at ";
              currentRecordText[4] = DateFormat('kk:mm (yyyy-MM-dd)')
                  .format(currentRecord.dateTime);
            } else {
              blockRecord = true;
            }
          }
          break;

        // Unclear usage: For opening via QR
        // CATEGORY: QR Usage Logging
        case "opened":
          {
            if (globals.historyPrefs[3]) {
              currentRecordText[0] = currentRecord.user;
              currentRecordText[1] = " opened ";
              currentRecordText[2] = currentRecord.section;
              currentRecordText[3] = " at ";
              currentRecordText[4] = DateFormat('kk:mm (yyyy-MM-dd)')
                  .format(currentRecord.dateTime);
            } else {
              blockRecord = true;
            }
          }
          break;

        // Unclear Usage: For leaving via QR
        // CATEGORY: QR Usage Logging
        case "pressed":
          {
            if (globals.historyPrefs[3]) {
              currentRecordText[0] = currentRecord.user;
              currentRecordText[1] = " pressed ";
              currentRecordText[2] = currentRecord.section;
              currentRecordText[3] = " at ";
              currentRecordText[4] = DateFormat('kk:mm (yyyy-MM-dd)')
                  .format(currentRecord.dateTime);
            } else {
              blockRecord = true;
            }
          }
          break;

        // CATEGORY: Settings Change Logging
        case "settings-permission-add":
          {
            if (globals.historyPrefs[2]) {
              currentRecordText[0] = currentRecord.user;
              currentRecordText[1] = " added device permissions for the ";
              currentRecordText[2] = currentRecord.section;
              currentRecordText[3] = " at ";
              currentRecordText[4] = DateFormat('kk:mm (yyyy-MM-dd)')
                  .format(currentRecord.dateTime);
            } else {
              blockRecord = true;
            }
          }
          break;

        // CATEGORY: Settings Change Logging
        case "settings-username-change":
          {
            if (globals.historyPrefs[2]) {
              currentRecordText[1] = " changed the device's username to ";
              currentRecordText[2] = currentRecord.section;
              currentRecordText[3] = " at ";
              currentRecordText[4] = DateFormat('kk:mm (yyyy-MM-dd)')
                  .format(currentRecord.dateTime);
            } else {
              blockRecord = true;
            }
          }
          break;

        // CATEGORY: Settings Change Logging
        case "settings-language-change":
          {
            if (globals.historyPrefs[2]) {
              currentRecordText[0] = currentRecord.user;
              currentRecordText[1] = " changed the device's language to ";
              currentRecordText[2] = currentRecord.section;
              currentRecordText[3] = " at ";
              currentRecordText[4] = DateFormat('kk:mm (yyyy-MM-dd)')
                  .format(currentRecord.dateTime);
            } else {
              blockRecord = true;
            }
          }
          break;

        // CATEGORY: Settings Change Logging
        case "settings-enable":
          {
            if (globals.historyPrefs[2]) {
              currentRecordText[0] = currentRecord.user;
              currentRecordText[1] = " enabled setting ";
              currentRecordText[2] = currentRecord.section;
              currentRecordText[3] = " at ";
              currentRecordText[4] = DateFormat('kk:mm (yyyy-MM-dd)')
                  .format(currentRecord.dateTime);
            } else {
              blockRecord = true;
            }
          }
          break;

        // CATEGORY: Settings Change Logging
        case "settings-disable":
          {
            if (globals.historyPrefs[2]) {
              currentRecordText[0] = currentRecord.user;
              currentRecordText[1] = " disabled setting ";
              currentRecordText[2] = currentRecord.section;
              currentRecordText[3] = " at ";
              currentRecordText[4] = DateFormat('kk:mm (yyyy-MM-dd)')
                  .format(currentRecord.dateTime);
            } else {
              blockRecord = true;
            }
          }
          break;

        // CATEGORY: Channel Logging
        case "channels-new":
          {
            if (globals.historyPrefs[5]) {
              currentRecordText[0] = currentRecord.user;
              currentRecordText[1] = " saved channel '";
              currentRecordText[2] = currentRecord.section;
              currentRecordText[3] = "' at ";
              currentRecordText[4] = DateFormat('kk:mm (yyyy-MM-dd)')
                  .format(currentRecord.dateTime);
            } else {
              blockRecord = true;
            }
          }
          break;

        // CATEGORY: Channel Logging
        case "channels-edit":
          {
            if (globals.historyPrefs[5]) {
              currentRecordText[0] = currentRecord.user;
              currentRecordText[1] = " edited channel '";
              currentRecordText[2] = currentRecord.section;
              currentRecordText[3] = "' at ";
              currentRecordText[4] = DateFormat('kk:mm (yyyy-MM-dd)')
                  .format(currentRecord.dateTime);
            } else {
              blockRecord = true;
            }
          }
          break;

        // CATEGORY: Channel Logging
        case "channels-generate":
          {
            if (globals.historyPrefs[5]) {
              currentRecordText[0] = currentRecord.user;
              currentRecordText[1] = " generated a channel named '";
              currentRecordText[2] = currentRecord.section;
              currentRecordText[3] = "' at ";
              currentRecordText[4] = DateFormat('kk:mm (yyyy-MM-dd)')
                  .format(currentRecord.dateTime);
            } else {
              blockRecord = true;
            }
          }
          break;

        default:
          {
            currentRecordText[0] = "NULL RECORD";
            blockRecord = true;
          }
          break;
      }

      if(!blockRecord) {
        recordListTiles.add(RecordWidget(
          record: currentRecordText,
        ));
      }
    }
    return recordListTiles;
  }

  Widget getBody() {
    if (globals.historyEnabled) {
      return ListView(
          padding: const EdgeInsets.all(8), children: formatRecords());
    } else {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text("History logging has been disabled.",
              style: TextStyle(
                  fontSize: 15,
                  fontStyle: FontStyle.italic),),
            SizedBox(
              height: 15,
            ),
            Text("Navigate to Settings to renable this feature.",
              style: TextStyle(
                  fontSize: 15,
                  fontStyle: FontStyle.italic),),
          ],
        )
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: globals.getAppbarColour(),
          iconTheme: const IconThemeData(
            color: LightColors.sPurple,
          ),
        ),
        body: getBody());
  }
}

class RecordWidget extends StatelessWidget {
  const RecordWidget({Key? key, required this.record}) : super(key: key);

  final List<String> record;

  final TextStyle bold = const TextStyle(fontWeight: FontWeight.bold);
  final String formattedDate = "";

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ListTile(
          title: Text.rich(
        TextSpan(text: "User ", children: <TextSpan>[
          TextSpan(text: record[0], style: bold),
          TextSpan(text: record[1]),
          TextSpan(text: record[2], style: bold),
          TextSpan(text: record[3]),
          TextSpan(text: record[4], style: bold)
        ]),
      )),
      const Divider(
        color: Colors.grey,
        thickness: 1,
      ),
    ]);
  }
}

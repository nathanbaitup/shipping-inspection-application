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
    for(var i = 0; i < globals.records.length; i++) {
      var currentRecord = globals.records[i];
      List<String> currentRecordText = List<String>.filled(5, "");

      switch(currentRecord.type) {
        case "add": {
          currentRecordText[0] = currentRecord.user;
          currentRecordText[1] = " added a response to section ";
          currentRecordText[2] = currentRecord.section;
          currentRecordText[3] = " at ";
          currentRecordText[4] = DateFormat('kk:mm (yyyy-MM-dd)').format(currentRecord.dateTime);
        }
        break;

        case "enter": {
          currentRecordText[0] = currentRecord.user;
          currentRecordText[1] = " visited the ";
          currentRecordText[2] = currentRecord.section;
          currentRecordText[3] = " section at ";
          currentRecordText[4] = DateFormat('kk:mm (yyyy-MM-dd)').format(currentRecord.dateTime);
        }
        break;

        case "call": {
          currentRecordText[0] = currentRecord.user;
          currentRecordText[1] = " joined a call channel called ";
          currentRecordText[2] = currentRecord.section;
          currentRecordText[3] = " at ";
          currentRecordText[4] = DateFormat('kk:mm (yyyy-MM-dd)').format(currentRecord.dateTime);
        }
        break;

        default: {
          currentRecordText[0] = "NULL RECORD";
        }
        break;
      }

      recordListTiles.add(RecordWidget(
          record: currentRecordText,
        )
      );
    }
    return recordListTiles;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(
            color: LightColors.sPurple,
          ),
        ),

        body: ListView(
          padding: const EdgeInsets.all(8),
          children: formatRecords()
        )
    );
  }
}

class RecordWidget extends StatelessWidget {
  RecordWidget({Key? key, required this.record}) : super(key: key);

  final List<String> record;

  TextStyle bold = const TextStyle(fontWeight: FontWeight.bold);
  String formattedDate = "";

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text.rich(
            TextSpan(
              text: "User ",
              children: <TextSpan>[
                TextSpan(text: record[0], style: bold),
                TextSpan(text: record[1]),
                TextSpan(text: record[2], style: bold),
                TextSpan(text: record[3]),
                TextSpan(text: record[4], style: bold)
              ]
            ),
          )
        ),
      const Divider(
        color: Colors.grey,
        thickness: 1,
      ),
      ]
    );
  }

}
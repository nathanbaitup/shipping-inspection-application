import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shipping_inspection_app/sectors/history/record.dart';
import 'package:shipping_inspection_app/utils/colours.dart';

List<Record> records = [];

class MenuHistory extends StatefulWidget {
  const MenuHistory({Key? key}) : super(key: key);

  @override
  State<MenuHistory> createState() => _MenuHistoryState();
}

class _MenuHistoryState extends State<MenuHistory> {

  //Hard coded entries below -- to be removed
  void hardCodedRecords() {
    records.clear();
    records.add(Record("Sarah", DateTime.now(), "Fire & Safety"));
    records.add(Record("Sarah", DateTime.now(), "Lifesaving"));
    records.add(Record("Jeremy", DateTime.now(), "Engine Room"));
  }

  List<RecordWidget> formatRecords() {
    List<RecordWidget> recordListTiles = [];
    for(var i = 0; i < records.length; i++) {
      var currentRecord = records[i];
      recordListTiles.add(RecordWidget(
          user: currentRecord.user,
          dateTime: currentRecord.dateTime,
          section: currentRecord.section,
        )
      );
    }
    return recordListTiles;
  }

  @override
  Widget build(BuildContext context) {
    hardCodedRecords();
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
  RecordWidget({Key? key, required this.user, required this.dateTime, required this.section}) : super(key: key);

  final String user;
  final DateTime dateTime;
  final String section;

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
                TextSpan(text: user, style: bold),
                TextSpan(text: " added a response to section "),
                TextSpan(text: section, style: bold),
                TextSpan(text: " at "),
                TextSpan(text: formattedDate = DateFormat('kk:mm (yyyy-MM-dd)').format(dateTime), style: bold)
              ]
            )
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
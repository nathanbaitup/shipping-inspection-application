import 'package:flutter/material.dart';
import 'package:shipping_inspection_app/sectors/history/record.dart';

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
    records.add(Record("[Example User 1]", DateTime.now(), "[Example 1]"));
    records.add(Record("[Example User 2]", DateTime.now(), "[Example 2]"));
    records.add(Record("[Example User 3]", DateTime.now(), "[Example 3]"));
  }

  List<ListTile> formatRecords() {
    List<ListTile> recordListTiles = [];
    for(var i = 0; i < records.length; i++) {
      var currentRecord = records[i];
      recordListTiles.add(ListTile(
          title: Text("User " + currentRecord.user +
              " added a response to section " +
              currentRecord.section + " at " +
              currentRecord.dateTime.toString() + "."),
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
            color: Colors.purple,
          ),
        ),

        body: ListView(
          padding: const EdgeInsets.all(8),
          children: formatRecords()
        )
    );
  }



}
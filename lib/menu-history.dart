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
    records.add(Record("[Example User 1]", DateTime.now(), "[Example 1]"));
    records.add(Record("[Example User 2]", DateTime.now(), "[Example 2]"));
    records.add(Record("[Example User 3]", DateTime.now(), "[Example 3]"));
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
          children: const <Widget>[

          ]
        )
    );
  }

}
import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';

class MenuHistory extends StatefulWidget {
  const MenuHistory({Key? key}) : super(key: key);

  @override
  State<MenuHistory> createState() => _MenuHistoryState();
}

class _MenuHistoryState extends State<MenuHistory> {

  bool isSwitched = false;

  @override
  Widget build(BuildContext context) {
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
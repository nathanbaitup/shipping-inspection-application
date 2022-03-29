import 'package:flutter/material.dart';
import '../../shared/history_format.dart';
import '../../utils/app_colours.dart';
import 'drawer_globals.dart' as app_globals;

class MenuHistory extends StatefulWidget {
  const MenuHistory({Key? key}) : super(key: key);

  @override
  State<MenuHistory> createState() => _MenuHistoryState();
}

class _MenuHistoryState extends State<MenuHistory> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: app_globals.getAppbarColour(),
          iconTheme: const IconThemeData(
            color: AppColours.appPurple,
          ),
        ),
        body: getHistoryBody());
  }
}

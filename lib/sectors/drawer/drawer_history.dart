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
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: app_globals.getAppbarColour(),
          iconTheme: const IconThemeData(
            color: AppColours.appPurple,
          ),
        ),
        body: Container(
            padding: const EdgeInsets.only(
              left: 5,
              right: 5,
            ),
            margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border.all(color: AppColours.appPurple),
              borderRadius: const BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            child: getHistoryBody()
        )
    );
  }
}

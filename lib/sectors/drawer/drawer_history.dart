import 'package:flutter/material.dart';
import '../../shared/history_format.dart';
import '../../utils/app_colours.dart';
import '../history/history_buttons.dart';
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
        body: Column(
            children: [
              SizedBox(
                height: 75,
                child: Row(
                  children: [
                    historyButtons(context),
                  ]
                )
              ),
              Expanded(
                child: Container(
                    padding: const EdgeInsets.only(
                      left: 5,
                      right: 5,
                    ),
                    margin: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                      bottom: 20,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColours.appPurple),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    child: getHistoryBody()
                )
              )
            ],
          ),
    );
  }
}

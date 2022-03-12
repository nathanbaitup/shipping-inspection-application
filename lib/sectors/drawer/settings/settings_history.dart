import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shipping_inspection_app/utils/colours.dart';

class SettingsHistory extends StatefulWidget {
  const SettingsHistory({Key? key}) : super(key: key);

  @override
  State<SettingsHistory> createState() => _SettingsHistoryState();
}

class _SettingsHistoryState extends State<SettingsHistory> {


  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(
            color: LightColors.sPurple,
          ),
        ),

        body: const SettingsList(
            sections: [
              
            ]
        ),
    );
  }

}

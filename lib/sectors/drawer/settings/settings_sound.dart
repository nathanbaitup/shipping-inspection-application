import 'package:flutter/material.dart';
import 'package:shipping_inspection_app/sectors/drawer/drawer_globals.dart' as globals;
import 'package:shipping_inspection_app/utils/colours.dart';

class SettingsSound extends StatefulWidget {
  const SettingsSound({Key? key}) : super(key: key);

  @override
  State<SettingsSound> createState() => _SettingsSoundState();
}

class _SettingsSoundState extends State<SettingsSound> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(

        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(
            color: LightColors.sPurple,
          ),
        ),

        body: Container(
        )
    );
  }

}
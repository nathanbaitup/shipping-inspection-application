import 'package:flutter/material.dart';
import 'package:shipping_inspection_app/sectors/drawer/drawer_globals.dart' as globals;
import 'package:shipping_inspection_app/utils/colours.dart';

class SettingsChannels extends StatefulWidget {
  const SettingsChannels({Key? key}) : super(key: key);

  @override
  State<SettingsChannels> createState() => _SettingsChannelsState();
}

class _SettingsChannelsState extends State<SettingsChannels> {

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
        resizeToAvoidBottomInset : false,

        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(
            color: LightColors.sPurple,
          ),
        ),

    );
  }

}
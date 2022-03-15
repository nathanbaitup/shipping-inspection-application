import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shipping_inspection_app/sectors/drawer/drawer_globals.dart' as globals;
import 'package:shipping_inspection_app/utils/colours.dart';

import '../../communication/channel.dart';

class SettingsChannels extends StatefulWidget {
  const SettingsChannels({Key? key}) : super(key: key);

  @override
  State<SettingsChannels> createState() => _SettingsChannelsState();
}

class _SettingsChannelsState extends State<SettingsChannels> {

  @override
  Widget build(BuildContext context) {
    List<Channel> channels = getDisplayChannels(globals.savedChannels);

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(
            color: LightColors.sPurple,
          ),
        ),

        body: SettingsList(sections: [
          SettingsSection(
            title: const Text(
              'Saved Channels',
              style: TextStyle(
                  color: Colors.black,
                  decorationColor: LightColors.sPurple,
                  decorationThickness: 2,
                  decoration: TextDecoration.underline),
            ),
            tiles: [
              ChannelTile(channels[0]),
              ChannelTile(channels[1]),
              ChannelTile(channels[2]),
            ],
          )
        ]));
  }

}

SettingsTile ChannelTile(Channel channel) {

  return SettingsTile(
    title: Text(channel.name),
    leading: const Icon(Icons.bookmark,
        color: LightColors.sPurple),
  );
}

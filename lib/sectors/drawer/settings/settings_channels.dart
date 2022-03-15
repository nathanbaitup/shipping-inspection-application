import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shipping_inspection_app/sectors/drawer/drawer_globals.dart' as globals;
import 'package:shipping_inspection_app/utils/colours.dart';

import '../../communication/channel-selection.dart';
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
              channelTile(channels[0]),
              channelTile(channels[1]),
              channelTile(channels[2]),
            ],
          )
        ]));
  }

}

SettingsTile channelTile(Channel channel) {

  FontStyle emptyFont = FontStyle.normal;
  Row optionsRow = Row();

  if(channel.empty == false) {
    emptyFont = FontStyle.normal;
    optionsRow = Row(
      children: <Widget>[
        IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () {},
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.delete),
        ),
      ],
    );
  } else {
    emptyFont = FontStyle.italic;
    optionsRow = Row(
      children: <Widget>[
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {},
        ),
      ]
    );
  }

  return SettingsTile(
    title: Text(
      channel.name,
      style: TextStyle(
        fontStyle: emptyFont
      ),
    ),
    leading: const Icon(Icons.bookmark,
        color: LightColors.sPurple),
    trailing: optionsRow,
  );
}

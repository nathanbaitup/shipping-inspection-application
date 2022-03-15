import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  SettingsTile channelTile(Channel channel) {

    FontStyle emptyFont = FontStyle.normal;
    Row optionsRow = Row();

    if (channel.empty == false) {
      emptyFont = FontStyle.normal;
      optionsRow = Row(
        children: <Widget>[
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {},
          ),
          IconButton(
            onPressed: () {
              deleteChannel(channel.channelID);
              setState(() {});
            },
            icon: const Icon(Icons.delete),
          ),
        ],
      );
    } else {
      emptyFont = FontStyle.italic;
      optionsRow = Row(children: <Widget>[
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () async {
            createChannel(context, channel.channelID);
          },
        ),
      ]);
    }

    return SettingsTile(
      title: Text(
        channel.name,
        style: TextStyle(fontStyle: emptyFont),
      ),
      leading: const Icon(Icons.bookmark, color: LightColors.sPurple),
      trailing: optionsRow,
    );
  }

  void deleteChannel(int channelID) {
    globals.savedChannels[channelID] = " ";
  }

  void createChannel(BuildContext context, int channelID) {
    final dialogController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            title: const Text('New Channel'),
            content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    onChanged: (value) { },
                    controller: dialogController,
                    decoration: const InputDecoration(hintText: "Enter Channel Here"),
                  ),
                ]
            ),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    globals.savedChannels[channelID] = dialogController.text;
                    Navigator.pop(context);
                    setState(() {});
                  },
                  child: Text('Submit')),
            ]
        );
      },
    );
  }

  void editChannel(Channel channel) {

  }

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


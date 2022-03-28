
import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shipping_inspection_app/sectors/communication/channel_selection.dart';
import 'package:shipping_inspection_app/sectors/drawer/drawer_globals.dart'
    as globals;
import 'package:shipping_inspection_app/utils/colours.dart';
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
            icon: Icon(
                Icons.edit,
                color: globals.getIconColourCheck(
                    LightColors.sPurpleLL,
                    globals.savedChannelsEnabled),
            ),
            onPressed: globals.savedChannelsEnabled
              ? () => {
                setState(() {
                  editChannel(channel, true);
                  globals.savePrefs();
                })
              }
              : null
          ),
          IconButton(
            icon: Icon(
                Icons.delete,
                color: globals.getIconColourCheck(
                    LightColors.sPurpleLL,
                    globals.savedChannelsEnabled),
            ),
            onPressed: globals.savedChannelsEnabled
              ? () => {
                setState(() {
                  globals.addRecord(
                      "channels-delete",
                      globals.getUsername(),
                      DateTime.now(),
                      channel.name
                  );
                  deleteChannel(channel.channelID);
                  globals.savePrefs();
                })
              }
              : null
          ),
        ],
      );
    } else {
      emptyFont = FontStyle.italic;
      optionsRow = Row(children: <Widget>[
        IconButton(
          icon: Icon(
              Icons.add,
              color: globals.getIconColourCheck(
                  LightColors.sPurpleLL,
                  globals.savedChannelsEnabled),
          ),
          onPressed: globals.savedChannelsEnabled
            ? () => {
              setState(() {
                editChannel(channel, false);
                globals.savePrefs();
              })
            }
              : null
        )
      ]);
    }

    return SettingsTile(
      title: Text(
        channel.name,
        style: TextStyle(
          color: globals.getDisabledTextColour(),
          fontStyle: emptyFont
        ),
      ),
      leading: Icon(
          Icons.bookmark,
          color: globals.getIconColourCheck(
              LightColors.sPurple,
              globals.savedChannelsEnabled)),
      trailing: optionsRow,
    );
  }

  void deleteChannel(int channelID) {
    globals.savedChannels[channelID] = " ";
  }

  void editChannel(Channel channel, bool edit) {
    final dialogController = TextEditingController();
    String title = "";

    if (edit) {
      dialogController.text = channel.name;
      title = "Edit Channel";
    } else {
      title = "New Channel";
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            title: Text(title),
            content: Column(mainAxisSize: MainAxisSize.min, children: [
              TextField(
                onChanged: (value) {},
                controller: dialogController,
                decoration: InputDecoration(
                    hintText: "Enter Channel Here",
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: globals.getTextColour(), width: 0.5),
                    ),
                ),
              ),
            ]),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    globals.savedChannels[channel.channelID] =
                        dialogController.text;
                    if (edit) {
                      globals.addRecord(
                          "channels-edit",
                          globals.getUsername(),
                          DateTime.now(),
                          dialogController.text
                      );
                    } else {
                      globals.addRecord(
                          "channels-new",
                          globals.getUsername(),
                          DateTime.now(),
                          dialogController.text
                      );
                    }
                    globals.savePrefs();
                    Navigator.pop(context);
                    setState(() {});
                  },
                  child: const Text('Submit')),
            ]);
      },
    );
  }

  List<AbstractSettingsTile> generateChannels(List<Channel> channels) {
    List<AbstractSettingsTile> channelList = [];
    for (var i = 0; i < globals.savedChannelSum; i++) {
      channelList.add(channelTile(channels[i]));
    }
    return channelList;
  }

  @override
  Widget build(BuildContext context) {
    List<Channel> channels = getDisplayChannels(globals.savedChannels);

    return  Scaffold(
        resizeToAvoidBottomInset: false,

        appBar: AppBar(
          backgroundColor: globals.getAppbarColour(),
          iconTheme: const IconThemeData(
            color: LightColors.sPurple,
          ),
        ),

        body: Column(mainAxisSize: MainAxisSize.min, children: [
          SettingsList(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), sections: [
            SettingsSection(
              title: Text(
              'Channels',
              style: globals.getSettingsTitleStyle(),
            ), tiles: [
              SettingsTile.switchTile(
                title: const Text("Saved Channels"),
                leading: const Icon(Icons.save,
                    color: LightColors.sPurple),
                initialValue: globals.savedChannelsEnabled,
                activeSwitchColor: LightColors.sPurple,
                onToggle: (bool value) {
                  globals.savedChannelsEnabled = !globals.savedChannelsEnabled;
                  if(globals.savedChannelsEnabled) {
                    globals.addRecord(
                        "settings-enable",
                        globals.getUsername(),
                        DateTime.now(),
                        "Saved Channels"
                    );
                  } else {
                    globals.addRecord(
                        "settings-disable",
                        globals.getUsername(),
                        DateTime.now(),
                        "Saved Channels"
                    );
                  }
                  setState(() {
                    value = globals.savedChannelsEnabled;
                    channelNotifier.value = value;
                  });
                  globals.savePrefs();
                },
              )
            ]
            )]
          ),

          Container(
            color: globals.getSettingsBgColour(),
            height: 100,
            child: NumericStepButton(
              onChanged: (value) {
                setState(() {
                  globals.savedChannelSum = value;
                });
              },
            ),
          ),

          SettingsList(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), sections: [
            SettingsSection(
                title: Text(
                  'Saved Channels',
                  style: globals.getSettingsTitleStyle(),
                ), tiles: const [],
            ),
          ]),

          Flexible(
            fit: FlexFit.loose,
            child: SettingsList(shrinkWrap: false, sections: [
              SettingsSection(
                tiles: generateChannels(channels),
              )
            ]),
          ),
        ]));
  }
}

class NumericStepButton extends StatefulWidget {
  final int minValue;
  final int maxValue;

  final ValueChanged<int> onChanged;

  const NumericStepButton(
      {Key? key,  this.minValue = 1, this.maxValue = 9, required this.onChanged}) : super(key: key);

  @override
  State<NumericStepButton> createState() {
    return _NumericStepButtonState();
  }
}

class _NumericStepButtonState extends State<NumericStepButton> {

  int counter = globals.savedChannelSum;

  Text getTextCounter() {
    if(globals.savedChannelsEnabled) {
      return Text(
        '$counter',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: globals.getTextColour(),
          fontSize: 24.0,
          fontWeight: FontWeight.w500,
        ),
      );
    } else {
      return const Text(
        'Disabled',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.grey,
          fontSize: 18.0,
          fontStyle: FontStyle.italic,
          fontWeight: FontWeight.w500,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        TextButton(
          child: const Icon(
            Icons.remove,
            color: Colors.white,
            size: 32,
          ),
          style: TextButton.styleFrom(
            primary: Colors.white,
            backgroundColor: globals.getButtonColourCheck(
                LightColors.sPurpleL,
                globals.savedChannelsEnabled
            ),
            elevation: 2,
            shape: const CircleBorder(),
          ),
          onPressed: globals.savedChannelsEnabled
            ? () => {
              setState(() {
                if (counter > widget.minValue) {
                    counter--;
                  }
                  widget.onChanged(counter);
                  clearUnusedChannels();
                })
            }
              : null
        ),

        getTextCounter(),

        TextButton(
          child: const Icon(
            Icons.add,
            color: Colors.white,
            size: 32,
          ),
          style: TextButton.styleFrom(
            primary: Colors.white,
            backgroundColor: globals.getButtonColourCheck(
                LightColors.sPurpleL,
                globals.savedChannelsEnabled
            ),
            elevation: 2,
            shape: const CircleBorder(),
          ),
          onPressed: globals.savedChannelsEnabled
            ? () => {
              setState(() {
                if (counter < widget.maxValue) {
                  counter++;
                }
                widget.onChanged(counter);
                clearUnusedChannels();
              })
          }
            : null
        ),

      ],
    );
  }
}

void clearUnusedChannels() {
  for(var x = globals.savedChannelSum; x < 9; x++) {
    globals.savedChannels[x] = " ";
  }
  globals.savePrefs();
}
// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'package:shipping_inspection_app/sectors/communication/active-video-call.dart';
import 'package:shipping_inspection_app/sectors/communication/channel.dart';
import 'package:shipping_inspection_app/sectors/drawer/drawer_help.dart';
import 'package:shipping_inspection_app/shared/loading.dart';
import 'package:shipping_inspection_app/utils/colours.dart';
import '../drawer/drawer_globals.dart' as globals;

final _channelNameController = TextEditingController();

class ChannelNameSelection extends StatefulWidget {
  const ChannelNameSelection({Key? key}) : super(key: key);

  @override
  State<ChannelNameSelection> createState() => _ChannelNameSelectionState();
}

class _ChannelNameSelectionState extends State<ChannelNameSelection> {
  // To store the channel name captured by the textfield.
  late String channelName;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Loading()
        : Form(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Image.network(
                      'https://www.idwalmarine.com/hs-fs/hubfs/IDWAL-Logo-CMYK-Blue+White.png?width=2000&name=IDWAL-Logo-CMYK-Blue+White.png'),
                ),
                const Padding(padding: EdgeInsets.only(top: 15)),
                // TODO Capture TextResult into variable allowing it to be passed to another screen
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: TextFormField(
                    controller: _channelNameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          15,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(
                          width: 3,
                          color: Colors.red,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(
                              color: LightColors.sPurpleLL, width: 2)),
                      prefixIcon: const Icon(Icons.video_call),
                      hintText: 'Channel Name',
                      suffixIcon: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween, // added line
                        mainAxisSize: MainAxisSize.min, // added line
                        children: <Widget>[
                          IconButton(
                            icon: const Icon(Icons.save),
                            onPressed: () {
                              setState(() {
                                showOptionsDialog(context, "Select Channel to Save");
                              });
                            },
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                showOptionsDialog(context, "Select Channel to Paste");
                              });
                            },
                            icon: const Icon(Icons.more_vert),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.bottomCenter,
                  padding: const EdgeInsets.only(top: 15),
                  child: Column(
                    children: [
                      MaterialButton(
                      onPressed: () {
                        addChannelRecord();
                        _performChannelNameConnection();
                      },
                      color: LightColors.sPurple,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      child: const Text('Join/Create Channel'),
                      textColor: Colors.white,
                      ),

                      MaterialButton(
                        onPressed: () {
                          channelClipboard(context);
                        },
                        color: LightColors.sPurpleL,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        child: const Text('Copy to Clipboard'),
                        textColor: Colors.white,
                      ),

                      MaterialButton(
                        onPressed: () {
                          channelGenerate();
                        },
                        color: LightColors.sPurpleLL,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        child: const Text('Generate Channel'),
                        textColor: Colors.white,
                      ),
                  ]
                  ),
                )
              ]));
  }

  void channelClipboard(BuildContext context) {
    Clipboard.setData(ClipboardData(text: _channelNameController.text));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Copied to Clipboard!')),
    );
  }

  void channelGenerate() {
    String output = "";
    var r = Random();
    const _capitalChars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const _numChars = '1234567890';
    output = ("IDWAL-" +
        List.generate(3, (index) => _capitalChars[r.nextInt(_capitalChars.length)]).join() +
        List.generate(3, (index) => _numChars[r.nextInt(_numChars.length)]).join());
    _channelNameController.text = output;
  }

  void addChannelRecord() {
    globals.addRecord("call", globals.getUsername(), DateTime.now(),
        _channelNameController.text);
  }

  void _performChannelNameConnection() async {
    String channelNameSelection = _channelNameController.text;

    setState(() {
      loading = true;
      print('loading animation triggered TRUE, _performChannlNameConnection');
    });

    Future.delayed(const Duration(seconds: 5), () {
      setState(() {
        loading = false;
        print(
            'loading animation triggered FALSE, _performChannlNameConnection');
      });

      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                VideoCallFragment(channelName: channelNameSelection)),
      );
    });

    print('channel name selected: $channelNameSelection');
  }
}

showOptionsDialog(BuildContext context, String title) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return OptionsWidget(channels: getDisplayChannels(), title: title);
    },
  );
}

class OptionsWidget extends StatelessWidget {
  const OptionsWidget({Key? key, required this.channels, required this.title}) : super(key: key);

  final List<Channel> channels;
  final String title;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
        title: Text(title),
        children: <Widget>[
          channelOption(context, channels[0], title),
          channelOption(context, channels[1], title),
          channelOption(context, channels[2], title),
        ]
    );
  }
}

List<Channel> getDisplayChannels() {
  List<Channel> displayChannels = [];

  for(int i = 0; globals.savedChannels.length > i; i++) {
    if (globals.savedChannels[i] != " ") {
      displayChannels.add(
        Channel(
          i,
          globals.savedChannels[i],
          false,
        )
      );
    } else {
      displayChannels.add(
        Channel(
          i,
          "Empty",
          true,
        )
      );
    }
  }
  return displayChannels;
}

SimpleDialogOption channelOption(BuildContext context, Channel channel, String title) {
  FontStyle emptyFont = FontStyle.normal;
  String mode = "";

  if(channel.empty) { emptyFont = FontStyle.italic; }
  else { emptyFont = FontStyle.normal; }

  if(title == "Select Channel to Save") { mode = "save"; }
  else if(title == "Select Channel to Paste") { mode = "paste"; }

  return SimpleDialogOption(
    onPressed: () {
      switch(mode) {
        case "save": {
          print("SAVE");
          if (_channelNameController.text.isNotEmpty) {
            globals.savedChannels[channel.channelID] =
            _channelNameController.text;
          } else {
            globals.savedChannels[channel.channelID] = " ";
          }
        }
        break;
        case "paste": {
          print("PASTE");
          _channelNameController.text =
          globals.savedChannels[channel.channelID];
        }
        break;
      }
      Navigator.pop(context);
      },
    child: Row(
      children: [
        Text(
          (channel.channelID + 1).toString() + ": "
        ),
        Text(
          channel.name,
          style: TextStyle(
            fontStyle: emptyFont
          ),
        ),
      ]
    ),


  );
}

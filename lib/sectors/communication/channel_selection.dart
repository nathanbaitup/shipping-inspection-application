// ignore_for_file: file_names
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'package:shipping_inspection_app/sectors/communication/active_video_call.dart';
import 'package:shipping_inspection_app/sectors/communication/channel.dart';
import 'package:shipping_inspection_app/shared/loading.dart';
import 'package:shipping_inspection_app/utils/colours.dart';
import '../drawer/drawer_globals.dart' as globals;
import 'package:dio/dio.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

final _channelNameController = TextEditingController();

class ChannelNameSelection extends StatefulWidget {
  final String vesselID;
  const ChannelNameSelection({Key? key, required this.vesselID})
      : super(key: key);

  @override
  State<ChannelNameSelection> createState() => _ChannelNameSelectionState();
}

class _ChannelNameSelectionState extends State<ChannelNameSelection> {
  // To store the channel name captured by the text field.
  late String channelName;
  bool loading = false;
  bool hasInternet = false;

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
                        borderSide: BorderSide(
                            color: globals.getTextColour(), width: 1),
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
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween, // added line
                        mainAxisSize: MainAxisSize.min, // added line
                        children: <Widget>[
                          IconButton(
                            icon: const Icon(Icons.save),
                            onPressed: () {
                              setState(() {
                                showOptionsDialog(
                                    context, "Select Channel to Save");
                              });
                            },
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                showOptionsDialog(
                                    context, "Select Channel to Paste");
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
                        onPressed: () async {
                          //Here is the bool that checks if the application has internet
                          final bool isConnected =
                              await InternetConnectionChecker().hasConnection;
                          //If the application does have a internet connection it will go through this if statement
                          //and allow the user to access the video call.
                          if (isConnected) {
                            addChannelRecord();
                            _performChannelNameConnection(
                                _channelNameController.text);
                          } else
                          //Then if the user doesn't have any internet connection they will get a snack bar that will
                          //tell them to turn on their internet.
                          {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'You have no internet connection please check to see if you are connected to wifi!'),
                              ),
                            );
                          }
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
                    ],
                  ),
                )
              ],
            ),
          );
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
        List.generate(
                3, (index) => _capitalChars[r.nextInt(_capitalChars.length)])
            .join() +
        List.generate(3, (index) => _numChars[r.nextInt(_numChars.length)])
            .join());
    _channelNameController.text = output;
  }

  void addChannelRecord() {
    globals.addRecord("call", globals.getUsername(), DateTime.now(),
        _channelNameController.text);
  }

  void _performChannelNameConnection(String strDioToken) async {
    debugPrint('The string passed into getTokenDio is ' + strDioToken);
    Response response = await Dio().get(
        "https://agoratokencardiffuniversity.azurewebsites.net/access_token",
        queryParameters: {'channelName': strDioToken});
    Map result = response.data;
    var tokenDataFromJson = result['token'];
    debugPrint('getTokenDio response ' + tokenDataFromJson);
    String tokenDataFromJsonToString = tokenDataFromJson.toString();
    debugPrint('tokenDataFromJsonToString ' + tokenDataFromJsonToString);

    String agoraTokenInsideFunction = tokenDataFromJsonToString;

    String channelNameSelection = _channelNameController.text;

    setState(() {
      loading = true;
      debugPrint(
          'loading animation triggered TRUE, _performChannelNameConnection');
    });

    Future.delayed(const Duration(seconds: 5), () {
      setState(() {
        loading = false;
        debugPrint(
            'loading animation triggered FALSE, _performChannelNameConnection');
      });

      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => VideoCallFragment(
                  channelName: channelNameSelection,
                  agoraToken: agoraTokenInsideFunction,
                  vesselID: widget.vesselID,
                )),
      );
    });

    debugPrint('channel name selected: $channelNameSelection');
    debugPrint('agora token being passed across: $agoraTokenInsideFunction');
  }

// Using Dio, HTTP alternative, smarter package with more flexibility and ease of use.
// Function calls to the URL provided, and gets a token which can then be used within the application.
  // Future<String> getTokenDio(String strDioToken) async {
  //   print('The string passed into getTokenDio is ' + strDioToken);
  //   Response response = await Dio().get(
  //       "https://agoratokencardiffuniversity.azurewebsites.net/access_token",
  //       queryParameters: {'channelName': strDioToken});
  //   Map result = response.data;
  //   var tokenDataFromJson = result['token'];
  //   print('getTokenDio response ' + tokenDataFromJson);
  //   String tokenDataFromJsonToString = tokenDataFromJson.toString();
  //   tokenDataFromJsonToString = agoraToken;
  //   return tokenDataFromJson;
  // }
}

showOptionsDialog(BuildContext context, String title) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return OptionsWidget(
          channels: getDisplayChannels(globals.savedChannels), title: title);
    },
  );
}

class OptionsWidget extends StatelessWidget {
  const OptionsWidget({Key? key, required this.channels, required this.title})
      : super(key: key);

  final List<Channel> channels;
  final String title;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(title: Text(title), children: <Widget>[
      channelOption(context, channels[0], title),
      channelOption(context, channels[1], title),
      channelOption(context, channels[2], title),
    ]);
  }
}

SimpleDialogOption channelOption(
    BuildContext context, Channel channel, String title) {
  FontStyle emptyFont = FontStyle.normal;
  String mode = "";

  if (channel.empty) {
    emptyFont = FontStyle.italic;
  } else {
    emptyFont = FontStyle.normal;
  }

  if (title == "Select Channel to Save") {
    mode = "save";
  } else if (title == "Select Channel to Paste") {
    mode = "paste";
  }

  return SimpleDialogOption(
    onPressed: () {
      switch (mode) {
        case "save":
          {
            if (_channelNameController.text.isNotEmpty) {
              globals.savedChannels[channel.channelID] =
                  _channelNameController.text;
              globals.savePrefs();
            } else {
              globals.savedChannels[channel.channelID] = " ";
            }
          }
          break;
        case "paste":
          {
            _channelNameController.text =
                globals.savedChannels[channel.channelID];
          }
          break;
      }
      Navigator.pop(context);
    },
    child: Row(children: [
      Text((channel.channelID + 1).toString() + ": "),
      Text(
        channel.name,
        style: TextStyle(fontStyle: emptyFont),
      ),
    ]),
  );
}

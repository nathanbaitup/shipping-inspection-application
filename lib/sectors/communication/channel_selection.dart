// ===========================================
// Title: Channel Selection
//
// Original Author: Hamid Iqbal, Osama Ilyas
// Contributors: Osama Ilyas, Hamid Iqbal, Matt Barnett,
//
// Commented By: Osama Ilyas, Hamid Iqbal,  Matt Barnett,
//
// Created: Feb 16, 2022 15:24
// Last Modified: Mar 31, 2022 12:51
// ===========================================

// ignore_for_file: file_names
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'package:shipping_inspection_app/sectors/communication/active_video_call.dart';
import 'package:shipping_inspection_app/sectors/communication/channel.dart';
import 'package:shipping_inspection_app/shared/loading.dart';
import '../../utils/app_colours.dart';
import '../drawer/drawer_globals.dart' as globals;
import 'package:dio/dio.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

final _channelNameController = TextEditingController();

final ValueNotifier<bool> channelNotifier =
    ValueNotifier(globals.getSavedChannelsEnabled());

String saveTitle = "Save to...";
String pasteTitle = "Select Channel to Paste";

class ChannelNameSelection extends StatefulWidget {
  final String vesselID;
  const ChannelNameSelection({Key? key, required this.vesselID})
      : super(key: key);

  @override
  State<ChannelNameSelection> createState() => _ChannelNameSelectionState();
}

class _ChannelNameSelectionState extends State<ChannelNameSelection> {
  // To store the channel name captured by the text field.
  String channelName = '';
  bool loading = false;
  bool hasInternet = false;

  final _formkey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _channelNameController.text = globals.savedChannelCurrent;
    globals.savedChannelCurrent = "";
  }

  List<Widget> getChannelButtons(bool value) {
    List<Widget> channelButtons = [];
    if (value) {
      channelButtons = [
        IconButton(
          icon: const Icon(Icons.save),
          onPressed: () {
            setState(() {
              showOptionsDialog(context, saveTitle);
            });
          },
        ),
        IconButton(
          onPressed: () {
            setState(() {
              showOptionsDialog(context, pasteTitle);
            });
          },
          icon: const Icon(Icons.more_vert),
        ),
      ];
    } else {
      channelButtons = [];
    }
    return channelButtons;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
        valueListenable: channelNotifier,
        builder: (_, channelEnableValue, __) {
          return loading
              ? const Loading(color: Colors.black)
              : Form(
                  key: _formkey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: Image.asset('images/IDWAL-Logo.png'),
                      ),
                      const Padding(padding: EdgeInsets.only(top: 15)),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: TextFormField(
                          controller: _channelNameController,
                          validator: ChannelNameValidator.validate,
                          onChanged: (val) {
                            setState(
                              () {
                                channelName = val;
                              },
                            );
                          },
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
                                    color: AppColours.appPurpleLighter,
                                    width: 2)),
                            prefixIcon: const Icon(Icons.video_call),
                            hintText: 'Channel Name',
                            suffixIcon: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween, // added line
                              mainAxisSize: MainAxisSize.min, // added line
                              children: getChannelButtons(channelEnableValue),
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
                                    await InternetConnectionChecker()
                                        .hasConnection;
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
                              color: AppColours.appPurple,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              child: const Text('Join/Create Channel'),
                              textColor: Colors.white,
                            ),
                            MaterialButton(
                              onPressed: () {
                                channelClipboard(context);
                              },
                              color: AppColours.appPurpleLight,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              child: const Text('Copy to Clipboard'),
                              textColor: Colors.white,
                            ),
                            MaterialButton(
                              key: const Key(
                                  'IDWALCommunicationGenerateChannelButton'),
                              onPressed: () {
                                channelGenerate();
                              },
                              color: AppColours.appPurpleLighter,
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
        });
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

  Future<void> addChannelRecord() async {
    globals.addRecord("call", globals.getUsername(), DateTime.now(),
        _channelNameController.text);
    await FirebaseFirestore.instance
        .collection("History_Logging")
        .add({
          'title': "Accessing call channel",
          'username': globals.getUsername(),
          'time': DateTime.now(),
          'permission': 'Call Channel',
          'channelName': _channelNameController.text,
        })
        .then((value) => debugPrint("Record has been added"))
        .catchError((error) => debugPrint("Failed to add record: $error"));
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

class ChannelNameValidator {
  static String? validate(String? value) {
    return value!.isEmpty ? 'Please enter text' : null;
  }
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
    return SimpleDialog(
        title: Text(title),
        children: getChannelOptions(context, channels, title));
  }
}

List<Widget> getChannelOptions(
    BuildContext context, List<Channel> channels, String title) {
  List<Widget> channelOptionList = [];

  for (var i = 0; i < globals.savedChannelSum; i++) {
    channelOptionList.add(channelOption(context, channels[i], title));
  }

  return channelOptionList;
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

  if (title == saveTitle) {
    mode = "save";
  } else if (title == pasteTitle) {
    mode = "paste";
  }

  return SimpleDialogOption(
    onPressed: () async {
      switch (mode) {
        case "save":
          {
            if (_channelNameController.text.isNotEmpty) {
              globals.savedChannels[channel.channelID] =
                  _channelNameController.text;
              globals.addRecord("channels-new", globals.getUsername(),
                  DateTime.now(), _channelNameController.text);
              globals.savePrefs();

              await FirebaseFirestore.instance
                  .collection("History_Logging")
                  .add({
                    'title': "New Channel Name",
                    'username': globals.getUsername(),
                    'time': DateTime.now(),
                    'permission': 'Call Channel',
                    'channelName': _channelNameController.text,
                  })
                  .then((value) => debugPrint("Record has been added"))
                  .catchError(
                      (error) => debugPrint("Failed to add record: $error"));
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

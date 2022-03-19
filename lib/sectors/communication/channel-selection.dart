// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'package:shipping_inspection_app/sectors/communication/active-video-call.dart';
import 'package:shipping_inspection_app/shared/loading.dart';
import 'package:shipping_inspection_app/utils/colours.dart';
import '../drawer/drawer_globals.dart' as globals;
import 'package:dio/dio.dart';

class ChannelNameSelection extends StatefulWidget {
  const ChannelNameSelection({Key? key}) : super(key: key);

  @override
  State<ChannelNameSelection> createState() => _ChannelNameSelectionState();
}

class _ChannelNameSelectionState extends State<ChannelNameSelection> {
  // To store the channel name captured by the text field.
  late String channelName;
  final _channelNameController = TextEditingController();
  bool loading = false;

// Using Dio, HTTP alternative, smarter package with more flexibility and ease of use.
// Function calls to the URL provided, and gets a token which can then be used within the application.
// TODO Update URL link to take in parameters, mentioned within Dio Pub.Dev page.

// EXAMPLE SHOWN
// response = await dio.get('/test?id=12&name=wendu');
// print(response.data.toString());
// response = await dio.get('/test', queryParameters: {'id': 12, 'name': 'wendu'});
// print(response.data.toString());

  Future<String> getTokenDio() async {
    Response response = await Dio().get(
        "https://agoratokencardiffuniversity.azurewebsites.net/access_token?channelName=test");
    Map result = response.data;
    var tokenDataFromJson = result['token'];
    print(tokenDataFromJson);
    return tokenDataFromJson;
  }

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
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.bottomCenter,
                  padding: const EdgeInsets.only(top: 15),
                  child: Column(children: [
                    MaterialButton(
                      onPressed: () {
                        // addChannelRecord();
                        // _performChannelNameConnection();
                        getTokenDio();
                        // Method called here with a button press, bring back functionality by uncommenting two lines above
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
                  ]),
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
        this.context,
        MaterialPageRoute(
            builder: (context) =>
                VideoCallFragment(channelName: channelNameSelection)),
      );
    });

    print('channel name selected: $channelNameSelection');
  }
}

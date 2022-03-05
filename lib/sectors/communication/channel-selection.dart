// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:shipping_inspection_app/sectors/communication/active-video-call.dart';
import 'package:shipping_inspection_app/utils/colours.dart';

class ChannelNameSelection extends StatefulWidget {
  const ChannelNameSelection({Key? key}) : super(key: key);

  @override
  State<ChannelNameSelection> createState() => _ChannelNameSelectionState();
}

class _ChannelNameSelectionState extends State<ChannelNameSelection> {
  // To store the channel name captured by the textfield.
  late String channelName;
  final _channelNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
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
                    borderSide: const BorderSide(color: LightColors.sPurpleLL, width: 2)),
                prefixIcon: const Icon(Icons.video_call),
                hintText: 'Channel Name',
              ),
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.width * 0.16,
            child: MaterialButton(
              onPressed: () {
                _performChannelNameConnection();
              },
              color: LightColors.sPurple,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: const Text('Join/Create Channel'),
              textColor: Colors.white,
            ),
          )
        ]));
  }

  void _performChannelNameConnection() async {
    String channelNameSelection = _channelNameController.text;

    Navigator.push(
      this.context,
      MaterialPageRoute(
          builder: (context) =>
              VideoCallFragment(channelName: channelNameSelection)),
    );

    print('channel name selected: $channelNameSelection');
  }
}

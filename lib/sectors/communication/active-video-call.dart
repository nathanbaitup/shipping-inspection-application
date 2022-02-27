import 'dart:async';
import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as rtc_local_view;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as rtc_remove_view;
import 'package:permission_handler/permission_handler.dart';
import 'package:shipping_inspection_app/sectors/communication/keys/credentials.dart';

/// APP ID AND TOKEN
/// TOKEN MUST BE CHANGED EVERY 24HRS, IF NOT WORKING GENERATE NEW TOKEN
const appID = appIDAgora;
const agoraToken = tokenAgora;

class VideoCallFragment extends StatefulWidget {
  const VideoCallFragment({Key? key}) : super(key: key);

  @override
  _VideoCallFragmentState createState() => _VideoCallFragmentState();
}

class _VideoCallFragmentState extends State<VideoCallFragment> {
  bool _joined = false;
  int _remoteUid = 0;
  bool _switch = false;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Requesting permissions if not already granted from the PermissionHandler dependecy
  Future<void> initPlatformState() async {
    await [Permission.camera, Permission.microphone].request();

    // Creating an instance of the Agora Engine.
    RtcEngineContext context = RtcEngineContext(appID);
    var engine = await RtcEngine.createWithContext(context);
    // Event Handeling of memebers joining and leaving.
    // TODO Remove print statments before merge request
    engine.setEventHandler(RtcEngineEventHandler(
        joinChannelSuccess: (String channel, int uid, int elapsed) {
      print('joinChannelSuccess $channel $uid');
      setState(() {
        _joined = true;
      });
    }, userJoined: (int uid, int elapsed) {
      print('userJoined $uid');
      setState(() {
        _remoteUid = uid;
      });
    }, userOffline: (int uid, UserOfflineReason reason) {
      print('userOffline $uid');
      setState(() {
        _remoteUid = 0;
      });
    }));
    // Enabling video within the engine with the permissions granted before hand.
    await engine.enableVideo();
    // CHANNEL CONNECTION INFOMATION
    // TODO Change 'test' channel name to a variable called on a init screen before.
    await engine.joinChannel(agoraToken, 'test', null, 0);
  }

  // UI elements
  // Generated inside a new MaterialApp to avoid Agora glitches.
  // TODO Make within the application to reduce size and improve app response time.
  // TODO Add buttons to end call, flip camera, mute mic and take to questionaire page
  // TODO Swap views around showing other user in the bigger picture
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(
          children: [
            Center(
              child: _switch ? _renderRemoteVideo() : _renderLocalPreview(),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                width: 100,
                height: 100,
                color: const Color.fromARGB(255, 255, 255, 255),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _switch = !_switch;
                    });
                  },
                  child: Center(
                    child:
                        _switch ? _renderLocalPreview() : _renderRemoteVideo(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Local device viewfinder.
  Widget _renderLocalPreview() {
    if (_joined) {
      return rtc_local_view.SurfaceView();
    } else {
      return const Text(
        'Please join channel first',
        textAlign: TextAlign.center,
      );
    }
  }

  // Other particpant viewfinder.
  Widget _renderRemoteVideo() {
    if (_remoteUid != 0) {
      return rtc_remove_view.SurfaceView(
        uid: _remoteUid,
        channelId: "test",
      );
    } else {
      return const Text(
        'Please wait remote user join',
        textAlign: TextAlign.center,
      );
    }
  }
}

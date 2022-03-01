import 'dart:async';
import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as rtc_local_view;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as rtc_remove_view;
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shipping_inspection_app/sectors/communication/keys/credentials.dart';

import '../../utils/colours.dart';
import '../survey/survey_hub.dart';

// TODO Add dispose method to end call when end call button is pressed or left the screen

/// APP ID AND TOKEN
/// TOKEN MUST BE CHANGED EVERY 24HRS, IF NOT WORKING GENERATE NEW TOKEN
const appID = appIDAgora;
const agoraToken = tokenAgora;

class VideoCallFragment extends StatefulWidget {
  String channelName;

  VideoCallFragment({Key? key, required this.channelName}) : super(key: key);

  @override
  _VideoCallFragmentState createState() => _VideoCallFragmentState();
}

class _VideoCallFragmentState extends State<VideoCallFragment> {
  bool _joined = false;
  int _remoteUid = 0;
  bool _switch = false;
  bool muted = false;

  @override
  void initState() {
    super.initState();
    initPlatformState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
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
    // TODO Research token having a different channel name each time
    await engine.joinChannel(agoraToken, 'test', null, 0);
    // add 'widget.channelName' to pass channel name across from selection screen beforehand
    print('HELLO THIS IS FROM THE CALLING SCREEN ' + widget.channelName);
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
            _videoCallToolbar(),
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

  //Here is the bottom tool bar for video calling that will show what buttons the user what buttons they will have available to them
  Widget _videoCallToolbar() {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          //The mute button.
          RawMaterialButton(
            onPressed: _onCallToggleMute,
            child: Icon(
              muted ? Icons.mic_off : Icons.mic,
              color: muted ? Colors.white : LightColors.sPurple,
              size: 20.0,
            ),
            shape: const CircleBorder(),
            elevation: 2.0,
            fillColor: muted ? LightColors.sPurple : Colors.white,
            padding: const EdgeInsets.all(12.0),
          ),
          //End call button.
          RawMaterialButton(
            onPressed: () => _onVideoCallEnd(context),
            child: const Icon(
              Icons.call_end,
              color: Colors.white,
              size: 35.0,
            ),
            shape: const CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.redAccent,
            padding: const EdgeInsets.all(15.0),
          ),
          //Switch camera button (Rear and Front)
          RawMaterialButton(
            onPressed: _onSwitchCamera,
            child: const Icon(
              Icons.switch_camera,
              color: LightColors.sPurple,
              size: 20.0,
            ),
            shape: const CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.white,
            padding: const EdgeInsets.all(12.0),
          ),
          //This button takes the user to the survey hub page.
          RawMaterialButton(
            onPressed: () {
              SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
                  overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SurveyHub(),
                ),
              );
            },
            child: const Icon(
              Icons.list_rounded,
              color: LightColors.sPurple,
              size: 20.0,
            ),
            shape: const CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.white,
            padding: const EdgeInsets.all(12.0),
          ),
        ],
      ),
    );
  }

  //This widget is what allows the user to mute their audio stream if they need to. Using RtcEngine.instance?.muteLocalAudioStream()
  //to allow for it to happen.
  void _onCallToggleMute() {
    setState(() {
      muted = !muted;
    });
    RtcEngine.instance?.muteLocalAudioStream(muted);
  }

  //This widget allows the user to leave the channel, and go back to the channel entry page.
  void _onVideoCallEnd(BuildContext context) {
    RtcEngine.instance?.leaveChannel();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    Navigator.pop(context);
  }

  //This widget allows the user to  switch from front and rear camera.
  void _onSwitchCamera() {
    RtcEngine.instance?.switchCamera();
  }
}

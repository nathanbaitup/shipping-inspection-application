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

/// APP ID AND TOKEN
/// TOKEN MUST BE CHANGED EVERY 24HRS, IF NOT WORKING GENERATE NEW TOKEN
const appID = appIDAgora;
const agoraToken = tokenAgora;

class VideoCallFragment extends StatefulWidget {
  final String channelName;
  final String agoraToken;
  final String vesselID;

  const VideoCallFragment(
      {Key? key,
      required this.channelName,
      required this.agoraToken,
      required this.vesselID})
      : super(key: key);

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
    engine.setEventHandler(RtcEngineEventHandler(
        joinChannelSuccess: (String channel, int uid, int elapsed) {
      // print('joinChannelSuccess $channel $uid');
      setState(() {
        _joined = true;
      });
    }, userJoined: (int uid, int elapsed) {
      // print('userJoined $uid');
      setState(() {
        _remoteUid = uid;
      });
    }, userOffline: (int uid, UserOfflineReason reason) {
      // print('userOffline $uid');
      setState(() {
        _remoteUid = 0;
      });
    }));
    // Enabling video within the engine with the permissions granted before hand.
    await engine.enableVideo();
    // CHANNEL CONNECTION INFORMATION
    await engine.joinChannel(widget.agoraToken, widget.channelName, null, 0);
    // add 'widget.channelName' to pass channel name across from selection screen beforehand
    // print('HELLO THIS IS FROM THE CALLING SCREEN ' + widget.channelName);
  }

  // UI elements
  // Generated inside a new MaterialApp to avoid Agora glitches.
  // TODO Make within the application to reduce size and improve app response time.
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
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: LightColors.sPurple,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _switch = !_switch;
                      });
                    },
                    child: Center(
                      child: _switch
                          ? _renderLocalPreview()
                          : _renderRemoteVideo(),
                    ),
                  ),
                ),
              ),
            ),
            _videoCallToolbar(),

            // Displays the option to view questions based on a section.
            // TODO: add drop down list to select what section to survey and automatically display the questions for it.
            Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: const [
                    DisplaySurveyQuestions(
                      surveyQuestions: ['0', 'View questions for section: '],
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: const [
                    DisplaySurveyQuestions(
                      surveyQuestions: [
                        'question 1',
                        'question 2',
                        'question 3',
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Local device viewfinder.
  Widget _renderLocalPreview() {
    if (_joined) {
      // REFERENCE accessed 26/03/2022 https://stackoverflow.com/a/69237364
      // Used to adda rounded edge to the camera view.
      return ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: const rtc_local_view.SurfaceView(),
      );
      // END REFERENCE
    } else {
      return const Text(
        'Please join channel first',
        textAlign: TextAlign.center,
      );
    }
  }

  // Other participant viewfinder.
  Widget _renderRemoteVideo() {
    if (_remoteUid != 0) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: rtc_remove_view.SurfaceView(
          uid: _remoteUid,
          channelId: "test",
        ),
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
                  builder: (context) => SurveyHub(vesselID: widget.vesselID),
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

class DisplaySurveyQuestions extends StatefulWidget {
  final List<String> surveyQuestions;

  const DisplaySurveyQuestions({Key? key, required this.surveyQuestions})
      : super(key: key);

  @override
  _MyARContentState createState() => _MyARContentState();
}

class _MyARContentState extends State<DisplaySurveyQuestions> {
  int widgetQuestionID = 1;

  void _updateWidgetQuestion() {
    setState(() {
      int newQuestion = widgetQuestionID + 1;
      if (newQuestion > (widget.surveyQuestions.length - 1)) {
        newQuestion = 1;
      }
      widgetQuestionID = newQuestion;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double cWidth = MediaQuery.of(context).size.width * 0.58;
    return Column(children: [
      InkWell(
        child: Container(
          width: cWidth,
          margin: const EdgeInsets.all(10.0),
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: LightColors.sPurple,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(20))),
          child: Text(
            "Question: " + widget.surveyQuestions[widgetQuestionID],
            style: const TextStyle(
              color: LightColors.sPurple,
            ),
          ),
        ),
        onTap: () {
          _updateWidgetQuestion();
        },
      )
    ]);
  }
}

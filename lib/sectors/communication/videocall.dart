import 'package:agora_uikit/agora_uikit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VideoCallingScreen extends StatefulWidget {
  const VideoCallingScreen({Key? key}) : super(key: key);

  @override
  _VideoCallingScreenState createState() => _VideoCallingScreenState();
}

class _VideoCallingScreenState extends State<VideoCallingScreen> {
  
  AgoraClient client = AgoraClient(agoraConnectionData: AgoraConnectionData(appId: 'e3dfe0a9996e44e289406a951a813274', channelName: "test"), enabledPermission: [Permission.camera, Permission.microphone]);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          AgoraVideoViewer(client: client,),
          AgoraVideoButtons(client: client)
        ],
      )
      );
  }
}

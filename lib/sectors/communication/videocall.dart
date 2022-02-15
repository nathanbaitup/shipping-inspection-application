import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VideoCallingScreen extends StatefulWidget {
  const VideoCallingScreen({Key? key}) : super(key: key);

  @override
  _VideoCallingScreenState createState() => _VideoCallingScreenState();
}

class _VideoCallingScreenState extends State<VideoCallingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
              child:
                  Text('Video Calling Interface', textAlign: TextAlign.center, style: TextStyle(fontSize: 30),))
        ],
      ),
    );
  }
}

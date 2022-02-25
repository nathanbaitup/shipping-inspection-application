import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shipping_inspection_app/sectors/communication/videocall.dart';
import 'package:shipping_inspection_app/utils/colours.dart';

class CommunicationFront extends StatefulWidget {
  const CommunicationFront({Key? key}) : super(key: key);

  @override
  _CommunicationFrontState createState() => _CommunicationFrontState();
}

class _CommunicationFrontState extends State<CommunicationFront> {

  /// create a channelController to retrieve text value
  final _channelController = TextEditingController();

  /// if channel textField is validated to have error
  final bool _validateError = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            alignment: Alignment.topCenter,
            padding: const EdgeInsets.only(top: 20),
            child: Text(
              'Video Chat', textAlign: TextAlign.center, style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: _channelController,
                decoration: InputDecoration(
                  errorText:
                  _validateError ? 'Channel name is mandatory' : null,
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(width: 1),
                  ),
                  hintText: 'Channel name',
                ),
              ),
          ),
        Padding(
            padding: const EdgeInsets.only(top: 150),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => VideoCallingScreen()));
                      },
                      child: const Text('Join'),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(LightColors.sPurple),
                          foregroundColor:
                              MaterialStateProperty.all(Colors.white)),
                    ),
                  ),
                ),
              ],
            )),
      ],
    ),
    );
  }
}


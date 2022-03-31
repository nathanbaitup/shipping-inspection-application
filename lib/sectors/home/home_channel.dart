
import 'package:flutter/material.dart';
import 'package:shipping_inspection_app/sectors/communication/channel.dart';
import 'package:shipping_inspection_app/userdashboard.dart';
import '../../utils/app_colours.dart';
import '../drawer/drawer_globals.dart' as app_globals;

class HomeChannel extends StatelessWidget {
  const HomeChannel({Key? key, required this.id}) : super(key: key);

  final int id;

  Channel getSavedChannel() {
    Channel savedChannel = Channel(
        id,
        app_globals.savedChannels[id],
        false
    );
    if(app_globals.savedChannels[id] == " ") {
      savedChannel.empty = true;
    }
    return savedChannel;
  }

  Text getSavedChannelString() {
    Channel channel = getSavedChannel();

    if(channel.empty) {
      return const Text(
        'Empty',
        style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontStyle: FontStyle.italic),
      );
    } else {
      return Text(
        channel.name,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,)
      );
    }
  }

  void goToChannel() {
    if(app_globals.savedChannels[id] != " ") {
      app_globals.setSavedChannelCurrent(app_globals.savedChannels[id]);
    } else {
      app_globals.setSavedChannelCurrent("");
    }
    indexNotifier.value = 2;
  }

  @override
  Widget build(BuildContext context) {
    int displayId = id + 1;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return InkWell(
      onTap: () {
        goToChannel();
      },
      child: Container(
        height: screenHeight * 0.06,
        width: screenWidth * 0.435,
        decoration: BoxDecoration(
          color: AppColours.appPurpleLight,
          borderRadius: BorderRadius.circular(25.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('$displayId: ',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,)
            ),
            Center(
              child: getSavedChannelString(),
            )
          ]
        )
      )
    );
  }

}
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shipping_inspection_app/utils/colours.dart';
import 'package:perfect_volume_control/perfect_volume_control.dart';

class SettingsSound extends StatefulWidget {
  const SettingsSound({Key? key}) : super(key: key);

  @override
  State<SettingsSound> createState() => _SettingsSoundState();
}

class _SettingsSoundState extends State<SettingsSound> {

  double currentVolume = 0.5;
  int currentVolumeRounded = 5;

  @override
  void initState() {

    PerfectVolumeControl.hideUI = false; //Set if system UI for sound is hidden
    Future.delayed(Duration.zero,() async {
      currentVolume = await PerfectVolumeControl.getVolume();
      setState(() {});
    });

    PerfectVolumeControl.stream.listen((volume) {
      setState(() {
        currentVolume = volume;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(
            color: LightColors.sPurple,
          ),
        ),

        body: Column(
          children: [

            Container(
              margin: const EdgeInsets.only(top:25),
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text("Current Volume:"),

                  Text(
                    currentVolumeRounded.toString(),
                    style: const TextStyle(
                      color: LightColors.sPurple,
                      fontWeight: FontWeight.bold,
                    ),
                  ),


                  // ----> REFERENCE START
                  //REFERENCE: https://www.fluttercampus.com/guide/238/increase-decrease-volume-flutter/
                  Slider(
                    value: currentVolume,
                    onChanged: (newVolume){
                      currentVolume = newVolume;
                      currentVolumeRounded = ((currentVolume * 10).round());
                      PerfectVolumeControl.setVolume(newVolume); //set new volume
                      setState((){});
                    },
                    min: 0, //
                    max:  1,
                    divisions: 100,
                  )
                  // <---- REFERENCE END
                ]
              )
            ),
          ]
        )
    );
  }

}

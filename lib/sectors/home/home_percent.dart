

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../shared/loading.dart';
import '../../utils/app_colours.dart';

class HomePercentActive extends StatelessWidget {
  const HomePercentActive({
    Key? key,
    required this.sectionName,
    required this.loadingPercent,
    required this.sectionSubtitle,
  }) : super(key: key);

  final String sectionName;
  final double loadingPercent;
  final String sectionSubtitle;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Container(
        height: screenHeight * 0.2,
        width: screenWidth * 0.3,
        decoration: BoxDecoration(
          color: AppColours.appPurpleLight,
          borderRadius: BorderRadius.circular(25.0),
        ),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: screenHeight * 0.02,
              ),
              Text(sectionName),
              SizedBox(
                height: screenHeight * 0.02,
              ),
              LinearPercentIndicator(
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                ),
                animation: true,
                lineHeight: 20.0,
                percent: loadingPercent,
                backgroundColor: AppColours.appPurpleLighter,
                progressColor: AppColours.appLavender,
                center: Text(
                  '${(loadingPercent * 100).round()}%',
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, color: Colors.white),
                ),
              ),
              SizedBox(
                height: screenHeight * 0.005,
              ),
              Text(
                sectionSubtitle,
                style: const TextStyle(
                  fontSize: 12,
                ),
              ),
            ]));
  }

}

class HomePercentLoad extends StatelessWidget {
  const HomePercentLoad({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Row(
      children: <Widget>[
        Container(
          height: screenHeight * 0.2,
          width: screenWidth * 0.3,
          decoration: BoxDecoration(
            color: AppColours.appPurpleLight,
            borderRadius: BorderRadius.circular(25.0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const <Widget>[
              Loading(color: Colors.white),
            ],
          ),
        ),
        const SizedBox(width: 11.0),
      ],
    );
  }

}
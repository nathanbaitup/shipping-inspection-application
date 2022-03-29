
import 'package:flutter/material.dart';
import 'package:shipping_inspection_app/sectors/questions/question_brain.dart';
import '../../main.dart';

QuestionBrain questionBrain = QuestionBrain();

class HomeHub extends StatefulWidget {
  final String vesselID;
  const HomeHub({Key? key, required this.vesselID}) : super(key: key);

  @override
  _HomeHubState createState() => _HomeHubState();
}

class _HomeHubState extends State<HomeHub> {
  @override
  void initState() {
    super.initState();
    vesselID = widget.vesselID;
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
    );
  }
}
import 'package:flutter/material.dart';

class MenuFeedback extends StatefulWidget {
  const MenuFeedback({Key? key}) : super(key: key);

  @override
  State<MenuFeedback> createState() => _MenuFeedbackState();
}

class _MenuFeedbackState extends State<MenuFeedback> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(
            color: Colors.purple,
          ),
        ),

        body: const Center(
          child: Text("Placeholder")
        )
    );
  }

}
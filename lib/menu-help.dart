import 'package:flutter/material.dart';

class MenuHelp extends StatefulWidget {
  const MenuHelp({Key? key}) : super(key: key);

  @override
  State<MenuHelp> createState() => _MenuHelpState();
}

class _MenuHelpState extends State<MenuHelp> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.purple,
        ),
      ),
      body: Center(
          child: Text("Help")
      ),
    );
  }

}
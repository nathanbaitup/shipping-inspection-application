import 'package:flutter/material.dart';

class MenuHelp extends StatefulWidget {
  const MenuHelp({Key? key}) : super(key: key);

  @override
  State<MenuHelp> createState() => _MenuHelpState();
}

class _MenuHelpState extends State<MenuHelp> {

  static const double dividerThickness = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.purple,
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.all(8),
        children: <Widget>[

          Container(
            height: 50,
            child: const Center(child: Text('Question 1')),
          ),

          const Divider(
            color: Colors.grey,
            thickness: dividerThickness,
          ),

          Container(
            height: 50,
            child: const Center(child: Text('Question 2')),
          ),

          const Divider(
            color: Colors.grey,
            thickness: dividerThickness,
          ),

          Container(
            height: 50,
            child: const Center(child: Text('Question 3')),
          ),

          const Divider(
            color: Colors.grey,
            thickness: dividerThickness,
          ),

          Container(
            height: 50,
            child: const Center(child: Text('Question 4')),
          ),

          const Divider(
            color: Colors.grey,
            thickness: dividerThickness,
          ),

          Container(
            height: 50,
            child: const Center(child: Text('Question 5')),
          ),

          const Divider(
            color: Colors.grey,
            thickness: dividerThickness,
          ),

          Container(
            height: 50,
            child: const Center(child: Text('Question 6')),
          ),

          const Divider(
            color: Colors.grey,
            thickness: dividerThickness,
          ),

          Container(
            height: 50,
            child: const Center(child: Text('Question 7')),
          ),

          const Divider(
            color: Colors.grey,
            thickness: dividerThickness,
          ),

          Container(
            height: 50,
            child: const Center(child: Text('Question 8')),
          ),

        ],
      )
    );
  }

}
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
        children: const <Widget>[

          QuestionWidget(
              title: "Question 1"
          ),

          Divider(
            color: Colors.grey,
            thickness: dividerThickness,
          ),

        ],
      )
    );
  }

}

class QuestionWidget extends StatelessWidget {
  const QuestionWidget({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      onTap: () =>
          showDialog<String>(
            context: context,
            builder: (BuildContext context) =>
                AlertDialog(
                  title: const Text('AlertDialog Title'),
                  content: const Text('AlertDialog description'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'Cancel'),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'OK'),
                      child: const Text('OK'),
                    ),
                  ],
                ),
          ),
    );
  }
}
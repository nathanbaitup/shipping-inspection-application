import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shipping_inspection_app/utils/colours.dart';

var content = List.filled(2, "", growable: false);

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
            color: LightColors.sPurple,
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.all(8),
          children: const <Widget>[
            QuestionWidget(
              title: "What is the application about?",
              id: 1,
            ),
            Divider(
              color: Colors.grey,
              thickness: dividerThickness,
            ),
            QuestionWidget(
              title: "Question 2",
              id: 2,
            ),
            Divider(
              color: Colors.grey,
              thickness: dividerThickness,
            ),
            QuestionWidget(
              title: "Question 3",
              id: 3,
            ),
            Divider(
              color: Colors.grey,
              thickness: dividerThickness,
            ),
          ],
        ));
  }
}

List questionContent(int id) {
  switch (id) {
    case 1:
      content[0] = "What is the application about?";
      content[1] =
          "This application is made so that the survey can answer their questions"
          " and if they are stuck on any of the questions they can call the expert for help. ";
      break;
    case 2:
      content[0] = "Question 2 Answer";
      content[1] = "Here is the answer to the question you selected (2).";
      break;
    case 3:
      content[0] = "Question 3 Answer";
      content[1] = "Here is the answer to the question you selected (3).";
      break;
  }
  return content;
}

class QuestionWidget extends StatelessWidget {
  const QuestionWidget({Key? key, required this.title, required this.id})
      : super(key: key);

  final String title;
  final int id;

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Text(title),
        onTap: () {
          questionContent(id);
          showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: Text(content[0]),
              content: Text(content[1]),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Close'),
                  child: const Text('Close'),
                ),
              ],
            ),
          );
        });
  }
}

import 'package:flutter/material.dart';
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
              title: "How do I join a call with the expert?",
              id: 2,
            ),
            Divider(
              color: Colors.grey,
              thickness: dividerThickness,
            ),
            QuestionWidget(
              title: "How to activate AR?",
              id: 3,
            ),
            Divider(
              color: Colors.grey,
              thickness: dividerThickness,
            ),
            QuestionWidget(
              title: "How to change your username?",
              id: 4,
            ),
            Divider(
              color: Colors.grey,
              thickness: dividerThickness,
            ),
            QuestionWidget(
              title: "How to change your history preferences?",
              id: 5,
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
      content[0] = "How do I join a call with the expert?";
      content[1] =
          "When you go onto the calls page you will be greeted by the channel entry page."
          " Once you are there, you can generate a channel with the generate channel button."
          " Then once you have tapped that, just match the channel name with the expert "
          "and the call will work as expected.";
      break;
    case 3:
      content[0] = "How to activate AR?";
      content[1] =
          "When you go to the AR section of the app you can tap on open next to the sections."
          " Then you can click the AR button to activate the button, then you tap on the questions"
          " at the top you can cycle through the questions.";
      break;
    case 4:
      content[0] = "How to change your username?";
      content[1] =
          "If you go to the settings page, and if you tap on username, you will get taken "
          "to a screen that will allow the user to change their username.";
      break;
    case 5:
      content[0] = "How to change your history preferences?";
      content[1] =
          "If you go onto the settings page and tap on the history button, you can completely "
          "edit what appears on the history page.";
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

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
          color: Colors.purple,
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.all(8),
        children: const <Widget>[

          QuestionWidget(
              title: "Question 1",
              id: 1,
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

List questionContent(int id) {
  switch(id) {
    case 1:
      content[0] = "Question 1 Answer";
      content[1] = "Here is the answer to the question you selected.";
      break;
  }
  return content;
}

class QuestionWidget extends StatelessWidget {
  const QuestionWidget({Key? key, required this.title, required this.id}) : super(key: key);

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
          builder: (BuildContext context) =>
              AlertDialog(
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
      }
    );
  }
}
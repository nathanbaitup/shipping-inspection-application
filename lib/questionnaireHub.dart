import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class QuestionnaireHub extends StatefulWidget {
  const QuestionnaireHub({Key? key}) : super(key: key);

  @override
  _QuestionnaireHubState createState() => _QuestionnaireHubState();
}

class _QuestionnaireHubState extends State<QuestionnaireHub> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  "Questionnaire Hub",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Table(
                  children: const [
                    TableRow(
                      children: [
                        Text(
                          "Sections",
                          textScaleFactor: 1.5,
                        ),
                        Text(
                          "Progress",
                          textScaleFactor: 1.5,
                        ),
                        Text(
                          "Questionnaire Link",
                          textScaleFactor: 1.5,
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        Text(
                          "Fire & Safety",
                          textScaleFactor: 1.5,
                        ),
                        Text(
                          "1 of 3",
                          textScaleFactor: 1.5,
                        ),
                        ElevatedButton(
                          onPressed: null,
                          child: Text("Go to this Section?"),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        Text(
                          "Lifesaving",
                          textScaleFactor: 1.5,
                        ),
                        Text(
                          "1 of 2",
                          textScaleFactor: 1.5,
                        ),
                        ElevatedButton(
                          onPressed: null,
                          child: Text("Go to this Section?"),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        Text(
                          "Engine Room",
                          textScaleFactor: 1.5,
                        ),
                        Text(
                          "1 of 2",
                          textScaleFactor: 1.5,
                        ),
                        ElevatedButton(
                          onPressed: null,
                          child: Text("Go to this Section?"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

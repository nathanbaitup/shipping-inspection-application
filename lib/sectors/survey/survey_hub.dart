import 'package:flutter/material.dart';
import 'package:shipping_inspection_app/sectors/questions/question_brain.dart';
import 'package:shipping_inspection_app/sectors/survey/survey_section.dart';

QuestionBrain questionBrain = QuestionBrain();

class SurveyHub extends StatefulWidget {
  const SurveyHub({Key? key}) : super(key: key);

  @override
  _SurveyHubState createState() => _SurveyHubState();
}

class _SurveyHubState extends State<SurveyHub> {

  // Takes the user to the required survey section when pressing on an active survey.
  void loadQuestion(String questionID) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SurveySection(questionID: questionID),
      ),
    );
  }

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
                  "Survey Hub",
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
                  children: [
                    const TableRow(
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
                          "Survey Link",
                          textScaleFactor: 1.5,
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        const Text(
                          "Fire & Safety",
                          textScaleFactor: 1.5,
                        ),
                        Text(
                          "${questionBrain.getAnswerAmount("f&s")} of ${questionBrain.getQuestionAmount("f&s")}",
                          textScaleFactor: 1.5,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            loadQuestion('f&s');
                          },
                          child: const Text("Go to this Section?"),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        const Text(
                          "Lifesaving",
                          textScaleFactor: 1.5,
                        ),
                        Text(
                          "${questionBrain.getAnswerAmount("lifesaving")} of ${questionBrain.getQuestionAmount("lifesaving")}",
                          textScaleFactor: 1.5,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            loadQuestion('lifesaving');
                          },
                          child: const Text("Go to this Section?"),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        const Text(
                          "Engine Room",
                          textScaleFactor: 1.5,
                        ),
                        Text(
                          "${questionBrain.getAnswerAmount("engine")} of ${questionBrain.getQuestionAmount("engine")}",
                          textScaleFactor: 1.5,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            loadQuestion('engine');
                          },
                          child: const Text("Go to this Section?"),
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

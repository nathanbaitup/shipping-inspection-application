import 'package:flutter/material.dart';

class QuestionnaireSection extends StatefulWidget {
  const QuestionnaireSection({Key? key}) : super(key: key);

  @override
  _QuestionnaireSectionState createState() => _QuestionnaireSectionState();
}

class _QuestionnaireSectionState extends State<QuestionnaireSection> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Questionnaire"),
      ),
    );
  }
}

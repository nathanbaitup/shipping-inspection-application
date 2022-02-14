import 'question.dart';

class QuestionBrain {
  final List<Question> _questionBank = [
    Question("f&s",
        "1.Was the fire detection system free of alarms or signs of tampering?"),
    Question("f&s",
        "2.What was the condition of the fire main and ancillaries such as pipework hydrants and valves?"),
    Question("lifesaving", "1.How many lifeboats is the vessel equipped with?"),
    Question(
        "lifesaving", "2.What type of lifeboat is the vessel fitted with?"),
    Question("engine", "1.Was the main engine in good working condition?"),
    Question("engine", "2.What condition did the Main Engine appear to be in?")
  ];
}

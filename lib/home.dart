import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shipping_inspection_app/sectors/questions/question_brain.dart';
import 'package:shipping_inspection_app/sectors/questions/question_totals.dart';
import 'package:shipping_inspection_app/sectors/survey/survey_section.dart';
import 'package:shipping_inspection_app/shared/loading.dart';
import 'package:shipping_inspection_app/tasks.dart';
import 'package:shipping_inspection_app/utils/colours.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:shipping_inspection_app/utils/task_list.dart';
import 'package:shipping_inspection_app/utils/active_questionnaire_card.dart';
import 'package:shipping_inspection_app/utils/homecontainer.dart';
import 'package:shipping_inspection_app/sectors/drawer/drawer_globals.dart'
as globals;

QuestionBrain questionBrain = QuestionBrain();
late String vesselID;
// Sets the active surveys to display a loading icon whilst waiting for
// firebase retrieval.
bool loading = true;

final ValueNotifier<String> usernameNotifier = ValueNotifier(globals.username);

class Home extends StatefulWidget {
  final String vesselID;
  Home({Key? key, required this.vesselID}) : super(key: key);

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    vesselID = widget.vesselID;
  }

  Text subheading(String title) {
    return Text(
      title,
      style: const TextStyle(
          color: LightColors.sDarkBlue,
          fontSize: 20.0,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2),
    );
  }

  static CircleAvatar calendarIcon() {
    return const CircleAvatar(
      radius: 25.0,
      backgroundColor: LightColors.sGreen,
      child: Icon(
        Icons.calendar_today,
        size: 20.0,
        color: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return ValueListenableBuilder<String>(
      valueListenable: usernameNotifier,
      builder: (_, username, __) {
        return Scaffold(
          body: SafeArea(
            child: Column(
              children: <Widget>[
                TopContainer(
                  height: height * 0.12,
                  width: width,
                  padding: const EdgeInsets.all(0.0),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 0, vertical: 0.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              CircularPercentIndicator(
                                radius: 65.0,
                                lineWidth: 6.0,
                                animation: true,
                                percent: 0.75,
                                circularStrokeCap: CircularStrokeCap.round,
                                progressColor: LightColors.sRed,
                                backgroundColor: LightColors.sLavender,
                                center: const CircleAvatar(
                                  backgroundColor: LightColors.sBlue,
                                  radius: 20.0,
                                  backgroundImage: AssetImage(
                                    'images/avatar.png',
                                  ),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    username,
                                    textAlign: TextAlign.start,
                                    style: const TextStyle(
                                      fontSize: 25.0,
                                      color: LightColors.sDarkBlue,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  Text(
                                    'Surveying: $vesselID',
                                    textAlign: TextAlign.start,
                                    style: const TextStyle(
                                      fontSize: 18.0,
                                      color: Colors.black45,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        )
                      ]),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Container(
                          color: Colors.transparent,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 10.0),
                          child: Column(
                            children: <Widget>[
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
                                children: <Widget>[
                                  const Text(
                                    'My tasks',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontSize: 23.0,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                            const TasksPage()),
                                      );
                                    },
                                    child: calendarIcon(),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 15.0),
                              const TaskList(
                                icon: Icons.alarm,
                                iconBackgroundColor: LightColors.sRed,
                                title: 'To Do',
                                subtitle: '5 task(s) to do',
                              ),
                              const SizedBox(
                                height: 15.0,
                              ),
                              const TaskList(
                                icon: Icons.blur_circular,
                                iconBackgroundColor: LightColors.sDarkYellow,
                                title: 'In Progress',
                                subtitle: '2 task(s) in progress',
                              ),
                              const SizedBox(height: 15.0),
                              const TaskList(
                                icon: Icons.check_circle_outline,
                                iconBackgroundColor: LightColors.sBlue,
                                title: 'Done',
                                subtitle: '18 task(s) completed',
                              ),
                            ],
                          ),
                        ),
                        Container(
                          color: Colors.transparent,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const Text(
                                'Active Surveys',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 23.0,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 5.0),
                              // The active survey sections.
                              Column(
                                children: [
                                  Row(
                                    children: const <Widget>[
                                      ActiveSurveysWidget(
                                        sectionName: 'Fire and Safety',
                                        sectionID: 'f&s',
                                      ),
                                      ActiveSurveysWidget(
                                        sectionName: 'Lifesaving',
                                        sectionID: 'lifesaving',
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: const <Widget>[
                                      ActiveSurveysWidget(
                                        sectionName: 'Engine Room',
                                        sectionID: 'engine',
                                      ),
                                      ActiveSurveysWidget(
                                        sectionName: 'Placholder',
                                        sectionID: 'engine',
                                      ),
                                    ],
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
              ],
            ),
          ),
        );
      });
  }
}

// Widget specifically for creating an active surveys box to be displayed in the state.
class ActiveSurveysWidget extends StatefulWidget {
  final String sectionName;
  final String sectionID;

  const ActiveSurveysWidget(
      {Key? key, required this.sectionName, required this.sectionID})
      : super(key: key);

  @override
  _ActiveSurveysWidgetState createState() => _ActiveSurveysWidgetState();
}

class _ActiveSurveysWidgetState extends State<ActiveSurveysWidget> {
  // A list to store the total amount and answered amount of questions.
  List<QuestionTotals> questionTotals = [];
  int numberOfQuestions = 0;
  int answeredQuestions = 0;

  @override
  void initState() {
    super.initState();
    _getResultsFromFirestore(widget.sectionID);
  }

  @override
  Widget build(BuildContext context) {
    // Gets the width of the current device.
    double screenWidth = MediaQuery.of(context).size.width;

    if (loading) {
      return Row(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10.0),
            padding: const EdgeInsets.all(15.0),
            height: 200,
            width: screenWidth * 0.42,
            decoration: BoxDecoration(
              color: LightColors.sPurple,
              borderRadius: BorderRadius.circular(40.0),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const <Widget>[
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Loading(),
                ),
              ],
            ),
          ),
          const SizedBox(width: 11.0),
        ],
      );
    } else {
      return Row(
        children: <Widget>[
          GestureDetector(
            child: ActiveQuestionnairesCard(
              cardColor: LightColors.sPurple,
              loadingPercent: answeredQuestions / numberOfQuestions,
              title: widget.sectionName,
              subtitle:
                  '$answeredQuestions of $numberOfQuestions questions answered',
            ),
            onTap: () {
              _loadQuestion(widget.sectionID);
            },
          ),
          const SizedBox(width: 10.0),
        ],
      );
    }
  }

  // Takes the user to the required survey section when pressing on an active survey.
  void _loadQuestion(String questionID) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SurveySection(
          vesselID: vesselID,
          questionID: questionID,
          capturedImages: const [],
        ),
      ),
    );
  }

  // Loads a list of all the answered questions from firebase to see the total
  // amount of questions answered per section and saves them in a list.
  Future<List<QuestionTotals>> _getResultsFromFirestore(
      String sectionID) async {
    loading = true;
    // The list to store all the total amount of questions and answered questions.
    List<QuestionTotals> questionTotals = [];
    int totalAnswered = 0;
    try {
      // Creates a instance reference to the Survey_Responses collection.
      CollectionReference reference =
          FirebaseFirestore.instance.collection('Survey_Responses');
      // Pulls all data where the vesselID and sectionID match.
      QuerySnapshot querySnapshot =
          await reference.where('vesselID', isEqualTo: vesselID).get();
      // Queries the snapshot to retrieve the section ID, the number of questions,
      // in the section and the number of answered questions and saves to
      // questionTotals.
      for (var document in querySnapshot.docs) {
        questionTotals.add(QuestionTotals(document['sectionID'],
            document['numberOfQuestions'], document['answeredQuestions']));
      }

      // Sets the total amount of questions questions from Firebase.
      for (var i = 0; i < questionTotals.length; i++) {
        if (questionTotals[i].sectionID == sectionID) {
          totalAnswered++;
        }
      }
      // Sets the total number of questions and answered amount.
      setState(() {
        numberOfQuestions = questionBrain.getQuestionAmount(sectionID);
        answeredQuestions = totalAnswered;
      });

      // Checks if the number of answered questions is greater than the total
      // number of questions and sets the answered questions to the total
      // number of questions.
      if (answeredQuestions > numberOfQuestions) {
        answeredQuestions = numberOfQuestions;
      }
    } catch (error) {
      debugPrint("Error: $error");
    }
    setState(() {
      loading = false;
    });
    return questionTotals;
  }
}

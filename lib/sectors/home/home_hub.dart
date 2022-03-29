
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shipping_inspection_app/sectors/drawer/drawer_history.dart';
import 'package:shipping_inspection_app/sectors/drawer/drawer_settings.dart';
import 'package:shipping_inspection_app/sectors/drawer/settings/settings_channels.dart';
import 'package:shipping_inspection_app/sectors/drawer/settings/settings_history.dart';
import 'package:shipping_inspection_app/sectors/home/home_channel.dart';
import 'package:shipping_inspection_app/sectors/home/home_percent.dart';
import 'package:shipping_inspection_app/sectors/questions/question_brain.dart';
import '../../main.dart';
import '../../shared/history_cleardialog.dart';
import '../../shared/history_format.dart';
import '../../shared/loading.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../../utils/app_colours.dart';

import '../drawer/drawer_globals.dart' as app_globals;
import '../drawer/drawer_help.dart';
import '../questions/question_totals.dart';
import '../survey/survey_section.dart';

QuestionBrain questionBrain = QuestionBrain();

final ValueNotifier<String> usernameNotifier =
ValueNotifier(app_globals.getUsername());

class HomeHub extends StatefulWidget {
  final String vesselID;
  const HomeHub({Key? key, required this.vesselID}) : super(key: key);

  @override
  _HomeHubState createState() => _HomeHubState();
}

class _HomeHubState extends State<HomeHub> {
  @override
  void initState() {
    super.initState();
    vesselID = widget.vesselID;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return ValueListenableBuilder<String>(
        valueListenable: usernameNotifier,
        builder: (_, username, __) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            body: SingleChildScrollView(
                child: SafeArea(
                    child: Center(
                        child: Column(
                            children: <Widget>[

                              Container(
                                  height: screenHeight * 0.12,
                                  width: screenWidth,
                                  padding: const EdgeInsets.all(0.0),
                                  decoration: const BoxDecoration(
                                      color: AppColours.appLavender,
                                      borderRadius: BorderRadius.only(
                                        bottomRight: Radius.circular(30.0),
                                        bottomLeft: Radius.circular(30.0),
                                      )),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        username,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 28,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        "Vessel: " + widget.vesselID,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ]
                                  )
                              ),

                              Container(
                                height: screenHeight * 0.12,
                                padding: const EdgeInsets.all(20.0),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(10.0),
                                      decoration: const BoxDecoration(
                                        color: AppColours.appPurple,
                                        borderRadius:
                                            BorderRadius.all(Radius.circular(20)),
                                      ),
                                      child: const Text(
                                        "Progress",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              Container(
                                padding: const EdgeInsets.only(
                                  bottom: 20,
                                  left: 20,
                                ),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: const [
                                      ActiveSurveysWidget(
                                        sectionName: 'Fire and Safety',
                                        sectionID: 'f&s',
                                      ),
                                      ActiveSurveysWidget(
                                        sectionName: 'Lifesaving',
                                        sectionID: 'lifesaving',
                                      ),
                                      ActiveSurveysWidget(
                                        sectionName: 'Engine Room',
                                        sectionID: 'engine',
                                      ),
                                    ],
                                  )
                                )
                              ),

                              const Divider(
                                thickness: 1,
                                height: 1,
                              ),

                              Container(
                                height: screenHeight * 0.12,
                                padding: const EdgeInsets.all(20.0),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(10.0),
                                      decoration: const BoxDecoration(
                                        color: AppColours.appPurple,
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                      ),
                                      child: const Text(
                                        "Channels",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      style: TextButton.styleFrom(
                                        primary: Colors.white,
                                        backgroundColor: AppColours.appGrey,
                                        elevation: 2,
                                        shape: const CircleBorder(),
                                      ),
                                      child: const Icon(Icons.settings),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => const SettingsChannels(),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),

                              Container(

                                child: Column(
                                  children: getHomeChannels()
                                )
                              ),

                              const SizedBox(
                                height: 20,
                              ),

                              const Divider(
                                thickness: 1,
                                height: 1,
                              ),

                              Container(
                                height: screenHeight * 0.12,
                                padding: const EdgeInsets.all(20.0),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(10.0),
                                      decoration: const BoxDecoration(
                                        color: AppColours.appPurple,
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                      ),
                                      child: const Text(
                                        "History",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      style: TextButton.styleFrom(
                                        primary: Colors.white,
                                        backgroundColor: AppColours.appGrey,
                                        elevation: 2,
                                        shape: const CircleBorder(),
                                      ),
                                      child: const Icon(Icons.settings),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => const SettingsHistory(),
                                          ),
                                        );
                                      },
                                    ),
                                    const Spacer(),
                                    SizedBox(
                                      height: 40,
                                      child: TextButton(
                                        style: TextButton.styleFrom(
                                          primary: Colors.white,
                                          backgroundColor: app_globals.getButtonColourCheck(
                                              AppColours.appRed, app_globals.historyEnabled),
                                          elevation: 2,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(18.0)),
                                        ),
                                        child: const Text("Clear"),
                                        onPressed: app_globals.historyEnabled
                                            ? () => {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return historyClearDialog(context);
                                              },
                                            )
                                          }
                                              : null
                                      ),
                                    ),
                                    TextButton(
                                      style: TextButton.styleFrom(
                                        primary: Colors.white,
                                        backgroundColor: app_globals.getButtonColourCheck(
                                            AppColours.appBlue, app_globals.historyEnabled),
                                        elevation: 2,
                                        shape: const CircleBorder(),
                                      ),
                                      child: const Icon(Icons.history),
                                        onPressed: app_globals.historyEnabled
                                          ? () => {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                              builder: (context) => const MenuHistory(),
                                              ),
                                            ),
                                        }
                                            : null
                                    ),
                                  ],
                                ),
                              ),

                              Container(
                                height: screenHeight * 0.45,
                                padding: const EdgeInsets.only(
                                  left: 5,
                                  right: 5,
                                ),
                                margin: const EdgeInsets.only(
                                  left: 20,
                                  right: 20,
                                  bottom: 20,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(color: AppColours.appPurple),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                ),
                                child: getHistoryBody()
                              ),

                            ]
                        )
                    )
                )
            )
        );
    });
  }
}

List<Widget> getHomeChannels() {
  List<Widget> homeChannels = [];

  int currentChannel = 0;
  if(app_globals.savedChannelsEnabled) {
    for (int i = 0; i < (app_globals.savedChannelSum / 2); i++) {
      List<Widget> rowContent = [];

      print(app_globals.savedChannelSum);
      print(currentChannel);
      if (app_globals.savedChannelSum - 1 > currentChannel) {
        rowContent = [
          Container(
            padding: const EdgeInsets.only(
              bottom: 20,
              left: 20,
              right: 5,
            ),
            child: HomeChannel(id: currentChannel),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.only(
              bottom: 20,
              left: 5,
              right: 20,
            ),
            child: HomeChannel(id: currentChannel + 1),
          ),
          const Spacer(),
        ];
      } else {
        rowContent = [
          const Spacer(),
          HomeChannel(id: currentChannel),
          const Spacer(),
        ];
      }

      homeChannels.add(Row(children: rowContent));
      currentChannel += 2;
    }
  } else {
    homeChannels = [
      const Text("Saved channels have been disabled.",
        style: TextStyle(
            fontSize: 15,
            fontStyle: FontStyle.italic),),
      const SizedBox(
        height: 15,
      ),
      const Text("Navigate to Settings to re-enable this feature.",
        style: TextStyle(
            fontSize: 15,
            fontStyle: FontStyle.italic),),
    ];
  }
  return homeChannels;
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
    double percent = answeredQuestions / numberOfQuestions;

    if (loading) {
      return const HomePercentLoad();
    } else {
      return Row(
        children: <Widget>[
          GestureDetector(
            child: HomePercentActive(
              sectionName: widget.sectionName,
              loadingPercent: percent,
              sectionSubtitle: '$answeredQuestions of $numberOfQuestions',
            ),
            onTap: () {
              _loadQuestion(widget.sectionID);
              setState(() {});
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

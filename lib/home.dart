import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shipping_inspection_app/utils/colours.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:shipping_inspection_app/utils/task_list.dart';
import 'package:shipping_inspection_app/utils/active_questionnaire_card.dart';
import 'package:shipping_inspection_app/utils/homecontainer.dart';
import 'package:shipping_inspection_app/questionnaireHub.dart';





class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  Text subheading(String title) {
    return Text(
      title,
      style: TextStyle(
          color: LightColors.sDarkBlue,
          fontSize: 20.0,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2),
    );
  }

  static CircleAvatar calendarIcon() {
    return CircleAvatar(
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
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            TopContainer(
              height: 200,
              width: width,
              padding: EdgeInsets.all(0.0),
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
                            radius: 100.0,
                            lineWidth: 6.5,
                            animation: true,
                            percent: 0.75,
                            circularStrokeCap: CircularStrokeCap.round,
                            progressColor: LightColors.sRed,
                            backgroundColor: LightColors.sLavender,
                            center: CircleAvatar(
                              backgroundColor: LightColors.sBlue,
                              radius: 35.0,
                              backgroundImage: AssetImage(
                                'images/avatar.png',
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                child: Text(
                                  'Ms. Ships',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: 30.0,
                                    color: LightColors.sDarkBlue,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                              Container(
                                child: Text(
                                  'Surveyor',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.black45,
                                    fontWeight: FontWeight.w400,
                                  ),
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
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                      child: Column(
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              subheading('My Tasks'),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => QuestionnaireHub()),
                                  );
                                },
                                child: calendarIcon(),
                              ),
                            ],
                          ),
                          SizedBox(height: 15.0),
                          TaskList(
                            icon: Icons.alarm,
                            iconBackgroundColor: LightColors.sRed,
                            title: 'To Do',
                            subtitle: '5 task(s) to do',
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          TaskList(
                            icon: Icons.blur_circular,
                            iconBackgroundColor: LightColors.sDarkYellow,
                            title: 'In Progress',
                            subtitle: '2 task(s) in progress',
                          ),
                          SizedBox(height: 15.0),
                          TaskList(
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
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          subheading('Active Questionnaires'),
                          SizedBox(height: 5.0),
                          Row(
                            children: <Widget>[
                              ActiveQuestionnairesCard(

                                cardColor: LightColors.sPurple,
                                loadingPercent: 0.25,
                                title: 'Fire & Safety',
                                subtitle: 'X of Y questions answered',
                              ),
                              SizedBox(width: 20.0),
                              ActiveQuestionnairesCard(
                                cardColor: LightColors.sPurple,
                                loadingPercent: 0.6,
                                title: 'Lifesaving',
                                subtitle: 'X of Y questions answered',
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              ActiveQuestionnairesCard(
                                cardColor: LightColors.sPurple,
                                loadingPercent: 0.45,
                                title: 'Engine Room',
                                subtitle: 'X of Y questions answered',
                              ),
                              SizedBox(width: 20.0),
                              ActiveQuestionnairesCard(
                                cardColor: LightColors.sPurple,
                                loadingPercent: 0.9,
                                title: 'Pollution Control',
                                subtitle: 'X of Y questions answered',
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
  }
}







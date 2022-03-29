import 'package:flutter/material.dart';
import 'package:shipping_inspection_app/utils/back_button.dart';
import 'package:shipping_inspection_app/utils/taskcontainer.dart';
import 'package:shipping_inspection_app/utils/colours.dart';
import 'package:shipping_inspection_app/add_task.dart';

class TasksPage extends StatelessWidget {
  const TasksPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            20,
            20,
            20,
            0,
          ),
          child: Column(
            children: <Widget>[
              const MyBackButton(),
              const SizedBox(height: 25.0),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const Text(
                      'To-Do',
                      style: TextStyle(
                          fontSize: 27.0, fontWeight: FontWeight.w800),
                    ),
                    Container(
                      width: 130,
                      height: 45.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: LightColors.sPurple,

                      ),
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AddTask(),
                            ),
                          );
                        },
                        child: const Center(
                          child: Text(
                            'Add task',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 17,
                              color: Colors.white,
                                ),
                          ),
                        ),
                      ),
                    ),
                  ]),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: const <Widget>[

                ],
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                flex: 5,
                child: ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: const <Widget>[
                    TaskContainer(
                      title: 'IMO Guidelines review',
                      subtitle:
                          'Review the inspection conventions given by International Maritime Organization (IMO) to keep on top of my duties',
                      boxColor: LightColors.sLightYellow2,
                    ),
                    TaskContainer(
                      title: 'Engine Bay',
                      subtitle:
                          'Complete engine bay inspection for the SS Milwaukee',
                      boxColor: LightColors.sLavender,
                    ),
                    TaskContainer(
                      title: 'Call HQ',
                      subtitle:
                          'Contact HQ to request a revision of my duties for this week',
                      boxColor: LightColors.sPalePink,
                    ),
                    TaskContainer(
                      title: 'Collaborate with surveyor X',
                      subtitle:
                          'Meet up with surveyor X to ask about lifeboat inspection safety guidelines, as I have little experience in this field',
                      boxColor: LightColors.sLightGreen,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

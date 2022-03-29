import 'package:flutter/material.dart';
import 'package:shipping_inspection_app/sectors/tasks/taskhandler.dart';
import 'package:shipping_inspection_app/utils/back_button.dart';
import 'package:shipping_inspection_app/utils/taskcontainer.dart';
import 'package:shipping_inspection_app/utils/colours.dart';
import 'package:provider/provider.dart';


class TasksPage extends StatelessWidget {
  const TasksPage({Key? key}) : super(key: key);


  showAlertDialog(BuildContext context) {
    TextEditingController _taskTitle = TextEditingController();
    TextEditingController _taskDescription = TextEditingController();

    //
    Widget submitBtn = TextButton(
      child: Text("CONFIRM",
        style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)
        ,
      ),
      onPressed: () {
        Provider.of<EachTask>(context,listen: false).addTask(_taskTitle.text, _taskDescription.text);
        Navigator.of(context).pop();
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Add New Task"),

      content:
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            style: const TextStyle(color: Colors.black),
            controller: _taskTitle,
            decoration: InputDecoration(
                labelText: 'Title',
                labelStyle: const TextStyle(
                    color: Colors.black54, fontSize: 20, fontWeight: FontWeight.w500),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.grey, width: 2),
                ),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey, width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 20),

                hintText: "Enter Title"),
          ),
          const SizedBox(height: 15, width: 500),

          TextField(
            minLines: 4,
            maxLines: 4,
            style: const TextStyle(color: Colors.black),
            controller: _taskDescription,
            decoration: InputDecoration(

                labelText: 'Description',
                labelStyle: const TextStyle(
                    color: Colors.black54, fontSize: 20, fontWeight: FontWeight.w500),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.grey, width: 2),
                ),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey, width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                hintText: "Enter Description"),
          ),
        ],
      ),
      actions: [
        submitBtn,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

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
                        color: const Color(0xFF9370DB),

                      ),
                      child: TextButton(
                        onPressed: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => const AddTask(),
                          //   ),
                          // );
                          showAlertDialog(context);
                        },
                        child: const Center(

                          child: Text(
                            'New task',
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

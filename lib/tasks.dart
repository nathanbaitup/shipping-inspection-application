import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shipping_inspection_app/sectors/tasks/taskdata.dart';
import 'package:shipping_inspection_app/utils/back_button.dart';
import 'package:shipping_inspection_app/utils/taskcard.dart';
import 'package:shipping_inspection_app/utils/colours.dart';
import 'package:provider/provider.dart';

class TasksPage extends StatefulWidget {
  final String vesselID;

  const TasksPage({Key? key, required this.vesselID}) : super(key: key);

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {

  late int id;
  late String title;
  late String description;

  final _taskFormKey = GlobalKey<FormState>();


  showTasksDialog(BuildContext context) {

    TextEditingController _taskTitle = TextEditingController();
    TextEditingController _taskDescription = TextEditingController();

    //
    Widget submitBtn = TextButton(
      child: const Text("CONFIRM",
        style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)
        ,
      ),
      onPressed: () async {
        if (_taskFormKey.currentState!.validate()) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Adding task...'),
            ),
          );
          TaskData addedTask = TaskData(title.trim(),
              description.trim());

          // Handles the storage of the form entry into the Firestore collection
          await FirebaseFirestore.instance
              .collection("Task_Form")
              .add({
            'name': addedTask.title,
            'email': addedTask.description,
          });

          print("Latest task:");
          print(addedTask.title + " / " + addedTask.description);

          Navigator.of(context).pop();
        }
      }
      );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Create New Task", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 22)),
      backgroundColor: const Color(0xFFF0EBFA),


      content: Form(
        key: _taskFormKey,
      child:
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            maxLength: 75,
            minLines: 1,
            maxLines: 2,
            style: const TextStyle(color: Colors.black),
            controller: _taskTitle,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a title';
              } else {
                title = value;
              }
              return null;
            },
            decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                labelText: 'Title',
                labelStyle: const TextStyle(
                    color: Color(0xFF5F6368), fontSize: 18, fontWeight: FontWeight.w500),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.grey, width: 1.25),
                ),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey, width: 1.25),
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 20),

                hintText: "Enter Title"),
          ),
          const SizedBox(height: 15, width: 500),

          TextFormField(
            maxLength: 150,
            minLines: 4,
            maxLines: 5,
            style: const TextStyle(color: Colors.black),

            controller: _taskDescription,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a description';
              } else {
                description = value;
              }
              return null;
            },
            decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                labelText: 'Description',
                labelStyle: const TextStyle(
                    color: Color(0xFF5F6368), fontSize: 18, fontWeight: FontWeight.w500),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.grey, width: 1.25),
                ),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey, width: 1.25),
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                hintText: "Enter Description"),
          ),
        ],
      )
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
                    SizedBox(
                      width: 130,
                      height: 45.0,
                      child: ElevatedButton(
                        style:
                      ElevatedButton.styleFrom(primary: const Color(0xFF9370DB), shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(10),
                        ),),
                        onPressed: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => const AddTask(),
                          //   ),
                          // );

                          showTasksDialog(context);
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
                  physics: NeverScrollableScrollPhysics(),
                  children: <Widget>[
                    TaskCard(
                      title: 'IMO Guidelines review',
                      subtitle:
                          'Review the inspection conventions given by International Maritime Organization (IMO) to keep on top of my duties',
                      cardColor: LightColors.sLightYellow2,
                    ),
                    TaskCard(
                      title: 'Engine Bay',
                      subtitle:
                          'Complete engine bay inspection for the SS Milwaukee',
                      cardColor: LightColors.sLavender,
                    ),
                  TaskCard(
                       title: 'Call HQ',
                       subtitle:
                           'Contact HQ to request a revision of my duties for this week',
                       cardColor: LightColors.sPalePink,
                     ),
                     TaskCard(
                       title: 'Collaborate with surveyor X',
                       subtitle:
                           'Meet up with surveyor X to ask about lifeboat inspection safety guidelines, as I have little experience in this field',
                       cardColor: LightColors.sLightGreen,
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



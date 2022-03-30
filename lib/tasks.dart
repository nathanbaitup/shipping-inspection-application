import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shipping_inspection_app/sectors/tasks/taskdata.dart';
 import 'package:shipping_inspection_app/utils/taskcard.dart';
import 'package:shipping_inspection_app/utils/colours.dart';
import 'package:shipping_inspection_app/sectors/drawer/drawer_globals.dart' as globals;

import 'home.dart';

class TasksPage extends StatefulWidget {
  final String vesselID;

  const TasksPage({Key? key, required this.vesselID}) : super(key: key);

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {

  late String title;
  late String description;

  final _taskFormKey = GlobalKey<FormState>();

  List<TaskData> allTasks = [];


  // Generates an object list from the tasks stored in the Firestore collection
  Future<List<TaskData>> _pullFirestoreTasks() async {
    setState(() {
      loading = true;
    });
    try {
      // Creates a instance reference for the Task_Form collection
      CollectionReference reference =
      FirebaseFirestore.instance.collection('Task_Form');
      // Obtains all task data
      QuerySnapshot querySnapshot = await reference
          .get();

      // Retrieves all data from the snapshot instance and adds these to a list of tasks as Dart object
      for (var document in querySnapshot.docs) {
        allTasks.add(TaskData(
          document['title'],
          document['description'],
        ));
      }

    }//prints a debug message should an error occur when accessing the records
    catch (error) {
      debugPrint("Error: $error");
    }
    setState(() {
      loading = false;
    });
    // returns a list of task objects
    return allTasks;

  }

  // Initializes the state and pulls an updated list of tasks.
  @override
  void initState() {
    _pullFirestoreTasks();
    super.initState();
  }


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
            'title': addedTask.title,
            'description': addedTask.description,
          });

          print("Latest task:");
          print(addedTask.title + " / " + addedTask.description);

          for (TaskData aTask in allTasks){
            print(aTask.toString());
          }



          Navigator.pop(context, true);
          setState(() {
            // refresh state
          });


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
      appBar: AppBar(
        backgroundColor: globals.getAppbarColour(),
        iconTheme: const IconThemeData(
          color: Color(0xFF9370DB),
        ),
      ),
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

              const SizedBox(
                width: 20,
              ),
              Expanded(
                flex: 5,
                child: ListView(
                  shrinkWrap: true,
                  physics: AlwaysScrollableScrollPhysics(),

                  children: <Widget>[
                    for (TaskData cardTask in allTasks)
                      TaskCard(title: cardTask.title.toString(),
                          subtitle:  cardTask.description.toString(),
                          cardColor: Color(0xFFE8E0F8))

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



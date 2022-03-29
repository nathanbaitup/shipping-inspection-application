import 'package:flutter/material.dart';
import 'package:shipping_inspection_app/sectors/tasks/taskdata.dart';
class EachTask extends ChangeNotifier {

  //Tasks List
  List<TaskData> _tasklist = <TaskData>[];

  List<TaskData> get getTasks{
    return _tasklist;
  }
  // handles the deletion of a task at a specified index from the list
  void delTask(int index)
  {
    _tasklist.removeAt(index);
    notifyListeners();
  }

// handles the addition of a new task to the list
  void addTask(String title,String descriptions)
  {
    TaskData task = new TaskData(title, descriptions);

    _tasklist.add(task);

    notifyListeners();
  }

}

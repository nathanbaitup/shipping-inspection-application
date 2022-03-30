
class TaskData {

  String title;
  String description;
  // String stage;


  TaskData(this.title, this.description
      // , this.stage
      );

  List<TaskData> savedTasks = [
    TaskData('IMO Guidelines review', 'Review the inspection conventions given by International Maritime Organization (IMO) to keep on top of my duties'),
    TaskData('Engine Bay', 'Complete engine bay inspection for the SS Milwaukee'),
    TaskData('Call HQ', 'Contact HQ to request a revision of my duties for this week'),
    TaskData('Collaborate with surveyor X', 'Meet up with surveyor X to ask about lifeboat inspection safety guidelines, as I have little experience in this field'),

  ];


}

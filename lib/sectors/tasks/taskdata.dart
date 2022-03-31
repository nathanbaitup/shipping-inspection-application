
class TaskData {

  String title;
  String description;
  // String stage;


  TaskData(this.title, this.description
      // , this.stage
      );

  @override
  String toString() {
    return 'TaskData{title: $title, description: $description}';
  }
}

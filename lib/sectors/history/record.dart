class Record {
  String type; //current types: enter, add
  String user;
  DateTime dateTime;
  String section;

  DateTime get getDatetime {
    return dateTime;
  }

  Record(this.type, this.user, this.dateTime, this.section);
}

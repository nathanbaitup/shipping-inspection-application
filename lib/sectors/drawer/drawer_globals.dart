
import 'package:shipping_inspection_app/sectors/history/record.dart';

List<Record> records = [];
String username = "Current User";

void addRecord(type, user, dateTime, section) {
  records.add(Record(type, user, dateTime, section));
}

void setUsername(newUsername) {
  username = newUsername;
}

String getUsername() {
  return username;
}

import 'package:shipping_inspection_app/sectors/history/record.dart';

List<Record> records = [];
String username = "Current User";

List<bool> historyPrefs = List<bool>.filled(5, true, growable: false);

void addRecord(type, user, dateTime, section) {
  records.add(Record(type, user, dateTime, section));
}

void setUsername(newUsername) {
  username = newUsername;
}

String getUsername() {
  return username;
}

void changeHistoryPref(String type, bool value) {
  switch(type) {
    case "Section Entering": {
      historyPrefs[0] = value;
    }
    break;

    case "Section Response": {
      historyPrefs[1] = value;
    }
    break;

    case "Settings Change": {
      historyPrefs[2] = value;
    }
    break;

    case "QR Usage": {
      historyPrefs[3] = value;
    }
    break;

    case "Communications": {
      historyPrefs[4] = value;
    }
    break;
  }
}
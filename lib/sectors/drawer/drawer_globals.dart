
import 'package:shipping_inspection_app/sectors/history/record.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

// --- CALLS GLOBALS
// -- For usage in Calls + Channels Settings
List<String> savedChannels = List<String>.filled(3, " ", growable: false);

// --- HISTORY GLOBALS
// -- For usage in History Logs
List<Record> records = [];

void addRecord(type, user, dateTime, section) {
  records.add(Record(type, user, dateTime, section));
}

// --- USERNAME GLOBALS
// -- For usage in Username Settings + History Logs + Calls
String username = "Current User";

void setUsername(newUsername) {
  username = newUsername;
}

String getUsername() {
  return username;
}

// --- HISTORY GLOBALS
// -- For usage in History Logs + History Settings
List<bool> historyPrefs = List<bool>.filled(5, true, growable: false);

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

// --- LOCAL SAVING
// For saving global variables locally for cross-session usage.


// ---> REFERENCE START: https://programmingwithswift.com/how-to-save-a-file-locally-with-flutter/
Future<String> getFilePath() async {
  Directory appDocumentsDirectory = await getApplicationDocumentsDirectory(); // 1
  String appDocumentsPath = appDocumentsDirectory.path; // 2
  String filePath = '$appDocumentsPath/idwal_settings.txt'; // 3

  return filePath;
}
// <--- REFERENCE END

void saveFile() async {
  File file = File(await getFilePath());
  file.writeAsString(
    username + "////" +
    savedChannels.toString() + "////" +
    historyPrefs.toString() + "////"
  );

  //CHECK THIS ---> https://stackoverflow.com/questions/43810508/dart-convert-string-representation-of-list-of-lists-to-list-of-list
}

void readFile() async {
  File file = File(await getFilePath()); // 1
  String fileContent = await file.readAsString(); // 2

  print('File Content: $fileContent');
}

import 'package:shipping_inspection_app/sectors/history/record.dart';
import 'package:shared_preferences/shared_preferences.dart';

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


void savePrefs() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('username', username);
  await prefs.setStringList("channels", savedChannels);
  await prefs.setBool("history-entering", historyPrefs[0]);
  await prefs.setBool("history-response", historyPrefs[1]);
  await prefs.setBool("history-settings", historyPrefs[2]);
  await prefs.setBool("history-qr", historyPrefs[3]);
  await prefs.setBool("history-communications", historyPrefs[4]);
}

void loadPrefs() async {
  final prefs = await SharedPreferences.getInstance();
  username = prefs.getString('username')?? "Current User";
  savedChannels = prefs.getStringList("channels")??
      List<String>.filled(3, " ", growable: false);
  historyPrefs[0] = prefs.getBool("history-entering")?? true;
  historyPrefs[1] = prefs.getBool("history-response")?? true;
  historyPrefs[2] = prefs.getBool("history-settings")?? true;
  historyPrefs[3] = prefs.getBool("history-qr")?? true;
  historyPrefs[4] = prefs.getBool("history-communications")?? true;
}
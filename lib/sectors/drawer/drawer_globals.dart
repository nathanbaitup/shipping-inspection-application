
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shipping_inspection_app/sectors/history/record.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';
import '../../utils/colours.dart';

// --- CALLS GLOBALS
// -- For usage in Calls + Channels Settings
List<String> savedChannels = List<String>.filled(3, " ", growable: false);

// --- HISTORY GLOBALS
// -- For usage in History Logs
List<Record> records = [];

void addRecord(type, user, dateTime, section) {
  records.add(Record(type, user, dateTime, section));
}

// --- THEME GLOBALS
// -- For usage in Dark Mode
var appBrightness = SchedulerBinding.instance!.window.platformBrightness;

bool systemThemeEnabled = false;
bool darkModeEnabled = appBrightness == Brightness.dark;

void initTheme() {
  if(darkModeEnabled) {
    themeNotifier.value = ThemeMode.dark;
  } else {
    themeNotifier.value = ThemeMode.light;
  }
}

Color getAppbarColour() {
  Color appbarColour;
  if (darkModeEnabled) {
    appbarColour = Colors.black12;
  } else {
    appbarColour = Colors.white;
  }
  return appbarColour;
}

Color getTextColour() {
  Color appbarColour;
  if (darkModeEnabled) {
    appbarColour = Colors.white;
  } else {
    appbarColour = Colors.black;
  }
  return appbarColour;
}

Color getSubtextColour() {
  Color appbarColour;
  if (darkModeEnabled) {
    appbarColour = Colors.white54;
  } else {
    appbarColour = Colors.black45;
  }
  return appbarColour;
}

Color getSettingsBgColour() {
  Color settingsBgColour;
  if (darkModeEnabled) {
    settingsBgColour = const Color(0xFF1B1B1B);
  } else {
    settingsBgColour =  const Color(0xFFF0F0F0);
  }
  return settingsBgColour;
}

// --- DISABLED GLOBALS
// -- For usage in History Settings and the Dark Mode Switch

Color getIconColourCheck(bool enableValue) {
  Color newColor;
  if(enableValue) {
    newColor = LightColors.sPurple;
  } else {
    newColor = Colors.grey;
  }
  return newColor;
}

Color getButtonColourCheck(Color enabledColour) {
  Color newColor;
  if(historyEnabled) {
    newColor = enabledColour;
  } else {
    newColor = Colors.grey;
  }
  return newColor;
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
bool historyEnabled = true;

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
  await prefs.setBool("history-enabled", historyEnabled);
  await prefs.setBool("dark-mode", darkModeEnabled);
  await prefs.setBool("system-theme", systemThemeEnabled);
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
  historyEnabled = prefs.getBool("history-enabled")?? true;
  darkModeEnabled = prefs.getBool("dark-mode")?? false;
  systemThemeEnabled = prefs.getBool("system-theme")?? false;
  initTheme();
}
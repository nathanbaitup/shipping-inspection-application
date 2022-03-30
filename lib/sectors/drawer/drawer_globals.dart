
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shipping_inspection_app/sectors/history/record.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shipping_inspection_app/sectors/home/home_hub.dart';

import '../../main.dart';
import '../../utils/app_colours.dart';

// --- CALLS GLOBALS
// -- For usage in Calls + Channels Settings
List<String> savedChannels = List<String>.filled(9, " ", growable: false);

bool savedChannelsEnabled = true;

bool getSavedChannelsEnabled() {
  return savedChannelsEnabled;
}

void toggleSavedChannelsEnabled() {
  savedChannelsEnabled = !savedChannelsEnabled;
  savePrefs();
  homeStateUpdate();
}

int savedChannelSum = 3;

String savedChannelCurrent = "";

void setSavedChannelCurrent(String tappedChannel) {
  savedChannelCurrent = tappedChannel;
}

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
  Color textColour;
  if (darkModeEnabled) {
    textColour = Colors.white;
  } else {
    textColour = Colors.black;
  }
  return textColour;
}

Color getDisabledTextColour() {
  Color textColour;
  if (savedChannelsEnabled) {
    textColour = getTextColour();
  } else {
    textColour = const Color(0xFF737277);
  }
  return textColour;
}

Color getSubtextColour() {
  Color textColour;
  if (darkModeEnabled) {
    textColour = Colors.white54;
  } else {
    textColour = Colors.black45;
  }
  return textColour;
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

Color getSnackBarBgColour() {
  Color settingsBgColour;
  if (darkModeEnabled) {
    settingsBgColour = Colors.white;
  } else {
    settingsBgColour =  Colors.black54;
  }
  return settingsBgColour;
}

// --- STYLING GLOBALS
// -- For usage in History Settings and the Dark Mode Switch

Color getIconColourCheck(Color enabledColour, bool condition) {
  Color newColor;
  if(condition) {
    newColor = enabledColour;
  } else {
    newColor = Colors.grey;
  }
  return newColor;
}

Color getButtonColourCheck(Color enabledColour, bool condition) {
  Color newColor;
  if(condition) {
    newColor = enabledColour;
  } else {
    newColor = Colors.grey;
  }
  return newColor;
}

TextStyle getSettingsTitleStyle() {
  return TextStyle(
      color: getTextColour(),
      decorationColor: AppColours.appPurple,
      decorationThickness: 2,
      decoration: TextDecoration.underline);
}

// --- TUTORIAL GLOBALS
// -- For usage in Tutorial Settings + Survey Sections

bool tutorialEnabled = true;

void setTutorialEnabled(bool value) {
  tutorialEnabled = value;
  savePrefs();
}

bool getTutorialEnabled(bool value) {
  return tutorialEnabled;
}


// --- USERNAME GLOBALS
// -- For usage in Username Settings + History Logs + Calls
String username = "Current User";

void setUsername(newUsername) {
  username = newUsername;
  savePrefs();
}

String getUsername() {
  return username;
}

// --- HISTORY GLOBALS
// -- For usage in History Logs + History Settings
bool historyEnabled = true;

bool getHistoryEnabled() {
  return historyEnabled;
}

void toggleHistoryEnabled() {
  historyEnabled = !historyEnabled;
  savePrefs();
  homeStateUpdate();
}

List<bool> historyPrefs = List<bool>.filled(6, true, growable: false);

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

    case "Channels": {
      historyPrefs[5] = value;
    }
    break;
  }
}

// --- LOCAL SAVING
// For saving global variables locally for cross-session usage.


void savePrefs() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('username', username);

  await prefs.setStringList("channels-list", savedChannels);
  await prefs.setInt("channel-sum", savedChannelSum);
  await prefs.setBool("channels-enabled", savedChannelsEnabled);

  await prefs.setBool("history-entering", historyPrefs[0]);
  await prefs.setBool("history-response", historyPrefs[1]);
  await prefs.setBool("history-settings", historyPrefs[2]);
  await prefs.setBool("history-qr", historyPrefs[3]);
  await prefs.setBool("history-communications", historyPrefs[4]);
  await prefs.setBool("history-channels", historyPrefs[5]);
  await prefs.setBool("history-enabled", historyEnabled);

  await prefs.setBool("tutorial-enabled", tutorialEnabled);

  await prefs.setBool("dark-mode", darkModeEnabled);
  await prefs.setBool("system-theme", systemThemeEnabled);
}

void loadPrefs() async {
  final prefs = await SharedPreferences.getInstance();
  username = prefs.getString('username')?? "Current User";

  savedChannels = prefs.getStringList("channels-list")??
      List<String>.filled(9, " ", growable: false);
  savedChannelSum = prefs.getInt("channel-sum")?? 3;
  savedChannelsEnabled = prefs.getBool("channels-enabled")?? true;


  historyPrefs[0] = prefs.getBool("history-entering")?? true;
  historyPrefs[1] = prefs.getBool("history-response")?? true;
  historyPrefs[2] = prefs.getBool("history-settings")?? true;
  historyPrefs[3] = prefs.getBool("history-qr")?? true;
  historyPrefs[4] = prefs.getBool("history-communications")?? true;
  historyPrefs[5] = prefs.getBool("history-channels")?? true;
  historyEnabled = prefs.getBool("history-enabled")?? true;

  tutorialEnabled = prefs.getBool("tutorial-enabled")?? true;

  darkModeEnabled = prefs.getBool("dark-mode")?? false;
  systemThemeEnabled = prefs.getBool("system-theme")?? false;
  initTheme();
}

void homeStateUpdate() {
  homeStateNotifier.value = !homeStateNotifier.value;
}
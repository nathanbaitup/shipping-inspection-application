import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shipping_inspection_app/home.dart';
import 'package:shipping_inspection_app/sectors/drawer/drawer_globals.dart' as globals;
import 'package:shipping_inspection_app/utils/colours.dart';

class SettingsUsername extends StatefulWidget {
  const SettingsUsername({Key? key}) : super(key: key);

  @override
  State<SettingsUsername> createState() => _SettingsUsernameState();
}

class _SettingsUsernameState extends State<SettingsUsername> {
  late String username;

  String currentUsername = globals.getUsername();

  void updateCurrentUsername() {
    setState(() {
      currentUsername = globals.getUsername();
    });
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: globals.getAppbarColour(),
          iconTheme: const IconThemeData(
            color: LightColors.sPurple,
          ),
        ),
        body: Container(
            color: globals.getSettingsBgColour(),
            padding: const EdgeInsets.all(20.0),
            child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Column(
                        children: [
                          Center(
                            child: Column(
                              children: [
                                const Text("Your username is currently: "),
                                Text(
                                  currentUsername,
                                  style: const TextStyle(
                                    color: LightColors.sPurple,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your new username';
                          } else {
                            username = value;
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: globals.getTextColour(), width: 0.5),
                            ),
                            hintText: 'Sarah',
                            labelText: 'Username'
                        )
                    ),


                    Container(
                      width: screenSize.width,
                      child: ElevatedButton(
                        child: const Text('Submit'),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text('Processing username change...')),
                            );
                            globals.addRecord("settings-username-change", globals.getUsername(), DateTime.now(), username);
                            setState(() {
                              globals.setUsername(username);
                              usernameNotifier.value = username;
                            });
                            updateCurrentUsername();
                            globals.savePrefs();

                            await FirebaseFirestore.instance
                                .collection("History_Logging")
                                .add({
                                  'title': "Changing my username",
                                  'username': globals.getUsername(),
                                  'time': DateTime.now(),
                                  'permission': "User Name",
                                })
                                .then((value) => print("Record has been added"))
                                .catchError((error) =>
                                    print("Failed to add record: $error"));
                          }
                        },
                      ),
                      margin: const EdgeInsets.only(top: 20.0),
                    )
                  ],
                ))));
  }
}

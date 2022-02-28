import 'package:flutter/material.dart';
import 'package:shipping_inspection_app/sectors/userfeedback/feedback.dart';
import 'package:shipping_inspection_app/utils/colours.dart';

class SettingsUsername extends StatefulWidget {
  const SettingsUsername({Key? key}) : super(key: key);

  @override
  State<SettingsUsername> createState() => _SettingsUsernameState();
}

class _SettingsUsernameState extends State<SettingsUsername> {

  late String username;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
        resizeToAvoidBottomInset : false,

        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(
            color: LightColors.sPurple,
          ),
        ),

        body: Container(
            padding: const EdgeInsets.all(20.0),
            child: Form (
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Container(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Column(
                        children: const [
                          Text("Your username is currently: ")
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
                        decoration: const InputDecoration(
                            hintText: 'Sarah',
                            labelText: 'Username'
                        )
                    ),


                    Container(
                      width: screenSize.width,
                      child: ElevatedButton(
                        child: const Text('Submit'),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Processing username change...')),
                            );
                            print(username);
                          }
                        },
                      ),
                      margin: const EdgeInsets.only(top: 20.0),
                    )
                  ],
                )
            )
        )
    );
  }

}
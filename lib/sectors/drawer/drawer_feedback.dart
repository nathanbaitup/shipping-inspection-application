import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shipping_inspection_app/sectors/userfeedback/feedback.dart';
import '../../utils/app_colours.dart';
import 'drawer_globals.dart' as globals;

class MenuFeedback extends StatefulWidget {
  final String vesselID;
  const MenuFeedback({Key? key, required this.vesselID}) : super(key: key);

  @override
  State<MenuFeedback> createState() => _MenuFeedbackState();
}

class _MenuFeedbackState extends State<MenuFeedback> {
  late String name;
  late String email;
  late String feedback;
  late int sliderFeedback = 5;

  final _formKey = GlobalKey<FormState>();
  double _currentSliderValue = 5;

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: globals.getAppbarColour(),
          iconTheme: const IconThemeData(
            color: AppColours.appPurple,
          ),
        ),
        body: Container(
            padding: const EdgeInsets.all(20.0),
            child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        } else {
                          name = value;
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                          hintText: 'John', labelText: 'Name'),
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        } else {
                          email = value;
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                          hintText: 'you@example.com', labelText: 'Email'),
                    ),
                    TextFormField(
                      keyboardType: TextInputType.multiline,
                      minLines: 3,
                      maxLines: null,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your feedback';
                        } else {
                          feedback = value;
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                          hintText:
                              'Please enter all feedback for the application here',
                          labelText: 'Feedback'),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Column(
                        children: const [
                          Text("Please adjust the slider based on your "
                              "overall experience with the application. "
                              "(E.g. 10 - Excellent, 1 - Very Poor)")
                        ],
                      ),
                    ),
                    Slider(
                      value: _currentSliderValue,
                      max: 10,
                      divisions: 10,
                      label: _currentSliderValue.round().toString(),
                      onChanged: (double value) {
                        setState(() {
                          _currentSliderValue = value;
                          sliderFeedback = _currentSliderValue.toInt();
                        });
                      },
                    ),
                    Container(
                      width: screenSize.width,
                      child: ElevatedButton(
                        child: const Text('Submit'),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Processing feedback...'),
                              ),
                            );
                            UserFeedback newFeedback = UserFeedback(name.trim(),
                                email.trim(), feedback.trim(), sliderFeedback);

                            // This here is what allows the feedback form data to get sent to the
                            // firestore database.
                            await FirebaseFirestore.instance
                                .collection("Feedback_Form")
                                .add({
                              'name': newFeedback.name,
                              'email': newFeedback.email,
                              'feedback': newFeedback.feedback,
                              'sliderFeedback': newFeedback.sliderFeedback,
                            });
                          }
                        },
                      ),
                      margin: const EdgeInsets.only(top: 20.0),
                    )
                  ],
                ))));
  }
}

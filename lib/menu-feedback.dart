import 'package:flutter/material.dart';

class MenuFeedback extends StatefulWidget {
  const MenuFeedback({Key? key}) : super(key: key);

  @override
  State<MenuFeedback> createState() => _MenuFeedbackState();
}

class _MenuFeedbackState extends State<MenuFeedback> {

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(
            color: Colors.purple,
          ),
        ),

        body: Form (
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Text("1. Please enter your name. *"),

              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                }
              ),

              Text("2. Please enter your email. *"),

              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                }
              ),

              Center(
                child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Processing Data')),
                        );
                      }
                    }, child: const Text("Submit")
                )
              )
            ],
          )
        )
    );
  }

}
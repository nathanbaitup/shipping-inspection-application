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
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(
            color: Colors.purple,
          ),
        ),

        body: Container(
          padding: const EdgeInsets.all(20.0),
          child: Form (
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                      hintText: 'John',
                      labelText: 'Name'
                  )
                ),

                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                      hintText: 'you@example.com',
                      labelText: 'Email'
                  )
                ),

                Container(
                  width: screenSize.width,
                  child: ElevatedButton(
                    child: const Text('Submit'),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Processing feedback...')),
                        );
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
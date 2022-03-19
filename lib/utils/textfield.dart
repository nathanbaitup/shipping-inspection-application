import 'package:flutter/material.dart';

class appTextField extends StatelessWidget {
  final String label;
  final int maxLines;
  final int minLines;
  appTextField({required this.label, this.maxLines = 1, this.minLines = 1});

  @override
  Widget build(BuildContext context) {
    return TextField(

      style: TextStyle(color: Colors.black),
      minLines: minLines,
      maxLines: maxLines,
      decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.black54, fontSize: 20, fontWeight:FontWeight.w500),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.grey, width: 2),
          ),
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey, width: 2),
            borderRadius: BorderRadius.circular(15),
          ),

          hintText: "Your text here",
          contentPadding: EdgeInsets.fromLTRB(20, 20, 20, 20),


    )
      );
  }
}
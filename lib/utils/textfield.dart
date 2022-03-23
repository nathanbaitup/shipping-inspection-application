import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  final String label;
  final int maxLines;
  final int minLines;
  const AppTextField(
      {Key? key, required this.label, this.maxLines = 1, this.minLines = 1})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
        style: const TextStyle(color: Colors.black),
        minLines: minLines,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(
              color: Colors.black54, fontSize: 20, fontWeight: FontWeight.w500),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.grey, width: 2),
          ),
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey, width: 2),
            borderRadius: BorderRadius.circular(15),
          ),
          hintText: "Your text here",
          contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
        ));
  }
}

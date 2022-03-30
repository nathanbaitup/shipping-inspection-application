
import 'package:flutter/material.dart';

import '../utils/app_colours.dart';

Container sectionHeader(String title) {

  return Container(
    padding: const EdgeInsets.all(10.0),
    decoration: const BoxDecoration(
      color: AppColours.appPurple,
      borderRadius: BorderRadius.all(Radius.circular(20)),
    ),
    child: Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.w500,
      ),
    ),
  );

}
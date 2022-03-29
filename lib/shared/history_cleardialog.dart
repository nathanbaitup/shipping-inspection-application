import 'package:flutter/material.dart';
import 'package:shipping_inspection_app/sectors/drawer/drawer_globals.dart'
as app_globals;

import '../utils/app_colours.dart';

AlertDialog historyClearDialog(BuildContext context) {

  return AlertDialog(
      title:
      const Text("Clear History"),
      content: const Text(
          "Are you sure you want to clear all history?"),
      actions: [
        ElevatedButton(
            onPressed: () {
              app_globals.records = [];
              Navigator.pop(context);
            },
            style: ElevatedButton
                .styleFrom(
              primary: AppColours.appRed,
            ),
            child: const Text('Clear')),
        ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton
                .styleFrom(
              primary:
              AppColours.appPurpleLight,
            ),
            child:
            const Text('Cancel')),
      ]);

}
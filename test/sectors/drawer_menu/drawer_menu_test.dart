import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shipping_inspection_app/main.dart';
import 'package:shipping_inspection_app/sectors/communication/channel_selection.dart';
import 'package:shipping_inspection_app/sectors/home/home_hub.dart';

import '../communication/communication_setup_test.dart';

void main() {
  testWidgets(
    'Go to Communication Setup Screen',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const ChannelNameSelection(
            vesselID: "test",
          ),
        ),
      );

      // INIT Complete here

      final finder = find.byType(MaterialButton);

      expect(finder, findsWidgets);
    },
  );
}

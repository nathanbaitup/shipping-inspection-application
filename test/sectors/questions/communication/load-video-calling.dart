import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:shipping_inspection_app/sectors/communication/channel_selection.dart';

Widget buildTestWidget(Widget widget) {
  return MediaQuery(
    data: const MediaQueryData(),
    child: MaterialApp(
      home: widget,
    ),
  );
}

void main() {
  group(
    'description',
    () {
      testWidgets(
        'Go to Register Screen',
        (WidgetTester tester) async {
          // Defaulting to Landscape for some unknown reason
          SystemChrome.setPreferredOrientations(
              [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

          await Firebase.initializeApp();

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

      testWidgets(
        'Testing input in the text field',
        ((tester) async {
          SystemChrome.setPreferredOrientations(
              [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

          await Firebase.initializeApp();

          await tester.pumpWidget(
            buildTestWidget(
              const ChannelNameSelection(
                vesselID: "test",
              ),
            ),
          );

          // INIT Complete here

          await tester.enterText(
              find.byType(TextFormField), 'load-video-calling.dart test-2');
        }),
      );

      testWidgets(
        'Testing Generate Channel button',
        ((tester) async {
          SystemChrome.setPreferredOrientations(
              [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

          await Firebase.initializeApp();

          await tester.pumpWidget(
            buildTestWidget(
              const ChannelNameSelection(
                vesselID: "test",
              ),
            ),
          );

          // INIT Complete here

          // Finding the button
          await tester.tap(
            find.byKey(
              const Key('IDWALCommunicationGenerateChannelButton'),
            ),
          );

          // reloading the widget

          await tester.pump(const Duration(milliseconds: 400));

          // Finding the textField
          final textField = find.byType(TextFormField);

          // REFERENCE https://stackoverflow.com/a/54236046

          var textResult = textField.evaluate().single.widget as TextFormField;

          // print(textResult);

          // final result = textField.;
        }),
      );
    },
  );
}

// https://stackoverflow.com/a/56184403 Fix MediaQuery bug?

// void main() {
//   Widget createWidgetForTesting({required Widget child}) {
//     return MaterialApp(
//       home: child,
//     );
//   }

//   testWidgets('Login Page smoke test', (WidgetTester tester) async {
//     await tester.pumpWidget(createWidgetForTesting(
//         child: new ChannelNameSelection(
//       vesselID: 'HelloWorldTesting',
//     )));

//     await tester.pumpAndSettle();
//   });
// }

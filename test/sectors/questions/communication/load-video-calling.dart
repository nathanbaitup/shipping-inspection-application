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

          // await tester.tap(goToVideoCallingScreen);

          // final titleFinder = find.text('Join/Create Channel');

          // expect(titleFinder, findsOneWidget);

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

          await tester.enterText(find.byType(TextFormField), 'hi');
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

          // Finding the textField
          final textField = find.byType(TextFormField);

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

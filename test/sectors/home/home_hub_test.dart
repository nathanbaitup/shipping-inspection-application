
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:shipping_inspection_app/sectors/home/home_hub.dart';

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
    'Home Page Tests',
        () {

      testWidgets(
        '- Home Test 1 - Go to Home Page ',
            (WidgetTester tester) async {
          SystemChrome.setPreferredOrientations(
              [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

          //-- Firebase initialisation causes errors
          //await Firebase.initializeApp();

          await tester.pumpWidget(
            buildTestWidget(
              const HomeHub(
                vesselID: "test",
              ),
            ),
          );

          final finder = find.byType(Container);

          expect(finder, findsWidgets);
        },
      );

      testWidgets(
        '- Home Test 2 - Test Progress Widget (F&S) ',
        ((tester) async {
          SystemChrome.setPreferredOrientations(
              [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

          //-- Firebase initialisation causes errors
          //await Firebase.initializeApp();

          await tester.pumpWidget(
            buildTestWidget(
              const HomeHub(
                vesselID: "test",
              ),
            ),
          );

          await tester.tap(
            find.byKey(
              const Key('IDWALFireAndSafetySectionProgressWidget'),
            ),
          );
        }),
      );

      testWidgets(
        '- Home Test 3 - Test Channel Settings Button ',
        ((tester) async {
          SystemChrome.setPreferredOrientations(
              [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

          //-- Firebase initialisation causes errors
          //await Firebase.initializeApp();

          await tester.pumpWidget(
            buildTestWidget(
              const HomeHub(
                vesselID: "test",
              ),
            ),
          );

          await tester.tap(
            find.byKey(
              const Key('IDWALHomeHubChannelSettingsButton'),
            ),
          );
        }),
      );
    },
  );
}

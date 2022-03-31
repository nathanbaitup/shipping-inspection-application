
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:shipping_inspection_app/sectors/survey/survey_hub.dart';

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
    'Survey Hub Page Tests',
        () {

      testWidgets(
        '- Survey Hub Test 1 - Go to Home Page ',
            (WidgetTester tester) async {
          SystemChrome.setPreferredOrientations(
              [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

          //-- Firebase initialisation causes errors
          //await Firebase.initializeApp();

          await tester.pumpWidget(
            buildTestWidget(
              const SurveyHub(
                vesselID: "test",
              ),
            ),
          );

          final finder = find.byType(Container);

          expect(finder, findsWidgets);
        },
      );

      testWidgets(
        '- Survey Hub Test 2 - Survey Section Help Button ',
        ((tester) async {
          SystemChrome.setPreferredOrientations(
              [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

          //-- Firebase initialisation causes errors
          //await Firebase.initializeApp();

          await tester.pumpWidget(
            buildTestWidget(
              const SurveyHub(
                vesselID: "test",
              ),
            ),
          );

          final finder = find.byKey(
            const Key('IDWALSurveyHubSectionsHelpButton'),
          );

          expect(finder, findsWidgets);
        }),
      );

      testWidgets(
        '- Survey Hub Test 3 - QR Camera Button ',
        ((tester) async {
          SystemChrome.setPreferredOrientations(
              [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

          //-- Firebase initialisation causes errors
          //await Firebase.initializeApp();

          await tester.pumpWidget(
            buildTestWidget(
              const SurveyHub(
                vesselID: "test",
              ),
            ),
          );

          await tester.tap(
            find.byKey(
              const Key('IDWALQRCameraButton'),
            ),
          );
        }),
      );
    },
  );
}

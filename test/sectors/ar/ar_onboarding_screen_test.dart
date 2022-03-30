import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:shipping_inspection_app/sectors/ar/ar_onboarding_screen.dart';

Widget buildTestWidget(Widget widget) {
  return MediaQuery(
    data: const MediaQueryData(),
    child: MaterialApp(
      home: widget,
    ),
  );
}

main() {
  group("Testing the AR Instructions screen displays correctly", () {
    testWidgets("Should load the AR Instructions Screen",
        (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget(
        const ARIntroduction(vesselID: 'vesselID', questionID: 'f&s'),
      ));
    });

    testWidgets("Should find the Skip and Finish Buttons",
        (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget(
        const ARIntroduction(vesselID: 'vesselID', questionID: 'f&s'),
      ));

      final button = find.byType(Material);
      expect(button, findsWidgets);
    });

    testWidgets("Should find the page title", (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget(
        const ARIntroduction(vesselID: 'vesselID', questionID: 'f&s'),
      ));

      final titleText = find.text("Idwal Vessel Inspection");
      expect(titleText, findsOneWidget);
    });
  });
}

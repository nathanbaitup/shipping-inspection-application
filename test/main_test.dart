import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shipping_inspection_app/main.dart';

void main() {
  group("Testing the main and welcome screens display correctly", () {
    testWidgets("Call the main screen.", (WidgetTester tester) async {
      await tester.pumpWidget(const ShipApp());
    });

    testWidgets("Should find the first page to open be the Welcome Screen",
        ((tester) async {
      await tester.pumpWidget(const ShipApp());

      var inputVesselField = find.byType(TextField);
      expect(inputVesselField, findsOneWidget);
    }));

    testWidgets("Should find the welcome text", ((tester) async {
      await tester.pumpWidget(const ShipApp());

      const String titleText = 'Idwal Vessel Inspector';
      var welcomeTitle = find.text(titleText);
      expect(welcomeTitle, findsOneWidget);
    }));

    testWidgets("Should find the button to save an ID", ((tester) async {
      await tester.pumpWidget(const ShipApp());

      var submitButton = find.byType(ElevatedButton);
      expect(submitButton, findsOneWidget);
    }));

    testWidgets(
        "Should press the button with no text entered, should return validation error",
        ((tester) async {
      await tester.pumpWidget(const ShipApp());

      const String vesselIDErrorText = 'Please enter a Vessel name or ID';

      var submitButton = find.byType(ElevatedButton);
      expect(submitButton, findsOneWidget);

      await tester.tap(submitButton);
      debugPrint('button pressed');
      await tester.pump();
      expect(find.text(vesselIDErrorText), findsOneWidget);
    }));

    testWidgets("Should enter and display text in text field", ((tester) async {
      await tester.pumpWidget(const ShipApp());

      const String vesselID = 'vesselTestID';
      var inputVesselField = find.byType(TextField);
      await tester.enterText(inputVesselField, vesselID);
      expect(find.text('vesselTestID'), findsOneWidget);
    }));

    testWidgets("Should submit vesselID and return the home page.",
        (WidgetTester tester) async {
      await tester.pumpWidget(const ShipApp());

      const String homePageTitleText = 'Current User';
      const String vesselID = 'vesselTestID';

      var inputVesselField = find.byType(TextField);
      await tester.enterText(inputVesselField, vesselID);

      var submitButton = find.byType(ElevatedButton);
      await tester.tap(submitButton);
      await tester.pump();

      expect(find.text(homePageTitleText), findsOneWidget);
      expect(find.text('Vessel: $vesselID'), findsOneWidget);
    });
  });
}

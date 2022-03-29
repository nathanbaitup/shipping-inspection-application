import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shipping_inspection_app/main.dart';

void main() {
  testWidgets("Test the main page displays the welcome page and its widgets.",
      (WidgetTester tester) async {
    // Calls the application to run main.
    await tester.pumpWidget(const ShipApp());

    // Should find the first page to open be the Welcome Screen.
    var inputVesselField = find.byType(TextField);
    expect(inputVesselField, findsOneWidget);

    // Tests that text can be entered in the text field.
    await tester.enterText(inputVesselField, "testVessel");
    expect(find.text('testVessel'), findsOneWidget);

    // Should find the button to save an entered ID.
    var submitButton = find.byType(ElevatedButton);
    expect(submitButton, findsOneWidget);

    // TODO: test button press with no text input - should give validation
    // TODO: test button press with text, should load homepage.
    // TODO: maybe check to see if the vesselID variable updated if thats possible.
    // TODO: Text to see the page title loads.
  });
}

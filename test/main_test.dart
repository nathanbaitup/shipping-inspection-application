import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shipping_inspection_app/main.dart';

void main() {
  testWidgets("Test the main page displays the welcome page and its widgets.",
      (WidgetTester tester) async {
    // Calls the application to run main.
    await tester.pumpWidget(const ShipApp());

    const String titleText = 'Idwal Vessel Inspector';
    const String vesselIDErrorText = 'Please enter a Vessel name or ID';
    const String homePageTitleText = 'Current User';
    const String vesselID = 'vesselTestID';

    // Should find the first page to open be the Welcome Screen.
    var inputVesselField = find.byType(TextField);
    expect(inputVesselField, findsOneWidget);

    // Should find the title text.
    var welcomeTitle = find.text(titleText);
    expect(welcomeTitle, findsOneWidget);

    // Should find the button to save an entered ID.
    var submitButton = find.byType(ElevatedButton);
    expect(submitButton, findsOneWidget);

    // Should press the button with no text entered.
    // Should return the validation error text.
    await tester.tap(submitButton);
    debugPrint('button pressed');
    await tester.pump();
    expect(find.text(vesselIDErrorText), findsOneWidget);

    // Tests that text can be entered in the text field.
    await tester.enterText(inputVesselField, vesselID);
    expect(find.text('vesselTestID'), findsOneWidget);

    // Tests that when a button is pressed with a vessel ID, it returns to the home page
    // Should display the default user and vesselID.
    await tester.tap(submitButton);
    await tester.pump();
    expect(find.text(homePageTitleText), findsOneWidget);
    expect(find.text('Vessel: $vesselID'), findsOneWidget);
  });
}

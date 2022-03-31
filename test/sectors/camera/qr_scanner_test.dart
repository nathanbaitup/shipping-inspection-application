import 'package:flutter_test/flutter_test.dart';
import 'package:shipping_inspection_app/sectors/camera/qr_scanner_controller.dart';

main() {
  group("Testing the QR Scanner displays correctly", () {
    testWidgets("Should load the QR Camera screen",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const QRScanner(vesselID: 'vesselID'),
      );
    });
    testWidgets("Should find the QR Camera Title", (WidgetTester tester) async {
      await tester.pumpWidget(
        const QRScanner(vesselID: 'vesselID'),
      );

      final pageTitle = find.text("Surveyor Camera");
      expect(pageTitle, findsOneWidget);
    });
  });
}

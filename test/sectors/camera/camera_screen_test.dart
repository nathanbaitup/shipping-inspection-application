import 'package:camera/camera.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shipping_inspection_app/sectors/camera/camera_screen.dart';

main() {
  group("Testing the camera screen displays correctly", () {
    testWidgets("Should load the Camera Screen", (WidgetTester tester) async {
      await tester.pumpWidget(
        const CameraScreen(
          vesselID: 'vesselID',
          cameras: [
            CameraDescription(
                name: 'back',
                lensDirection: CameraLensDirection.back,
                sensorOrientation: 90)
          ],
          questionID: 'f&s',
        ),
      );
    });
  });
}

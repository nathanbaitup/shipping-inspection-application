import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:shipping_inspection_app/sectors/communication/channel_selection.dart';

void main() {
  group('description', () {
    testWidgets('Go to Register Screen', (WidgetTester tester) async {
      // Defaulting to Landscape for some unknown reason
      SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

      await Firebase.initializeApp();

      final goToVideoCallingScreen = find.text('Calls');

      await tester
          .pumpWidget(ChannelNameSelection(vesselID: 'VideoCallFragmentTest'));

      // await tester.tap(goToVideoCallingScreen);

      final titleFinder = find.text('Join/Create Channel');

      expect(titleFinder, findsOneWidget);
    });
  });
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

import 'package:flutter/material.dart';
import 'package:shipping_inspection_app/sectors/ar/ar_hub.dart';
import 'package:shipping_inspection_app/userdashboard.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ShipApp());
}

class ShipApp extends StatelessWidget {
  const ShipApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shipping Application',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: const MyHomePage(title: 'Idwal Vessel Inspection App'),
    );
  }
}

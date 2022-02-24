import 'package:flutter/material.dart';
import 'package:shipping_inspection_app/home.dart';
import 'package:shipping_inspection_app/menu-feedback.dart';
import 'package:shipping_inspection_app/sectors/communication/startup.dart';
import 'package:shipping_inspection_app/sectors/survey/survey_hub.dart';
import 'package:shipping_inspection_app/menu-settings.dart';
import 'package:shipping_inspection_app/menu-help.dart';
import 'package:shipping_inspection_app/menu-history.dart';

import 'home.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    // Text(
    //   'Home',
    //   style: optionStyle,
    // ),
    Home(),
    SurveyHub(),
    CommunicationFront(),
    Text(
      'Calls',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,

      // -- App Bar Start

      appBar: AppBar(
        title: Text(widget.title),
        titleTextStyle: const TextStyle(color: Colors.purple),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: Transform.scale(
          scale: 0.7,
          child: FloatingActionButton(
            onPressed: () => _scaffoldKey.currentState?.openDrawer(),
            child: const Icon(Icons.menu),
          ),
        ),
      ),

      // -- App Bar End

      // -- Burger Menu Start

      drawer: Drawer(
        child: ListView(children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.purple,
            ),
            child: Container(
              alignment: Alignment.centerLeft,
              child: const Text(
                'Idwal Vessel Inspection App',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ),
          ListTile(
              title: const Text("Help"),
              iconColor: Colors.purple,
              leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => const MenuHelp()));
                },
                icon: const Icon(Icons.help),
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => const MenuHelp()));
              }),
          const Divider(
            color: Colors.grey,
          ),
          ListTile(
              title: const Text("History"),
              iconColor: Colors.purple,
              leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => const MenuHistory()));
                },
                icon: const Icon(Icons.history),
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => const MenuHistory()));
              }),
          const Divider(
            color: Colors.grey,
          ),
          ListTile(
              title: const Text("Feedback"),
              iconColor: Colors.purple,
              leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => const MenuFeedback()));
                },
                icon: const Icon(Icons.question_answer),
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => const MenuFeedback()));
              }),

          const Divider(
            color: Colors.grey,
          ),

          ListTile(
              title: const Text("Settings"),
              iconColor: Colors.purple,
              leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => const MenuSettings()));
                },
                icon: const Icon(Icons.settings),
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => const MenuSettings()));
              }),
          const Divider(
            color: Colors.grey,
          ),
        ]),
      ),

      // -- Burger Menu End

      // -- Nav Bar Start

      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.smart_screen),
            label: 'AR',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.call),
            label: 'Calls',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.purple,
        onTap: _onItemTapped,
      ),

      // -- Nav Bar End
    );
  }
}

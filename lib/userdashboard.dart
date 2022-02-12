import 'package:flutter/material.dart';

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
    Text(
      'Home',
      style: optionStyle,
    ),
    Text(
      'AR',
      style: optionStyle,
    ),
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
      floatingActionButtonLocation:
      FloatingActionButtonLocation.startFloat,
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
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
                decoration: const BoxDecoration(
                  color: Colors.purple,
                ),
                  child: Container (
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
          ]
        ),
      ),
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
    );
  }
}

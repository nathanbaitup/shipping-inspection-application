import 'package:flutter/material.dart';
import 'package:shipping_inspection_app/sectors/communication/channel_selection.dart';
import 'package:shipping_inspection_app/sectors/drawer/drawer_feedback.dart';
import 'package:shipping_inspection_app/sectors/drawer/drawer_history.dart';
import 'package:shipping_inspection_app/sectors/home/home_hub.dart';
import 'package:shipping_inspection_app/sectors/survey/survey_hub.dart';
import 'package:shipping_inspection_app/sectors/drawer/drawer_settings.dart';
import 'package:shipping_inspection_app/sectors/drawer/drawer_help.dart';
import 'package:shipping_inspection_app/utils/app_colours.dart';
import 'package:shipping_inspection_app/sectors/drawer/drawer_globals.dart'
    as app_globals;

String vesselID = '';

int selectedIndex = 0;

final ValueNotifier<int> indexNotifier = ValueNotifier(selectedIndex);

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title, required this.vesselID})
      : super(key: key);

  final String title;
  final String vesselID;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    vesselID = widget.vesselID;
  }

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static final List<Widget> _widgetOptions = <Widget>[
    HomeHub(vesselID: vesselID),
    SurveyHub(vesselID: vesselID),
    ChannelNameSelection(vesselID: vesselID),
    const Text(
      'Calls',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int inputIndex) {
    setState(() {
      indexNotifier.value = inputIndex;
    });
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
        valueListenable: indexNotifier,
        builder: (_, index, __) {
          selectedIndex = index;
          return Scaffold(
            key: _scaffoldKey,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.startFloat,

            // -- App Bar Start

            appBar: AppBar(
              title: Text(widget.title),
              titleTextStyle: const TextStyle(color: AppColours.appPurple),
              centerTitle: true,
              backgroundColor: app_globals.getAppbarColour(),
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
                    color: AppColours.appPurple,
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
                    iconColor: AppColours.appPurple,
                    leading: IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) =>
                                const MenuHelp()));
                      },
                      icon: const Icon(Icons.help),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) => const MenuHelp()));
                    }),
                _drawerDivider(),
                ListTile(
                    title: const Text("History"),
                    iconColor: AppColours.appPurple,
                    leading: IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) =>
                                const MenuHistory()));
                      },
                      icon: const Icon(Icons.history),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) =>
                              const MenuHistory()));
                    }),
                _drawerDivider(),
                ListTile(
                    title: const Text("Feedback"),
                    iconColor: AppColours.appPurple,
                    leading: IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) =>
                                MenuFeedback(vesselID: vesselID)));
                      },
                      icon: const Icon(Icons.question_answer),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) =>
                              MenuFeedback(vesselID: vesselID)));
                    }),
                _drawerDivider(),
                ListTile(
                    title: const Text("Settings"),
                    iconColor: AppColours.appPurple,
                    leading: IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) =>
                                const MenuSettings()));
                      },
                      icon: const Icon(Icons.settings),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) =>
                              const MenuSettings()));
                    }),
                _drawerDivider(),
              ]),
            ),

            // -- Burger Menu End

            // -- Nav Bar Start

            body: Center(
              child: _widgetOptions.elementAt(selectedIndex),
            ),

            bottomNavigationBar: BottomNavigationBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.smart_screen),
                  label: 'Surveys',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.call),
                  label: 'Calls',
                ),
              ],
              currentIndex: selectedIndex,
              selectedItemColor: AppColours.appPurple,
              onTap: _onItemTapped,
            ),

            // -- Nav Bar End
          );
        });
  }

  SizedBox _drawerDivider() {
    return SizedBox(
      height: 8.0,
      child: Center(
        child: Container(
          margin: const EdgeInsetsDirectional.only(start: 5.0, end: 5.0),
          height: 1,
          color: Colors.grey,
        ),
      ),
    );
  }
}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pomrade/bloc/pomrade_bloc.dart';
import 'package:pomrade/screens/login.dart';
import 'package:pomrade/screens/music.dart';
import 'package:pomrade/screens/notes.dart';
import 'package:pomrade/screens/pomodoro.dart';
import 'package:pomrade/screens/register.dart';
import 'package:pomrade/screens/settings.dart';
import 'package:pomrade/screens/siteblock.dart';
import 'package:pomrade/screens/tasks.dart';

class Destination {
  final Widget icon;
  final Widget? selectedIcon;
  final String labelText;

  const Destination({required this.icon, this.selectedIcon, required this.labelText});
}

extension DestinationListExtension on List<Destination> {
  List<NavigationDestination> toNavigationDestinations() {
    return map(
      (dest) {
        return NavigationDestination(
          icon: dest.icon,
          selectedIcon: dest.selectedIcon,
          label: dest.labelText,
        );
      }
    ).toList();
  }

  List<NavigationRailDestination> toNavigationRailDestinations({double bottomPadding=0}) {
    return map(
      (dest) {
        return NavigationRailDestination(
          icon: dest.icon,
          selectedIcon: dest.selectedIcon,
          label: Text(dest.labelText),
          padding: EdgeInsets.only(bottom: bottomPadding)
        );
      }
    ).toList();
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int pageIndex = 0;
  bool useNavRail = false;
  String text = "waiting for press";
  List<Widget> pages = [];
  PageController pageCtl = PageController(initialPage: 0);

  List<Destination> destinations = [
    const Destination(
      icon: Icon(Icons.task_alt),
      labelText: 'Tasks',
    ),
    const Destination(
      selectedIcon: Icon(Icons.timer_rounded),
      icon: Icon(Icons.timer_outlined),
      labelText: 'Pomodoro',
    ),
    const Destination(
      selectedIcon: Icon(Icons.library_books),
      icon: Icon(Icons.library_books_outlined),
      labelText: 'Notes',
    ),
    if (Platform.isWindows) ...[
      const Destination(
        selectedIcon: Icon(Icons.music_note),
        icon: Icon(Icons.music_note_outlined),
        labelText: 'Music',
      ),
      const Destination(
        icon: Icon(Icons.public_off),
        labelText: 'SiteBlock',
      ),
    ],
    const Destination(
      selectedIcon: Icon(Icons.settings),
      icon: Icon(Icons.settings_outlined),
      labelText: 'Settings',
    ),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pages = const [
      TasksPage(),
      PomodoroPage(),
      NotesPage(),
      MusicPage(),
      SiteBlockPage(),
      SettingsPage()
    ];
  }

  @override
  Widget build(BuildContext context) {
    useNavRail = MediaQuery.of(context).size.width > 600;
    return Scaffold(
      bottomNavigationBar: useNavRail ? null : NavigationBar(
        onDestinationSelected: (value) {
          setState(() {
            pageIndex = value;
          });
          pageCtl.animateToPage(value, duration: Duration(milliseconds: 200), curve: Curves.decelerate);
        },
        selectedIndex: pageIndex,
        destinations: destinations.toNavigationDestinations()
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            
            if (useNavRail) SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height),
                child: IntrinsicHeight(
                  child: NavigationRail(
                    destinations: destinations.toNavigationRailDestinations(bottomPadding: 20), 
                    selectedIndex: pageIndex,
                    onDestinationSelected: (value) {
                        setState(() {
                          pageIndex = value;
                        });
                        pageCtl.animateToPage(value, duration: Duration(milliseconds: 200), curve: Curves.decelerate);
                    },
                    labelType: NavigationRailLabelType.all,
                    backgroundColor: Colors.white10,
                  ),
                ),
              ),
            ),
            Expanded(
              child: PageView(
                children: pages,
                physics: NeverScrollableScrollPhysics(),
                scrollDirection: useNavRail? Axis.vertical:Axis.horizontal,
                controller: pageCtl,
              )
            ),
          ],
        ),
      ),// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

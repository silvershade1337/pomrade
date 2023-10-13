import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pomrade/bloc/pomrade_bloc.dart';
import 'package:pomrade/screens/music.dart';

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

  List<Destination> destinations = const [
    Destination(
      selectedIcon: Icon(Icons.home),
      icon: Icon(Icons.home_outlined),
      labelText: 'Home',
    ),
    Destination(
      icon: Icon(Icons.task_alt),
      labelText: 'Tasks',
    ),
    Destination(
      selectedIcon: Icon(Icons.timer_rounded),
      icon: Icon(Icons.timer_outlined),
      labelText: 'Pomodoro',
    ),
    Destination(
      selectedIcon: Icon(Icons.library_books),
      icon: Icon(Icons.library_books_outlined),
      labelText: 'Notes',
    ),
    Destination(
      selectedIcon: Icon(Icons.music_note),
      icon: Icon(Icons.music_note_outlined),
      labelText: 'Music',
    ),
    Destination(
      selectedIcon: Icon(Icons.settings),
      icon: Icon(Icons.settings_outlined),
      labelText: 'Settings',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    useNavRail = MediaQuery.of(context).size.width > 600;
    return Scaffold(
      bottomNavigationBar: useNavRail ? null : NavigationBar(
        onDestinationSelected: (value) {
          setState(() {
            pageIndex = value;
          });
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
                    },
                    labelType: NavigationRailLabelType.all,
                    backgroundColor: Colors.white10,
                  ),
                ),
              ),
            ),
            Expanded(
              child: PlayListBrowser()
            ),
          ],
        ),
      ),// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

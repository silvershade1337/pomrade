import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  TextEditingController textInput1Controller = TextEditingController();
  TextEditingController textInput2Controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text("Settings", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),),
          ),
          
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 400),
            child: ListTile(
              title: Text("Set Pomodoro Work Duration"),
              subtitle: TextField(
                keyboardType: TextInputType.number,
                controller: textInput1Controller,
                decoration: InputDecoration(
                  hintText: "Enter in Minutes",
                  border: OutlineInputBorder()
                ),
              ),
            ),
          ),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 400),
            child: ListTile(
              title: Text("Set Pomodoro Break Duration"),
              subtitle: TextField(
                keyboardType: TextInputType.number,
                controller: textInput2Controller,
                decoration: InputDecoration(
                  hintText: "Enter in Minutes",
                  border: OutlineInputBorder()
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

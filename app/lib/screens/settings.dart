import 'package:flutter/material.dart';
import 'package:pomrade/models.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  TextEditingController textInput1Controller = TextEditingController(text: SettingsManager.cache["pomoWork"].toString());
  TextEditingController textInput2Controller = TextEditingController(text: SettingsManager.cache["pomoBreak"].toString());

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 400),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text("Settings", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text("Pomodoro Settings"),
            ),
            Divider(),
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
            ),
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                height: 40,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    backgroundColor: Colors.deepPurple[200],
                    foregroundColor: Colors.black
                  ),
                  onPressed: () {
                    
                  },
                  child: Text("Save"),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

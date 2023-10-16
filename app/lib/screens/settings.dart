import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pomrade/bloc/pomrade_bloc.dart';
import 'package:pomrade/models.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  TextEditingController pomoWorkController = TextEditingController(text: SettingsManager.cache["pomoWork"].toString());
  TextEditingController pomoBreakController = TextEditingController(text: SettingsManager.cache["pomoBreak"].toString());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  String? isPomoSettingsValid() {
    if (BlocProvider.of<PomradeBloc>(context).state.pomoOn) {
      return "Cannot change pomodoro settings when Pomodoro timer is running";
    }
    else if (! (Utilities.onlyDigits(pomoWorkController.text) && Utilities.onlyDigits(pomoBreakController.text)) ) {
      return "Please enter Pomodoro Time in Minutes only";
    }
    return null;
  }

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
                  controller: pomoWorkController,
                  decoration: InputDecoration(
                    hintText: "Enter in Minutes",
                    border: OutlineInputBorder()
                  ),
                  onChanged: (value) => setState(() {}),
                ),
              ),
            ),
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 400),
              child: ListTile(
                title: Text("Set Pomodoro Break Duration"),
                subtitle: TextField(
                  keyboardType: TextInputType.number,
                  controller: pomoBreakController,
                  decoration: InputDecoration(
                    hintText: "Enter in Minutes",
                    border: OutlineInputBorder()
                  ),
                  onChanged: (value) => setState(() {}),
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
                    String? validity = isPomoSettingsValid();
                    String messageToShow = "Settings changed succesfully!";
                    if(validity == null) {
                      SettingsManager.cache["pomoWork"] = int.parse(pomoWorkController.text);
                      SettingsManager.cache["pomoBreak"] = int.parse(pomoBreakController.text);
                      SettingsManager.setSettings(SettingsManager.cache);
                    }
                    else {
                      messageToShow = validity;
                    }
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(messageToShow)));
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

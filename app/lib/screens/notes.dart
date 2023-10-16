import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pomrade/bloc/pomrade_bloc.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  TextEditingController mainNotesController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mainNotesController.text = BlocProvider.of<PomradeBloc>(context).state.startedTask?.notes ?? "";
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider.of<PomradeBloc>(context).state.startedTask == null? 
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.do_not_disturb_on_rounded, size: 50,),
            Text("No Task Started", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
            Text("Start a Task to take notes about it")
          ],
        ),
      )
      :
      Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white12,
                borderRadius: BorderRadius.circular(10),
              ),
              height: 50,
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        SizedBox(width: 10,),
                        Text("Notes about Task: ", maxLines: 1,),
                        Text(BlocProvider.of<PomradeBloc>(context).state.startedTask!.name, maxLines: 1, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.deepPurple[200]),),
                      ],
                    )
                  ),
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        backgroundColor: Colors.deepPurple[200],
                        foregroundColor: Colors.black
                      ),
                      onPressed: () {
                        BlocProvider.of<PomradeBloc>(context).state.startedTask!.notes = mainNotesController.text.trim();
                        BlocProvider.of<PomradeBloc>(context).add(TasksChangedEvent(BlocProvider.of<PomradeBloc>(context).state.tasks));
                      },
                      child: Text("Save"),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: TextField(
                  controller: mainNotesController,
                  decoration: InputDecoration(
                    hintText: "Take notes about current task",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)
                    )
                  ),
                  maxLines: 1000,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
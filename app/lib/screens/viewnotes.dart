import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pomrade/bloc/pomrade_bloc.dart';
import 'package:pomrade/models.dart';

class ViewNotesPage extends StatelessWidget {
  final Task task;

  const ViewNotesPage({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
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
                        SizedBox(
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              backgroundColor: Colors.deepPurple[200],
                              foregroundColor: Colors.black
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text("Close"),
                          ),
                        ),
                        SizedBox(width: 10,),
                        Text("Viewing Notes about Task: ", maxLines: 1,),
                        Text(task.name, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.deepPurple[200]),),
                      ],
                    )
                  ),
                  
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: TextField(
                  controller: TextEditingController(text: task.notes),
                  readOnly: true,
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
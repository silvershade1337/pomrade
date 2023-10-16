import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pomrade/bloc/pomrade_bloc.dart';
import 'package:pomrade/models.dart';

class PomodoroPage extends StatefulWidget {
  const PomodoroPage({super.key});

  @override
  State<PomodoroPage> createState() => _PomodoroPageState();
}

class _PomodoroPageState extends State<PomodoroPage> with AutomaticKeepAliveClientMixin {
  bool block = false;
  Timer? timer;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startStateTicker();
  }

  void startStateTicker() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      PomradeBloc bloc = BlocProvider.of<PomradeBloc>(context);
      var screensize =  MediaQuery.of(context).size;
      if (bloc.state.pomoOn) {
        var completion = DateTime.now().difference(bloc.state.subStart!).inSeconds / (bloc.state.pomoWork? Duration(minutes: SettingsManager.cache["pomoWork"]): Duration(minutes:SettingsManager.cache["pomoBreak"])).inSeconds;
        if(completion >= 1 ) {
          bloc.state.pomoWork = !bloc.state.pomoWork;
          bloc.state.subStart = DateTime.now();
        }
      }
      setState(() {
        
      });
    });
  }

  void stopStateTicker() {
    timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    print("built");
    super.build(context);
    
    PomradeBloc bloc = BlocProvider.of<PomradeBloc>(context);
    var screensize =  MediaQuery.of(context).size;
    return Center(
      child: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
            child: Row(
              children: [
                const Text(
                  "Pomodoro Timer ",
                  style:
                      TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                
              ],
            ),
          ),
          if (bloc.state.startedTask != null) Container(
            margin: EdgeInsets.all(20),
            color: Colors.black12,
            child: Column(
              children: [
                Text("Your Task: ", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),),
                Text(bloc.state.startedTask!.name)
              ],
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Column(
              children: [
                SizedBox(height: 50,),
                SizedBox(
                  width: min(screensize.width, screensize.height)*0.45,
                  height: min(screensize.width, screensize.height)*0.45,
                  child: Stack(
                    children: [
                      SizedBox(
                        width: min(screensize.width, screensize.height)*0.45,
                      height: min(screensize.width, screensize.height)*0.45,
                        child: CircularProgressIndicator(
                          value: bloc.state.pomoOn?
                            DateTime.now().difference(bloc.state.subStart!).inSeconds / (bloc.state.pomoWork?Duration(minutes: SettingsManager.cache["pomoWork"]): Duration(minutes:SettingsManager.cache["pomoBreak"])).inSeconds
                            :
                            0,
                          strokeWidth: 15,
                          backgroundColor: Colors.white12,
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: bloc.state.pomoOn ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(bloc.state.pomoWork?"WORK":"BREAK", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),),
                            Text(
                              "${ Utilities.formatDuration(DateTime.now().difference(bloc.state.subStart!))}"
                              " / "
                              "${ Utilities.formatDuration(bloc.state.pomoWork?Duration(minutes: SettingsManager.cache["pomoWork"]): Duration(minutes:SettingsManager.cache["pomoBreak"]))}"
                            ),
                          ],
                        )
                        :
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)
                            ),
                            padding: EdgeInsets.all(20),
                            backgroundColor: Colors.green[200],
                            foregroundColor: Colors.black
                          ),
                          onPressed: () {
                            PomradeState state = bloc.state;
                            state.pomoOn = true;
                            state.pomoStart = DateTime.now();
                            state.subStart = DateTime.now();
                            state.pomoWork = true;
                            setState(() {
                              
                            });
                            if (! (timer?.isActive ?? false)) {
                              startStateTicker();
                            }
                          }, 
                          
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.play_arrow),
                              Text("Start Pomodoro")
                            ],
                          )
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          if (bloc.state.pomoOn) Padding(
            padding: const EdgeInsets.only(top:20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                      ),
                      padding: EdgeInsets.all(20),
                      backgroundColor: Colors.red[200],
                      foregroundColor: Colors.black
                    ),
                    onPressed: () {
                      PomradeState state = bloc.state;
                      state.pomoOn = false;
                      setState(() {
                        
                      });
                    }, 
                    
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.stop),
                      ],
                    )
                  ),
                ),
                if (bloc.state.startedTask!=null) Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                      ),
                      padding: EdgeInsets.all(20),
                      backgroundColor: Colors.green[200],
                      foregroundColor: Colors.black
                    ),
                    onPressed: () {
                      PomradeState state = bloc.state;
                      state.pomoOn = false;
                      for (var taskk in state.tasks) {
                        if(taskk.id == bloc.state.startedTask!.id) {
                          taskk.completed = true;
                          BlocProvider.of<PomradeBloc>(context).add(TasksChangedEvent(state.tasks));
                        }
                      }
                      setState(() {
                        state.startedTask = null;
                      });
                    }, 
                    
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check),
                        Text("Mark Task as complete")
                      ],
                    )
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
  
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => BlocProvider.of<PomradeBloc>(context).state.pomoOn;
}

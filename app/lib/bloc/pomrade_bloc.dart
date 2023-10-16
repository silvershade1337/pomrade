import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:pomrade/models.dart';
import 'package:pomrade/screens/music.dart';

part 'pomrade_event.dart';
part 'pomrade_state.dart';

class PomradeBloc extends Bloc<PomradeEvent, PomradeState> {
  PomradeBloc() : super(PomradeState()) {
    on<PomradeEvent>((event, emit) {
      
    });
    on<CompleteTaskEvent>((event, emit) {
      event.taskId;
    });
    on<ToggleSiteblockEvent>((event, emit) {
      print(File("C:\\Windows\\System32\\drivers\\etc\\hosts").readAsStringSync());
    });
    on<TasksChangedEvent>((event, emit) {
      if(state.windows) {
        File tfile = File(state.dataLocation!+"\\tasks.json");
        tfile.writeAsString(event.tasks.toJson());
      }
    });
  }
}

import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pomrade/models.dart';

part 'pomrade_event.dart';
part 'pomrade_state.dart';

class PomradeBloc extends Bloc<PomradeEvent, PomradeState> {
  PomradeBloc() : super(PomradeState()) {
    on<PomradeEvent>((event, emit) {
      
    });
    on<CompleteTaskEvent>((event, emit) {
      event.taskId;
    });
  }
}

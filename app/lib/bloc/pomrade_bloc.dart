import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'pomrade_event.dart';
part 'pomrade_state.dart';

class PomradeBloc extends Bloc<PomradeEvent, PomradeState> {
  PomradeBloc() : super(PomradeState()) {
    on<PomradeEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}

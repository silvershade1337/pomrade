import 'package:audioplayers/audioplayers.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:pomrade/screens/music.dart';

part 'musicplayer_event.dart';
part 'musicplayer_state.dart';

class MusicplayerBloc extends Bloc<MusicplayerEvent, MusicplayerState> {
  MusicplayerBloc() : super(MusicplayerState()) {
    on<MusicplayerEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<StartPlaying>((event, emit) {
      _startPlaying(state, event, emit);
    });
    on<PausePlaying>((event, emit) {
      if (state.playing) {
        MusicplayerState.player.pause();
        state.playing = false;
        emit(state.copy());
      }
    });
    on<ResumePlaying>((event, emit) {
      if (!state.playing) {
        MusicplayerState.player.resume();
        state.playing = true;
        emit(state.copy());
      }
    });
    on<PlayNext>((event, emit) async {
      if (state.currentMusic+1 < state.musicFileDetails.length) {
        state.currentMusic += 1;
      }
      else {
        state.currentMusic = 0;
      }
      _startPlaying(state, event, emit);
      
    });
    on<PlayPrevious>((event, emit) async {
      if (state.currentMusic-1 >= 0) {
        state.currentMusic -= 1;
      }
      else {
        state.currentMusic = state.musicFileDetails.length-1;
      }
      _startPlaying(state, event, emit);
    });
    on<SkipTo>((event, emit) async {
      if (event.index  < state.musicFileDetails.length) {
        state.currentMusic = event.index;
      }
      _startPlaying(state, event, emit);
    });
  }
}

void _startPlaying(state, event, emit) {
  if (state.currentMusic < state.musicFileDetails.length) {
    print("playign called");
    MusicplayerState.player.stop();
    MusicplayerState.player.play(DeviceFileSource(state.musicFileDetails[state.currentMusic].path));
    state.name = state.musicFileDetails[state.currentMusic].name;
    state.playing = true;
    emit(state.copy());
  }
}

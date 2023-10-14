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
      if (!state.playing) {
        MusicplayerState.player.play(DeviceFileSource(event.musicFileDetails.path));
        state.musicFileDetails = event.musicFileDetails;
        state.name = event.musicFileDetails.name;
        state.playing = true;
        
        emit(state.copy());
      }
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
  }
}

part of 'musicplayer_bloc.dart';

@immutable
sealed class MusicplayerEvent {}

class StartPlaying extends MusicplayerEvent {
  final MusicFileDetails musicFileDetails;
  StartPlaying({required this.musicFileDetails});
}

class PausePlaying extends MusicplayerEvent {}

class ResumePlaying extends MusicplayerEvent {}

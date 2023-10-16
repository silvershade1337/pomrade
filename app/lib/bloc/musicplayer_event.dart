part of 'musicplayer_bloc.dart';

@immutable
sealed class MusicplayerEvent {}

class StartPlaying extends MusicplayerEvent {}

class PausePlaying extends MusicplayerEvent {}

class ResumePlaying extends MusicplayerEvent {}

class PlayNext extends MusicplayerEvent {}

class PlayPrevious extends MusicplayerEvent {}

class SkipTo extends MusicplayerEvent {
  final int index;
  SkipTo(this.index);
}
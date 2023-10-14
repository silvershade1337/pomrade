part of 'musicplayer_bloc.dart';

class MusicplayerState extends Equatable {
  bool playing = false;
  bool antiEqual = false;
  String name = "Nothing playing now";
  MusicFileDetails? musicFileDetails;
  static AudioPlayer player = AudioPlayer();


  MusicplayerState copy() {
    MusicplayerState re = MusicplayerState();
    re.playing = playing;
    re.name = name;
    re.musicFileDetails = musicFileDetails;
    re.antiEqual = !antiEqual;
    return re;
  }
  
  @override
  List<Object> get props => [playing, name, antiEqual];
}

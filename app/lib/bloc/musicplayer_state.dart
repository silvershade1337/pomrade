part of 'musicplayer_bloc.dart';

class MusicplayerState extends Equatable {
  bool playing = false;
  bool antiEqual = false;
  String name = "Nothing playing now";
  String playlistName = "No playlist selected";
  List<MusicFileDetails> musicFileDetails = [];
  int currentMusic = 0;
  static AudioPlayer player = AudioPlayer();


  MusicplayerState copy() {
    MusicplayerState re = MusicplayerState();
    re.playing = playing;
    re.currentMusic = currentMusic;
    re.playlistName = playlistName;
    re.name = name;
    re.musicFileDetails = musicFileDetails;
    re.antiEqual = !antiEqual;
    return re;
  }
  
  @override
  List<Object> get props => [playing, name, antiEqual];
}

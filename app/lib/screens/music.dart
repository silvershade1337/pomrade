import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pomrade/bloc/musicplayer_bloc.dart';
import 'package:pomrade/bloc/pomrade_bloc.dart';
import 'package:pomrade/models.dart';

class YoutubePlaylist {
  String name;
  int itemCount;
  List<MusicFileDetails> musicFileDetails = [];

  YoutubePlaylist({required this.name, required this.itemCount});
  
  Map toMap() {
    // TODO:
    return Map();
  }
}

class MusicFileDetails {
  String path;
  String name;
  MusicFileDetails({required this.name, required this.path});
}

class YoutubeDl {
  static String? ytdlpPath;
  static String? dataMusicPath;

  static Future<(String?, int?)> getPlaylistNameItemCount(String url) async {
    if (ytdlpPath != null) {
      ProcessResult pr = await Process.run(ytdlpPath!, [url, "-s", "-I", "0"]);
      RegExp rePname = RegExp(r"\[download\] Downloading playlist: (.*)");
      RegExp reIcount = RegExp(r"Downloading 0 items of (\d+)");
      var match = rePname.firstMatch(pr.stdout);
      String? title = match?.group(1);
      match = reIcount.firstMatch(pr.stdout);
      int? itemCount = int.tryParse(match?.group(1) ?? "");
      return (title, itemCount);
    }
    return (null, null);
  }

  static Future<YoutubePlaylist?> downloadPlaylist(String url) async {
      String? playlistName;
      int? ic;
      (playlistName, ic) = await getPlaylistNameItemCount(url);
      String outFormat = dataMusicPath!+"\\$playlistName"+r'\song%(playlist_index)d.%(ext)s';
      String printFormat = "'"r'[REQUESTED OUTPUT] {"title": "%(title)s","file": "'+ dataMusicPath!+"\\$playlistName"+r'\song%(playlist_index)d.mp3"}';
      print(outFormat);
      print(printFormat);
      // return null;
      ProcessResult pr = await Process.run(ytdlpPath!, [url, "-x", "--audio-format", "mp3", "-o", outFormat, "-I", ":10", "-O", printFormat, "--no-quiet", "--no-simulate"]);
      print(pr.stdout);
      RegExp rePname = RegExp(r"\[REQUESTED OUTPUT\] (.*)");
      var matches = rePname.allMatches(pr.stdout).toList();
      var ytpl = YoutubePlaylist(name: playlistName!, itemCount: ic!);
      String playlistFileContent = '[\n';
      for (int i=0; i<matches.length; i++) {
        var match = matches[i];
        playlistFileContent += "\t"+match.group(1)!.replaceAll("\\", "\\\\") + (i<(matches.length-1)?",\n" : "\n");
        var mfdMap = jsonDecode(match.group(1)!.replaceAll("\\", "\\\\"));
        ytpl.musicFileDetails.add(MusicFileDetails(name: mfdMap["title"], path: mfdMap["file"]));
      }
      playlistFileContent += "]";
      var playlistFile = File(dataMusicPath!+"\\$playlistName"+r'\playlistInfo.json');
      await playlistFile.writeAsString(playlistFileContent);
      return ytpl;
  }
}

class MusicPage extends StatefulWidget {
  const MusicPage({super.key});

  @override
  State<MusicPage> createState() => _MusicPageState();
}

class _MusicPageState extends State<MusicPage>
    with AutomaticKeepAliveClientMixin<MusicPage> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    Size availablesize = MediaQuery.of(context).size;
    print(BlocProvider.of<PomradeBloc>(context).state.windows);
    return const Center(
        child: Stack(
      alignment: Alignment.bottomCenter,
      children: [PlayListBrowser(), MusicPlayer()],
    ));
  }

  @override
  bool get wantKeepAlive => true;
}

class PlaylistCard extends StatelessWidget {
  final String title;
  final int items;
  final bool youtube;
  YoutubePlaylist? youtubePlaylist;
  PlaylistCard(
      {super.key,
      required this.title,
      required this.items,
      this.youtube = true});
  PlaylistCard.youtube(
      {super.key, required YoutubePlaylist this.youtubePlaylist})
      : title = youtubePlaylist.name,
        items = youtubePlaylist.itemCount,
        youtube = true;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: (youtube ? Colors.red[700] : Colors.green[700])!.withAlpha(30),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: const Icon(Icons.album),
            title: Text(title),
            subtitle: Text('$items Songs'),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: youtube ? Colors.red : Colors.green,
                    foregroundColor: Colors.black),
                child: Text(youtube ? 'Play Here' : 'Play in Browser'),
                onPressed: () {
                  if(youtube) {
                    var mstate = BlocProvider.of<MusicplayerBloc>(context).state;
                    BlocProvider.of<MusicplayerBloc>(context).state.musicFileDetails = youtubePlaylist!.musicFileDetails;
                    mstate.playlistName = youtubePlaylist!.name;
                    mstate.currentMusic = 0;
                    BlocProvider.of<MusicplayerBloc>(context).add(StartPlaying());
                  }
                },
              ),
              const SizedBox(width: 8),
              if (youtube)
                TextButton(
                  style: TextButton.styleFrom(foregroundColor: Colors.white),
                  child: const Text('Play in Browser'),
                  onPressed: () {},
                ),
              const SizedBox(width: 8),
            ],
          ),
          const SizedBox(height: 8)
        ],
      ),
    );
  }
}

enum PlaylistAddStatus { initial, loading, added, invalid }

class PlayListBrowser extends StatefulWidget {
  const PlayListBrowser({super.key});

  @override
  State<PlayListBrowser> createState() => _PlayListBrowserState();
}

class _PlayListBrowserState extends State<PlayListBrowser> {
  List<YoutubePlaylist> playlists = [];

  Future<void> openAddPlaylistDialog(BuildContext context) async {
    TextEditingController playlisturl = TextEditingController();
    PlaylistAddStatus status = PlaylistAddStatus.initial;
    await showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          children: [
            StatefulBuilder(
              builder: (context, setState) {
                return ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          " Add a playlist",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextField(
                          controller: playlisturl,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              label: Text("Youtube/Spotify Playlist URL")),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        if (status == PlaylistAddStatus.initial)
                          ElevatedButton(
                              onPressed: () async {
                                setState(
                                  () {
                                    status = PlaylistAddStatus.loading;
                                  },
                                );
                                String? name;
                                int? ic;
                                (name, ic) = await YoutubeDl.getPlaylistNameItemCount(playlisturl.text);
                                YoutubePlaylist? youtubePlaylist = await YoutubeDl.downloadPlaylist(playlisturl.text);
                                setState(() {
                                  if (youtubePlaylist != null) {
                                    playlists.add(youtubePlaylist);
                                  }
                                });
                                if (context.mounted) {
                                  Navigator.pop(context);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.black,
                                  backgroundColor: Colors.deepPurple[300]),
                              child: const Text("Add"))
                        else if (status == PlaylistAddStatus.loading)
                          const Row(
                            children: [
                              SizedBox(
                                width: 8,
                              ),
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(),
                              ),
                              Text("  Extracting Playlist")
                            ],
                          )
                      ],
                    ),
                  ),
                );
              },
            )
          ],
        );
      },
    );
    return;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    playlists = BlocProvider.of<PomradeBloc>(context).state.playlists;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
            child: Row(
              children: [
                const Text(
                  "Your Playlists",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.add),
                          Text("Add Playlist"),
                        ],
                      ),
                      onPressed: () async {
                        await openAddPlaylistDialog(context);
                        setState(() {});
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 110, left: 20, right: 20),
              itemCount: playlists.length,
              itemBuilder: (context, index) {
                var e = playlists[index];
                return PlaylistCard.youtube(
                  youtubePlaylist: e,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class MusicPlayer extends StatefulWidget {
  const MusicPlayer({super.key});

  @override
  State<MusicPlayer> createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer>
    with AutomaticKeepAliveClientMixin<MusicPlayer> {
  late bool open;
  late bool showItems;
  Duration? musicDuration;
  Duration? playPosition;
  YoutubePlaylist? playlist;

  @override
  void initState() {
    super.initState();
    print("initstate called");
    open = false;
    showItems = false;
    MusicplayerState.player.onDurationChanged.forEach((element) {
      setState(() {
        musicDuration = element;
      });
    });
    MusicplayerState.player.onPositionChanged.forEach((element) {
      print("pos duration changed");
      setState(() {
        playPosition = element;
      });
    });
    MusicplayerState.player.onPlayerComplete.forEach((element) {
      BlocProvider.of<MusicplayerBloc>(context).add(PlayNext());
    });
    // Timer ticker = Timer.periodic(Duration(seconds: 1), (timer) {
    //   setState(() {
        
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var screensize =  MediaQuery.of(context).size;
    print("open $open");
    return BlocBuilder<MusicplayerBloc, MusicplayerState>(
      buildWhen: (previous, current) {
        return true;
      },
      builder: (context, state) {
        print("build called");
        return AnimatedFractionallySizedBox(
          duration: const Duration(milliseconds: 200),
          onEnd: () {
            setState(() {
              showItems = open;
            });
          },
          heightFactor: open ? 1 : 0.15,
          child: Container(
            color: const Color.fromARGB(255, 55, 42, 73),
            child: Column(
              children: [
                if (showItems) ...[
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(10),
                      color: const Color.fromARGB(255, 55, 42, 73),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(state.playlistName, style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
                          Text(state.musicFileDetails.length.toString()+" Items"),
                          Expanded(
                            child: ListView.builder(
                              itemCount: state.musicFileDetails.length,
                              itemBuilder: (context, index) {
                                return Material(
                                  type: MaterialType.transparency,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: ListTile(
                                      leading: state.currentMusic == index ? Icon(Icons.play_arrow) :null,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                      title: Text(
                                        state.musicFileDetails[index].name,
                                        style: TextStyle(
                                          fontWeight: state.currentMusic == index ? FontWeight.bold : null,
                                          
                                        ),
                                        maxLines: 1,
                                        softWrap: false,
                                        overflow: TextOverflow.fade,
                                      ),
                                      enabled: true,
                                      tileColor: Colors.black12.withAlpha(20),
                                      onTap: () {
                                        BlocProvider.of<MusicplayerBloc>(context).add(SkipTo(index));
                                      },
                                                          ),
                                  ),
                                );
                            },),
                          ),
                        ],
                      )
                    ),
                  ),
                  const Divider(),
                ],
                Container(
                  height: screensize.height*0.15,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                          onPressed: () {
                            setState(() {
                              open = !open;
                              showItems = open ? !showItems : showItems;
                            });
                          },
                          icon: Icon(open
                              ? Icons.keyboard_arrow_down
                              : Icons.keyboard_arrow_up)),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left:20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(state.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18), maxLines: 1, overflow: TextOverflow.fade,),
                              Text(state.playlistName, style: TextStyle(fontSize: 12),),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: screensize.width*0.4,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    BlocProvider.of<MusicplayerBloc>(context).add(PlayPrevious());
                                  },
                                  icon: Icon(Icons.skip_previous_sharp, size: screensize.height*0.05,)
                                ),
                                IconButton(
                                  onPressed: () {
                                    print("playbutton pressed");
                                    if(state.playing) { 
                                      BlocProvider.of<MusicplayerBloc>(context).add(PausePlaying());
                                    }
                                    else if (MusicplayerState.player.state == PlayerState.paused) {
                                      BlocProvider.of<MusicplayerBloc>(context).add(ResumePlaying());
                                    }
                                    else {
                                      var audiospath =
                                          "${BlocProvider.of<PomradeBloc>(context).state.dataLocation!}\\music\\";
                                      state.playlistName = "Testing";
                                      state.musicFileDetails.add(MusicFileDetails(name: "Ashk - Yo Yo Honey Singh", path: audiospath+"output.mp3"));
                                      state.musicFileDetails.add(MusicFileDetails(name: "FE!N Drill remix"*5, path: audiospath+r"output2.mp3"));
                                      BlocProvider.of<MusicplayerBloc>(context).add(
                                        StartPlaying()
                                      );
                                    }
                                  },
                                  icon: Icon(state.playing?Icons.pause_circle_outline: Icons.play_circle_fill_outlined, size: screensize.height*0.05,)
                                ),
                                IconButton(
                                  onPressed: () {
                                    BlocProvider.of<MusicplayerBloc>(context).add(PlayNext());
                                    // MusicplayerState.player.play(source);
                                  },
                                  icon: Icon(Icons.skip_next_sharp, size: screensize.height*0.05,)
                                ),
                              ],
                            ),
                            if(musicDuration!=null) Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(Utilities.formatDuration(playPosition!)),
                                Flexible(
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(maxWidth: 600),
                                    child: Slider(
                                      value: playPosition!.inSeconds/musicDuration!.inSeconds,
                                      onChanged: (value) {
                                        MusicplayerState.player.seek(Duration(seconds:(musicDuration!*value).inSeconds));
                                      },
                                    ),
                                  ),
                                ),
                                Text(Utilities.formatDuration(musicDuration!)),
                                SizedBox(width: 10,)
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pomrade/bloc/musicplayer_bloc.dart';
import 'package:pomrade/bloc/pomrade_bloc.dart';

class YoutubePlaylist {
  String name;
  int itemCount;

  YoutubePlaylist({required this.name, required this.itemCount});
}

class MusicFileDetails {
  String path;
  String name;
  MusicFileDetails({required this.name, required this.path});
}

class YoutubeDl {
  static String? ytdlpPath;

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
                onPressed: () {/* ... */},
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
  List<YoutubePlaylist> playlists = [
    YoutubePlaylist(
      name: "Songs Diary",
      itemCount: 57,
    )
  ];

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
                                (name, ic) =
                                    await YoutubeDl.getPlaylistNameItemCount(
                                        playlisturl.text);
                                setState(() {
                                  if (name != null && ic != null) {
                                    playlists.add(YoutubePlaylist(
                                        name: name, itemCount: ic));
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
              padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
              itemCount: playlists.length,
              itemBuilder: (context, index) {
                var e = playlists[index];
                return PlaylistCard(
                  items: e.itemCount,
                  title: e.name,
                  youtube: true,
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

  @override
  void initState() {
    super.initState();
    print("initstate called");
    open = false;
    showItems = false;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
          heightFactor: open ? 1 : 0.12,
          child: Container(
            color: const Color.fromARGB(255, 55, 42, 73),
            child: Column(
              children: [
                if (showItems) ...[
                  Expanded(
                    child: Container(
                      color: const Color.fromARGB(255, 55, 42, 73),
                    ),
                  ),
                  const Divider(),
                ],
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                          onPressed: () {
                            setState(() {
                              open = !open;
                              showItems = open ? !showItems : showItems;
                            });
                          },
                          icon: Icon(open
                              ? Icons.keyboard_arrow_down
                              : Icons.keyboard_arrow_up)),
                    ),
                    Column(
                      children: [
                        FittedBox(
                          child: Text(state.name),
                        ),
                        FittedBox(
                          child: IconButton(
                              onPressed: () {
                                print("playbutton pressed");
                                if(state.playing) { 
                                  BlocProvider.of<MusicplayerBloc>(context).add(PausePlaying());
                                }
                                else if (MusicplayerState.player.state == PlayerState.paused) {
                                  BlocProvider.of<MusicplayerBloc>(context).add(ResumePlaying());
                                }
                                else {
                                  var audiopath =
                                      "${BlocProvider.of<PomradeBloc>(context).state.dataLocation!}\\music\\output.mp3";
                                  BlocProvider.of<MusicplayerBloc>(context).add(
                                    StartPlaying( musicFileDetails: MusicFileDetails(name: "Ashk yo yo honey singh", path: audiopath))
                                  );
                                }
                              },
                              icon: Icon(state.playing?Icons.pause_circle_outline: Icons.play_circle_fill_outlined)),
                        ),
                      ],
                    )
                  ],
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

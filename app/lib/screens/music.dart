import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pomrade/bloc/pomrade_bloc.dart';

class YoutubePlaylist {
  String name;
  int itemCount;

  YoutubePlaylist({required this.name, required this.itemCount});
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
      int? itemCount = int.tryParse(match?.group(1)??"");
      return (title, itemCount);
      print(title);
      print(pr.stdout);
      print(pr.stderr);
    }
    return (null, null);
  }
  
}



class MusicPage extends StatefulWidget {
  const MusicPage({super.key});

  @override
  State<MusicPage> createState() => _MusicPageState();
}

class _MusicPageState extends State<MusicPage> {
  final formkey = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  TextEditingController uname = TextEditingController();
  TextEditingController pass = TextEditingController();
  TextEditingController cpass = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    
  }
  @override
  Widget build(BuildContext context) {
    Size availablesize = MediaQuery.of(context).size;
    print(BlocProvider.of<PomradeBloc>(context).state.windows);
    return Scaffold(
      body: Center(
        child: Row(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: Column(
                    // scrollDirection: Axis.vertical,
                    children: [
                      Image.asset("assets/pomrade.png", width: 200,),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Form(
                          key: formkey,
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 450),
                            child: Column(
                              children: [
                                FittedBox(child: Text(BlocProvider.of<PomradeBloc>(context).state.scriptsLocation!, style: TextStyle(fontSize: 20, color: Colors.deepPurple[200]))),
                                TextFormField(
                                  controller: uname,
                                  decoration: InputDecoration(
                                    label: const Text("Output"),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(200)),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 20)  
                                  ),
                                  
                                ),
                                TextFormField(
                                  controller: name,
                                  decoration: InputDecoration(
                                    label: const Text("Insert Link / Error"),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(200)),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 20)
                                  ),
                                  
                                ),
                                TextFormField(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Password must have atleast 6 characters";
                                    }
                                    return null;
                                  },
                                  controller: pass,
                                  decoration: InputDecoration(
                                    label: const Text("Create Password"),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(200)),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 20)  
                                  ),
                                  obscureText: true,
                                  
                                ),
                                TextFormField(
                                  validator: (value) {
                                    if (value != null && value != pass.text) {
                                      return "Passwords don't match";
                                    }
                                    return null;
                                  },
                                  controller: cpass,
                                  decoration: InputDecoration(
                                    label: const Text("Confirm Password"),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(200)),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 20)  
                                  ),
                                  obscureText: true,
                                  
                                ),
                                FittedBox(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      formkey.currentState!.validate();
                                    },
                                    style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple[500], foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 20)), 
                                    child: const Text("SIGN UP", style: TextStyle(fontSize: null),), 
                                  ),
                                )
                              ].map((e) => Padding(padding: const EdgeInsets.only(top: 20, left: 10, right: 10), child: e,)).toList(),
                            ),
                          )
                        ),
                      ),
                      TextButton(onPressed: () async {
                        // ProcessResult dr = await Process.run("dir", [], runInShell: true);
                        // uname.text = dr.stdout;
                        String scriptsloc = BlocProvider.of<PomradeBloc>(context).state.scriptsLocation!;
                        ProcessResult pr = await Process.run(scriptsloc+"\\yt-dlp.exe", [name.text, "-s", "--get-title",]); //"--get-url"
                        print(pr.stdout);
                        print(pr.stderr);
                        uname.text = pr.stdout;
                        name.text = pr.stderr;
                      }, child: const Text("Use Pomrade locally", style: TextStyle(color: Colors.white, fontSize: 12),))
                    ],
                  ),
                ),
              ),
            ),
          ],
        )
      ),
    );
  }
}


class PlaylistWidget extends StatelessWidget {
  final String title;
  final int items;
  final bool youtube;
  const PlaylistWidget({super.key, required this.title, required this.items, this.youtube = true});



  @override
  Widget build(BuildContext context) {
    return Card(
      color: (youtube? Colors.red[700] : Colors.green[700] )!.withAlpha(30),
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
                style: ElevatedButton.styleFrom(backgroundColor: youtube? Colors.red:Colors.green, foregroundColor: Colors.black),
                child: Text(youtube? 'Play Here': 'Play in Browser'),
                onPressed: () {/* ... */},
              ),
              const SizedBox(width: 8),
              if(youtube) TextButton(
                style: TextButton.styleFrom(foregroundColor: Colors.white),
                child: const Text('Play in Browser'),
                onPressed: () {
                  
                },
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

enum PlaylistAddStatus {initial, loading, added, invalid}

class PlayListBrowser extends StatefulWidget {
  const PlayListBrowser({super.key});

  @override
  State<PlayListBrowser> createState() => _PlayListBrowserState();
}

class _PlayListBrowserState extends State<PlayListBrowser> {
  List<YoutubePlaylist> playlists = [
    YoutubePlaylist(name: "Songs Diary", itemCount: 57,)
  ];


  Future<void> openAddPlaylistDialog(BuildContext context) async {
    TextEditingController playlisturl = TextEditingController();
    PlaylistAddStatus status = PlaylistAddStatus.initial;
    await showDialog(
      context: context, 
      builder: (context) {
        return SimpleDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          children: [
            StatefulBuilder(
              builder: (context, setState) {
                return ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 400),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(" Add a playlist", style: TextStyle(fontWeight:FontWeight.bold),),
                        SizedBox(height: 10,),
                        TextField(
                          controller: playlisturl,
                          
                          decoration: InputDecoration(
                            
                            border: OutlineInputBorder(),
                            label: Text("Youtube/Spotify Playlist URL")
                          ),
                        ),
                        SizedBox(height: 10,),
                        if(status == PlaylistAddStatus.initial) ElevatedButton(
                          onPressed:  () async {
                            setState(() {
                              status = PlaylistAddStatus.loading;
                            },);
                            String? name; 
                            int? ic;
                            (name, ic) = await YoutubeDl.getPlaylistNameItemCount(playlisturl.text);
                            setState(() {
                              if (name!=null && ic!=null){
                              playlists.add(YoutubePlaylist(name: name, itemCount: ic));
                            }
                            });
                            if(context.mounted) {
                              Navigator.pop(context);
                            }
                          }, 
                          style: ElevatedButton.styleFrom(foregroundColor: Colors.black, backgroundColor: Colors.deepPurple[300]),
                          child: Text("Add")
                        )
                        else if (status == PlaylistAddStatus.loading) const Row(
                          children: [
                            SizedBox(width: 8,),
                            SizedBox(width: 20, height: 20, child: CircularProgressIndicator(),),
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
                const Text("Your Playlists", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor:Colors.white, foregroundColor: Colors.black),
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
                return PlaylistWidget(items: e.itemCount, title: e.name, youtube: true,);
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

class _MusicPlayerState extends State<MusicPlayer> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

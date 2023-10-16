import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pomrade/bloc/pomrade_bloc.dart';
import 'package:pomrade/models.dart';
import 'package:pomrade/screens/home.dart';
import 'package:pomrade/screens/login.dart';
import 'package:pomrade/screens/music.dart';
import 'package:pomrade/screens/register.dart';

class InitialLoadingPage extends StatelessWidget {
  const InitialLoadingPage({super.key});
  Future<void> loadDataAndNavigate(BuildContext context) async {
    await Future.delayed(Duration(seconds: 1));
    if (context.mounted) {
      if (Platform.isWindows) {
        var state = BlocProvider.of<PomradeBloc>(context).state;
        state.windows = true;
        String appExePath = Platform.resolvedExecutable;
        String appExeLoc = appExePath.substring(0, appExePath.lastIndexOf("\\"));
        // ignore: prefer_interpolation_to_compose_strings
        state.scriptsLocation = appExeLoc + "\\data\\flutter_assets\\assets\\scripts";
        // if (kDebugMode || appExeLoc.contains(r"build\windows\runner\Debug\data")) {state.scriptsLocation = "assets/scripts";}
        
        state.dataLocation = appExeLoc + "\\data\\userdata";
        if (! await Directory(state.dataLocation!).exists()) {
          // TODO: GO TO LOGIN PAGE
          Directory(state.dataLocation!).create();
        }
        YoutubeDl.ytdlpPath = "${state.scriptsLocation}\\yt-dlp.exe";
        YoutubeDl.dataMusicPath = state.dataLocation! + "\\music"; 
        // state.tasks.add(Task(id: 0, name: "Create Tasks page"*5, created: DateTime.now(), description: "Complete this task page by today ", tags: ["flutter", "dart", "bloc", "dart", "bloc", "dart", "bloc", "dart", "bloc", "dart", "bloc", "dart", "bloc", "dart", "bloc"]));
        // state.tasks.add(Task(id: 1, name: "Creating", created: DateTime.now(), tags: ["flutter", "dart"]));
        // print(state.tasks[0].toJson());
        // LOAD PLAYLISTS
        var musicDir = Directory(YoutubeDl.dataMusicPath!);
        if (!musicDir.existsSync()) {
          musicDir.create();
        }
        for (var sub in musicDir.listSync()) {
          if (sub is Directory) {
            var infoFile = File(sub.path+r'\playlistInfo.json');
            print(infoFile.path);
            if (await infoFile.exists()) {
              List songslist = jsonDecode(await infoFile.readAsString());
              var ytpl = YoutubePlaylist(
                name: sub.path.split(r'\').last,
                itemCount: songslist.length
              );
              for (Map mfdMap in songslist) {
                ytpl.musicFileDetails.add(MusicFileDetails(name: mfdMap["title"], path: mfdMap["file"]));
              }
              state.playlists.add(ytpl);
            }
            else {
              continue;
            }
          }
        }
        String tasksjson = "";
        File tfile = File(state.dataLocation!+"\\tasks.json");
        File settingsFile = File(state.dataLocation!+"\\settings.json");
        if (!await settingsFile.exists()) {
          await settingsFile.create();
          await settingsFile.writeAsString(SettingsManager.defaulSettings);
        }
        SettingsManager.settingsFile = settingsFile;
        try {
          tasksjson = await tfile.readAsString();
        }
        catch (exc) {
          tasksjson = """[{
            "id": 0,
            "name": "Hey there! Welcome to Pomrade",
            "description": "Pomrade is a productivity assistant built with a ton of features, You can mark this task as completed to hide it",
            "created": "2023-10-15T22:56:54.186755",
            "tags": ["welcome", "new"],
            "completed": false
          }]""";
          await tfile.create();
          await tfile.writeAsString(tasksjson);
        }
        
        state.tasks = TaskList.fromJson(tasksjson);
        print(jsonDecode(state.tasks.toJson()));
        state.sites.add(Site(domain: "testing.com"));
        state.sites.add(Site(domain: "pom.rade.in"));
      }

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => HomePage(title: "",)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    
    loadDataAndNavigate(context);
    Size availablesize = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Row(
          children: [
            
            
            Expanded(
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 600),
                  child: Column(
                    children: [
                      // Image.asset("assets/pomrade.png", width: 200,),
                      FittedBox(child: Text("Welcome to Pomrade", style: TextStyle(fontSize: 40, fontWeight: FontWeight.w600, color: Colors.deepPurple[200]))),
                      CircularProgressIndicator(),
                      Text("Please wait while we load your data", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white), textAlign: TextAlign.center,)
                    ],
                  ),
                ),
              ),
            ),
            if (availablesize.width > 800) ...[Hero(tag: 'abstract', child: Image.asset("assets/abstractbg.jpg")),],
          ],
        )
      ),
    );
  }
}
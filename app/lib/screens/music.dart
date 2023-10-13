import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pomrade/bloc/pomrade_bloc.dart';

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
                  constraints: BoxConstraints(maxWidth: 600),
                  child: Column(
                    // scrollDirection: Axis.vertical,
                    children: [
                      Image.asset("assets/pomrade.png", width: 200,),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Form(
                          key: formkey,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: 450),
                            child: Column(
                              children: [
                                FittedBox(child: Text(BlocProvider.of<PomradeBloc>(context).state.scriptsLocation!, style: TextStyle(fontSize: 20, color: Colors.deepPurple[200]))),
                                TextFormField(
                                  controller: uname,
                                  decoration: InputDecoration(
                                    label: Text("Output"),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(200)),
                                    contentPadding: EdgeInsets.symmetric(horizontal: 20)  
                                  ),
                                  
                                ),
                                TextFormField(
                                  controller: name,
                                  decoration: InputDecoration(
                                    label: Text("Insert Link / Error"),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(200)),
                                    contentPadding: EdgeInsets.symmetric(horizontal: 20)
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
                                    label: Text("Create Password"),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(200)),
                                    contentPadding: EdgeInsets.symmetric(horizontal: 20)  
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
                                    label: Text("Confirm Password"),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(200)),
                                    contentPadding: EdgeInsets.symmetric(horizontal: 20)  
                                  ),
                                  obscureText: true,
                                  
                                ),
                                FittedBox(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      formkey.currentState!.validate();
                                    }, 
                                    child: Text("SIGN UP", style: TextStyle(fontSize: null),),
                                    style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple[500], foregroundColor: Colors.white, padding: EdgeInsets.symmetric(horizontal: 100, vertical: 20)), 
                                  ),
                                )
                              ].map((e) => Padding(padding: EdgeInsets.only(top: 20, left: 10, right: 10), child: e,)).toList(),
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
                      }, child: Text("Use Pomrade locally", style: TextStyle(color: Colors.white, fontSize: 12),))
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

class PlayListBrowser extends StatefulWidget {
  const PlayListBrowser({super.key});

  @override
  State<PlayListBrowser> createState() => _PlayListBrowserState();
}

class _PlayListBrowserState extends State<PlayListBrowser> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
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

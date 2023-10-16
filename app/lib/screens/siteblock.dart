import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pomrade/bloc/pomrade_bloc.dart';
import 'package:pomrade/models.dart';

class SiteBlockPage extends StatefulWidget {
  const SiteBlockPage({super.key});

  @override
  State<SiteBlockPage> createState() => _SiteBlockPageState();
}

class _SiteBlockPageState extends State<SiteBlockPage> {
  bool block = false;
  Future<void> openAddSiteDialog(BuildContext context) async {
    TextEditingController siteurl = TextEditingController();
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
                          " Add a site to block",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextField(
                          controller: siteurl,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              label: Text("Domain/URL")),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ElevatedButton(
                            onPressed: () async {
                              var g = Site.getDomain(siteurl.text);
                              if (g!=null) {
                                BlocProvider.of<PomradeBloc>(context).state.sites.add(Site(domain: g));
                                Navigator.pop(context);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.black,
                                backgroundColor: Colors.deepPurple[300]),
                            child: const Text("Add"))
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
    PomradeBloc bloc = BlocProvider.of<PomradeBloc>(context);
    List<Site> sites = bloc.state.sites;
    block = bloc.state.blockSites;
    return BlocBuilder<PomradeBloc, PomradeState>(
      builder: (context, state) {
        return Center(
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                child: Row(
                  children: [
                    const Text(
                      "Block Sites ",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    Switch(
                      value: block,
                      onChanged: (value) async => setState(() {
                          var hf = File("C:\\Windows\\System32\\drivers\\etc\\hosts");
                          var contents = hf.readAsStringSync();
                          print(contents);
                          try {
                            if (value) {
                              var sitesstring = bloc.state.sites.map((e) => "127.0.0.1 ${e.domain}").join("\n");
                              print(sitesstring);
                              hf.writeAsStringSync(contents+"\n#STARTPOMRADE\n"+sitesstring+"\n#ENDPOMRADE\n");
                              bloc.state.blockSites = !bloc.state.blockSites;
                            }
                            else {
                              var startIndex = contents.indexOf("#STARTPOMRADE");
                              if (startIndex >= 0){
                                var endIndex = contents.lastIndexOf("#ENDPOMRADE") + 11;
                                contents = contents.substring(0, startIndex) + contents.substring(endIndex);
                                hf.writeAsString(contents);
                              }
                              bloc.state.blockSites = false;
                            }
                          }
                          catch (e) {
                            print(e);
                            showDialog(context: context, builder: (context) {
                              return AlertDialog(
                                icon: Icon(Icons.warning),
                                title: Text("Could not access hosts file"),
                                content: Text("Try restarting the app as administrator"),
                              );
                            },);
                          }
                          // bloc.add(ToggleSiteblockEvent());
                      }),
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
                              Text("Add Site"),
                            ],
                          ),
                          onPressed: () async {
                            await openAddSiteDialog(context);
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
                  padding:
                      const EdgeInsets.only(bottom: 20, left: 20, right: 20),
                  itemCount: sites.length,
                  itemBuilder: (context, index) {
                    var e = sites[index];
                    return Container(
                      margin: EdgeInsets.only(top: 15),
                      padding: EdgeInsets.only(left: 15),
                      decoration: BoxDecoration(
                          color: Colors.deepPurple[300]!.withAlpha(30),
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        children: [
                          Expanded(child: Text(e.domain)),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              sites.remove(e);
                              setState(() {
                                
                              });
                            },
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pomrade/bloc/pomrade_bloc.dart';
import 'package:pomrade/screens/music.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final formkey = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  TextEditingController uname = TextEditingController();
  TextEditingController pass = TextEditingController();
  TextEditingController cpass = TextEditingController();
  String? nameerrtext;

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
                      // FittedBox(
                      //   fit: BoxFit.scaleDown, // fixes fittedbox not working in listview
                      //   child: Padding(
                      //   padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                      //   child: Text("Pomrade", style: TextStyle(fontSize: 130, fontWeight: FontWeight.bold),),
                      // )),
                      
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Form(
                          key: formkey,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: 450),
                            child: Column(
                              children: [
                                FittedBox(child: Text("Create your Pomrade account", style: TextStyle(fontSize: 40, fontWeight: FontWeight.w600, color: Colors.deepPurple[200]))),
                                TextFormField(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Please enter a name we can call you";
                                    }
                                    return null;
                                  },
                                  controller: name,
                                  decoration: InputDecoration(
                                    label: Text("Enter your name"),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(200)),
                                    contentPadding: EdgeInsets.symmetric(horizontal: 20),
                                    errorText: nameerrtext
                                  ),
                                  
                                ),
                                TextFormField(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Please enter a valid username";
                                    }
                                    else {
                                      if (value.contains(' ')) {
                                        return "Username cannot contain spaces";
                                      }
                                    }
                                    return null;
                                  },
                                  controller: uname,
                                  decoration: InputDecoration(
                                    label: Text("Create Username"),
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
                        if(name.text.isEmpty) {
                          setState(() {
                            nameerrtext = "Please enter a name we can call you";
                          });
                        }
                        else {
                          if(context.mounted) {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => MusicPage(),));
                          }
                        }
                      }, child: Text("Use Pomrade locally", style: TextStyle(color: Colors.white, fontSize: 12),))
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
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pomrade/bloc/pomrade_bloc.dart';
import 'package:pomrade/screens/login.dart';
import 'package:pomrade/screens/register.dart';

class InitialLoadingPage extends StatelessWidget {
  const InitialLoadingPage({super.key});
  Future<void> loadDataAndNavigate(BuildContext context) async {
    await Future.delayed(Duration(seconds: 6));
    if (context.mounted) {
      BlocProvider.of<PomradeBloc>(context).state.windows = Platform.isWindows;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    
    loadDataAndNavigate(context);
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
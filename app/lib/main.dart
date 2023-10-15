import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pomrade/bloc/musicplayer_bloc.dart';
import 'package:pomrade/bloc/pomrade_bloc.dart';
import 'package:pomrade/screens/initial.dart';

// SCREENS
import 'screens/login.dart';
import 'screens/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PomradeBloc>(
          create: (context) => PomradeBloc(),
        ),
        BlocProvider(
          create: (context) => MusicplayerBloc(),
        ),
      ],
      child: MaterialApp(
        title: 'Pomrade: Productivity',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepPurple, brightness: Brightness.dark),
          useMaterial3: true,
        ),
        home: const InitialLoadingPage(),
      ),
    );
  }
}

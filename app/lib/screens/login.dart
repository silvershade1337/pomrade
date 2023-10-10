import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pomrade/bloc/pomrade_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    Size availablesize = MediaQuery.of(context).size;
    print(BlocProvider.of<PomradeBloc>(context).state.windows);
    return Scaffold(
      body: Center(
        child: Row(
          children: [
            if (availablesize.width > 800) ...[Image.asset("assets/abstractbg.jpg"),],
            
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
                          child: ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: 450),
                            child: Column(
                              children: [
                                FittedBox(child: Text("Sign into Pomrade", style: TextStyle(fontSize: 40, fontWeight: FontWeight.w600, color: Colors.deepPurple[200]))),
                                TextField(
                                  decoration: InputDecoration(
                                    label: Text("Username"),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(200)),
                                    contentPadding: EdgeInsets.symmetric(horizontal: 20)  
                                  ),
                                  
                                ),
                                TextField(
                                  decoration: InputDecoration(
                                    label: Text("Password"),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(200)),
                                    contentPadding: EdgeInsets.symmetric(horizontal: 20)  
                                  ),
                                  obscureText: true,
                                  
                                ),
                                FittedBox(
                                  child: ElevatedButton(
                                    onPressed: () {
                                    
                                    }, 
                                    child: Text("SIGN IN"),
                                    style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple[200], foregroundColor: Colors.white, padding: EdgeInsets.symmetric(horizontal: 100, vertical: 20)), 
                                  ),
                                )
                              ].map((e) => Padding(padding: EdgeInsets.only(top: 20, left: 10, right: 10), child: e,)).toList(),
                            ),
                          )
                        ),
                      ),
                      TextButton(onPressed: () {
                        
                      }, child: Text("Don't have an account?", style: TextStyle(color: Colors.white),))
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
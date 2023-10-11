import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pomrade/bloc/pomrade_bloc.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
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
                          child: ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: 450),
                            child: Column(
                              children: [
                                FittedBox(child: Text("Create your Pomrade account", style: TextStyle(fontSize: 40, fontWeight: FontWeight.w600, color: Colors.deepPurple[200]))),
                                TextFormField(
                                  decoration: InputDecoration(
                                    label: Text("Create Username"),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(200)),
                                    contentPadding: EdgeInsets.symmetric(horizontal: 20)  
                                  ),
                                  
                                ),
                                TextFormField(
                                  decoration: InputDecoration(
                                    label: Text("Create Password"),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(200)),
                                    contentPadding: EdgeInsets.symmetric(horizontal: 20)  
                                  ),
                                  obscureText: true,
                                  
                                ),
                                TextFormField(
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
                      TextButton(onPressed: () {
                        
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
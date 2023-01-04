import 'package:flutter/material.dart';
import 'LoginScreen.dart';

class SecondScreen extends StatelessWidget {
  final String email;
  final String pass;
  SecondScreen(this.email,this.pass);



  @override
  Widget build(BuildContext context) {

    return MaterialApp(


      home: Scaffold(
        backgroundColor: Colors.black,

        body: Center(

          child: Center(
            child:  Text(
              email+""
                  " "+pass,



              style: TextStyle(fontSize: 38, color: Colors.white),
              textAlign: TextAlign.center,
            ),

          ),

        ),
      ),
    );
  }
}
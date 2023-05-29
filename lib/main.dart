
import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'login/view/LoginScreen.dart';


void main()  async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // Start the timer to update data every 2 days
  Timer.periodic(Duration(days: 2), (timer) {
    // checkAndDeleteDocuments();
  });
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: Colors.white,
          accentColor: Colors.white,
          highlightColor: Colors.white,
          hintColor: Colors.white
      ),
      title: "Login Screen ",
      home: LoginScreen(),

    ),
  );
}

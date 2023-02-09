import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fyp/databaseManager/databaseManager.dart';
import 'package:fyp/homepage/Tabs/friendlyGame.dart';
import 'package:fyp/homepage/UserEventJoined/EventParticipantUser.dart';
import '../UIcomponents/UIcomponents.dart';
import 'SideBar//SideMenuBar.dart';
//import 'package:';
//import 'package:auto_layout/auto_layout.dart';

void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {

  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin{
  late TabController _tabController;

   final List<Tab> myTabs = <Tab>[
     new Tab(text:"a"),
     new Tab(text:"b"),
   ];

  // var dbmanager = DatabaseManager();
  // var loginUserid = "";
  //
  // Future<dynamic> getUserData() async{
  //   var data =  await dbmanager.getData('userBioData');
  //   var daaa = json.decode(data);
  //   setState(() {
  //     print("data ::::::::::::");
  //     print(daaa['id']);
  //     loginUserid = daaa['id'];
  //   });
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //getUserData();
    _tabController = new TabController(vsync: this, length: 2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: SideMenueBar(),
        appBar: AppBar(
          title: const Text("Event List"),
          backgroundColor: Colors.teal[900],
          bottom: TabBar(
            controller: _tabController,
              tabs: [
                Tab(
                    icon: Icon(
                      Icons.add,
                      color: Colors.white,
                    )
                ),
                Tab(
                    icon: Icon(
                      Icons.tour,
                      color: Colors.teal[900],
                    )
                )
              ]),
        ),
        body: TabBarView(
            controller: _tabController,
            children: [
              FriendlyGame(),
              FriendlyGame()
            ]
        ),
    );
  }
}


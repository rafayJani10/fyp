import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fyp/databaseManager/databaseManager.dart';
import 'package:fyp/homepage/Tabs/friendlyGame.dart';
import 'package:fyp/homepage/UserEventJoined/EventParticipantUser.dart';
import '../UIcomponents/UIcomponents.dart';
import 'AdimTournamentView/AdminTournamentView.dart';
import 'AdminSideMenuBar.dart';
import 'AdminEventListTabs/AdminfriendlyEvents.dart';
//import 'SideBar//SideMenuBar.dart';
//import 'package:';
//import 'package:auto_layout/auto_layout.dart';


class AdminMyApp extends StatelessWidget {

  const AdminMyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: const MyAdminHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyAdminHomePage extends StatefulWidget {
  const MyAdminHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyAdminHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyAdminHomePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<Tab> myTabs =  <Tab>[
    new Tab(text: 'a'),
    new Tab(text: 'b'),
  ];

  // var dbmanager = DatabaseManager();
  // var loginUserid = "";

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
    _tabController = new TabController(length: 2, vsync: this);
    //getUserData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: AdminSideMenueBar(),
        appBar: AppBar(
          title: const Text("Event List"),
          backgroundColor: Colors.teal[900],
          bottom: TabBar(
            controller: _tabController,
            tabs: [
              Tab(
                child: Text('Frinedly Games',
                  style: TextStyle(
                      color: Colors.white
                  ),
                ),
              ),
              Tab(
                child: Text('Tournament',

                  style: TextStyle(
                      color: Colors.white
                  ),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [

            AdminFriendlyGame(),
            adminTournametViewe(),


          ],
        )
    );
  }
}


// import 'dart:convert';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fyp/MyEventList/tabs/myFriendlygames.dart';
import 'package:fyp/MyEventList/tabs/myTournaments.dart';
// import 'package:fyp/databaseManager/databaseManager.dart';
// import 'package:fyp/homepage/Tabs/friendlyGame.dart';
// import 'package:fyp/homepage/Tabs/tournamentEvent.dart';
// import 'package:fyp/homepage/UserEventJoined/EventParticipantUser.dart';
// import '../CreateEvents/tab/tournamentEvent.dart';
// import '../UIcomponents/UIcomponents.dart';
// //import 'SideBar//SideMenuBar.dart';
// //import 'package:';
// //import 'package:auto_layout/auto_layout.dart';



class AdminMyEventList extends StatefulWidget {
  const AdminMyEventList({super.key,  required this.title});
  final String title;
  @override
  State<AdminMyEventList> createState() => _AdminMyEventList();
}

class _AdminMyEventList extends State<AdminMyEventList> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<Tab> myTabs =  <Tab>[
    new Tab(text: 'a'),
    // new Tab(text: 'b'),
  ];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 1, vsync: this);
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
      //drawer: SideMenueBar(),
        appBar: AppBar(
          title: const Text("My Events"),
          backgroundColor: Colors.teal[900],
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
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
          children: const [
            MytournamentEventList()
          ],
        )
    );
  }
}


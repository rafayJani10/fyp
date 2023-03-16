
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fyp/homepage/Tabs/friendlyGame.dart';
import 'package:fyp/homepage/Tabs/tournamentEvent.dart';
import 'SideBar//SideMenuBar.dart';

void main() {
  Platform.environment['LANG'] = 'en_US.UTF-8';
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

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<Tab> myTabs =  <Tab>[
    new Tab(text: 'a'),
    new Tab(text: 'b'),
  ];

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
        drawer: SideMenueBar(),
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
            FriendlyGame(),
            tournamentEventList()
          ],
        )
    );
  }
}


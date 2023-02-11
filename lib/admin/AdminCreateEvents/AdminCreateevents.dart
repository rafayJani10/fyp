
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fyp/CreateEvents/tab/friendlyEvents.dart';
import 'package:fyp/CreateEvents/tab/tournamentEvent.dart';



class createEvents extends StatefulWidget {
  const createEvents({Key? key}) : super(key: key);

  @override
  State<createEvents> createState() => _createEventsState();
}

class _createEventsState extends State<createEvents> with SingleTickerProviderStateMixin{

  late TabController _tabController;
  final List<Tab> myTabs =  <Tab>[
    new Tab(text: 'a'),
  //  new Tab(text: 'b'),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = new TabController(length: 2, vsync: this);
    //getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:  AppBar(
          title:  Text("Create Event"),
          backgroundColor: Colors.teal[900],
          bottom: TabBar(
            controller: _tabController,
            tabs: [
              // Tab(
              //   child: Text('Frinedly Games',
              //     style: TextStyle(
              //         color: Colors.white
              //     ),
              //   ),
              // ),
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

          //  friendlyEvent(),
            tournamentEvent()


          ],
        )
    );
  }
}

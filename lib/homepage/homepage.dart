import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fyp/databaseManager/databaseManager.dart';
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

class _MyHomePageState extends State<MyHomePage> {

  var dbmanager = DatabaseManager();
  var loginUserid = "";

  Future<dynamic> getUserData() async{
    var data =  await dbmanager.getData('userBioData');
    var daaa = json.decode(data);
    setState(() {
      print("data ::::::::::::");
      print(daaa['id']);
      loginUserid = daaa['id'];
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: SideMenueBar(),
        appBar: AppBar(
          title: const Text("Event List"),
          backgroundColor: Colors.teal[900],
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('events').snapshots(),
          builder: (context, snapshot){
            if(!snapshot.hasData) return const
                 Text('loading ...');
            return ListView.builder(
                itemCount: snapshot.data?.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: (){
                      var tt = snapshot.data?.docs[index]['joinedPerson'];
                      print(tt);
                      Navigator.push(context,
                          MaterialPageRoute(
                              builder: (context) => EventParticipant(tt)
                          )
                      );
                    },
                    child:  Container(
                      margin: EdgeInsets.all(15),
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.6),
                            spreadRadius: 6,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Row(
                        children: <Widget>[
                          Flexible(
                            flex: 3,
                            child: SizedBox(
                              height: 130,
                              child: Center(
                                  child: snapshot.data?.docs[index]['picture'] == "" ?  Image.network("https://t3.ftcdn.net/jpg/02/48/42/64/360_F_248426448_NVKLywWqArG2ADUxDq6QprtIzsF82dMF.jpg",
                                    //height: 150,
                                    fit: BoxFit.fitHeight,
                                  ): Image.network(
                                    snapshot.data?.docs[index]['picture'],
                                    //height: 150,
                                    fit: BoxFit.fitHeight,
                                  )


                              ),
                            ),
                          ),
                          Flexible(
                              flex: 5,
                              child: Column(
                                children: [
                                  Flexible(
                                      flex: 2,
                                      child: Container(
                                        width: double.infinity,
                                        padding: EdgeInsets.only(left: 10, top: 15),
                                        //color: Colors.yellow,
                                        height: 50,
                                        child: Text(snapshot.data?.docs[index]['name'],
                                            style: TextStyle(
                                                color: Colors.grey[800],
                                                fontWeight: FontWeight.bold,
                                                fontSize: 25)),
                                      )),
                                  Flexible(
                                      flex: 2,
                                      child: Container(
                                          width: double.infinity,
                                          height: 50,
                                          padding: EdgeInsets.only(left: 10),
                                          //color: Colors.green,
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.location_on_rounded,
                                                color: Colors.red,
                                                size: 20.0,
                                              ),
                                              Text(snapshot.data?.docs[index]['address'],
                                                  style: TextStyle(
                                                      color: Colors.grey[800],
                                                      fontSize: 18))

                                            ],
                                          )
                                      )),
                                  Flexible(
                                      flex: 3,
                                      child: Container(
                                        //color: Colors.red,
                                        child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10.0, top: 15),
                                            child: Row(
                                              children: [
                                                Container(
                                                  height: 50,
                                                  width: 45,
//color: Colors.green,
                                                  child: Column(
                                                    children:  <Widget>[
                                                      Icon(
                                                        Icons.calendar_month,
                                                        color: Colors.grey,
                                                        size: 30.0,
                                                      ),
                                                      Text(snapshot.data?.docs[index]['date'],
                                                          style: TextStyle(
                                                              fontSize: 9)),
                                                    ],
                                                  ),

                                                ),
                                                Container(
                                                  height: 50,
                                                  width: 45,
//color: Colors.green,
                                                  child: Column(
                                                    children:  <Widget>[
                                                      Icon(
                                                        Icons.timer,
                                                        color: Colors.black,
                                                        size: 30.0,
                                                      ),
                                                      Text(snapshot.data?.docs[index]['time'],
                                                          style: TextStyle(
                                                              fontSize: 9)),
                                                    ],
                                                  ),

                                                ),
                                                Container(
                                                  height: 50,
                                                  width: 45,
//color: Colors.green,
                                                  child: Column(
                                                    children:  <Widget>[
                                                      Icon(
                                                        Icons.person,
                                                        color: Colors.black,
                                                        size: 30.0,
                                                      ),
                                                      Text(snapshot.data?.docs[index]['totalperso'],
                                                          style: TextStyle(
                                                              fontSize: 9)),
                                                    ],
                                                  ),

                                                ),
                                                Container(
                                                  height: 50,
                                                  width: 45,
//color: Colors.green,
                                                  child: Column(
                                                    children:  <Widget>[
                                                      Icon(
                                                        Icons.person_add,
                                                        color: Colors.green,
                                                        size: 30.0,
                                                      ),
                                                      Text((snapshot.data?.docs[index]['TjoinPerson']).toString(),
                                                          style: TextStyle(
                                                              fontSize: 9)),
                                                    ],
                                                  ),

                                                ),
                                              ],
                                            )
                                        ),
                                      ))
                                ],
                              )
                          ),
                          Flexible(
                            flex: 1,
                            child: SizedBox(
                                height: 150,
                                // width: 100,
                                //color: Colors.red,
                                child: InkWell(
                                  child: Container(
                                      height: 150,
                                      color: Colors.teal[900],
                                      child: RotatedBox(
                                          quarterTurns: 1,
                                          child: Center(
                                            child: const Text("Apply",
                                                style: TextStyle(
                                                    letterSpacing: 5,
                                                    color: Colors.white,
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold
                                                )),
                                          )
                                      )
                                  ),
                                  onTap: () {
                                    print("button pressed : $index");
                                    print(snapshot.data?.docs[index].reference.id);
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text("Are You Sure"),
                                          content: Text("are you sure to became the participant of this event ??"),
                                          actions: <Widget>[
                                            ElevatedButton(
                                              child: Text("NO"),
                                              style: ElevatedButton.styleFrom(
                                                  primary: Colors.red[900],
                                                  //padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                                                  textStyle: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight: FontWeight.bold)),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  primary: Colors.teal[900],
                                                  //padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                                                  textStyle: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight: FontWeight.bold)),
                                              child: Text("YES"),
                                              onPressed: () async {
                                                var selectedProjectId = snapshot.data?.docs[index].reference.id;
                                                await FirebaseFirestore.instance.collection("events").doc(selectedProjectId)
                                                    .update({"joinedPerson" : FieldValue.arrayUnion([loginUserid])});
                                                showAlertDialog(context,"Done","You can joined the event successfully");
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                )
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                });
          },
        )
    );
  }
}


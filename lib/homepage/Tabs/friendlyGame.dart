import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../UIcomponents/UIcomponents.dart';
import '../../databaseManager/databaseManager.dart';
import '../UserEventJoined/EventParticipantUser.dart';
import '../friendlyGameDetails/friendlyGameDetails.dart';

class FriendlyGame extends StatefulWidget {
  const FriendlyGame({Key? key}) : super(key: key);

  @override
  State<FriendlyGame> createState() => _FriendlyGameState();
}

class _FriendlyGameState extends State<FriendlyGame> {
  var dbmanager = DatabaseManager();
  var loginUserid = "";

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
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('events').snapshots(),
      builder: (context, snapshot){
        if(!snapshot.hasData) return const
        Text('loading ...');
        return ListView.builder(
            itemCount: snapshot.data?.docs.length,
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                onTap: (){
                  var authorId = snapshot.data?.docs[index]['eventAuthore'];
                  var eventIdd = snapshot.data?.docs[index].reference.id;
                  var teamAJoindeList = snapshot.data?.docs[index]['teamA'];
                  var teamBJoindeList = snapshot.data?.docs[index]['teamB'];
                  print(authorId);
                  print(eventIdd);
                  print(teamAJoindeList);
                  print(teamBJoindeList);
                  Navigator.push(context,
                      MaterialPageRoute(
                          builder: (context) =>  FriendlyEventDetails(AuthoreId: authorId, teamAlist: teamAJoindeList, teamBlist: teamBJoindeList, eventId: eventIdd!,)
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
                              child: snapshot.data?.docs[index]['picture'] == "" ?  Image.network("https://firebasestorage.googleapis.com/v0/b/bukc-sports-hub.appspot.com/o/imgPh.jpeg?alt=media&token=e41c5f50-8ccb-4276-9538-bacf349f24ba",
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
                          flex: 6,
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
                                            fontSize: 20)),
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
                                                  fontSize: 15))

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
                                              width: 25,
//color: Colors.green,
                                              child: Column(
                                                children:  <Widget>[
                                                  Icon(
                                                    Icons.calendar_month,
                                                    color: Colors.grey,
                                                    size: 20.0,
                                                  ),
                                                  Text(snapshot.data?.docs[index]['date'],
                                                      maxLines: 2,
                                                      style: TextStyle(
                                                          fontSize: 9)),
                                                ],
                                              ),

                                            ),
                                            SizedBox(width: 10,),
                                            Container(
                                              height: 50,
                                              width: 25,
//color: Colors.green,
                                              child: Column(
                                                children:  <Widget>[
                                                  Icon(
                                                    Icons.timer,
                                                    color: Colors.black,
                                                    size: 20.0,
                                                  ),
                                                  Text(snapshot.data?.docs[index]['time'],
                                                      style: TextStyle(
                                                          fontSize: 9)),
                                                ],
                                              ),

                                            ),
                                            SizedBox(width: 10,),
                                            Container(
                                              height: 50,
                                              width: 25,
//color: Colors.green,
                                              child: Column(
                                                children:  <Widget>[
                                                  Icon(
                                                    Icons.group,
                                                    color: Colors.black,
                                                    size: 20.0,
                                                  ),
                                                  Text(snapshot.data?.docs[index]['teamsATP'],
                                                      style: TextStyle(
                                                          fontSize: 9)),
                                                ],
                                              ),

                                            ),
                                            SizedBox(width: 10,),
                                            Container(
                                              height: 50,
                                              width: 25,
//color: Colors.green,
                                              child: Column(
                                                children:  <Widget>[
                                                  Icon(
                                                    Icons.person_add,
                                                    color: Colors.green,
                                                    size: 20.0,
                                                  ),
                                                  Text((snapshot.data?.docs[index]['JoindePersonTeamA']).toString(),
                                                      style: TextStyle(
                                                          fontSize: 9)),
                                                ],
                                              ),

                                            ),
                                            SizedBox(width: 10,),
                                            Container(
                                              height: 50,
                                              width: 25,
//color: Colors.green,
                                              child: Column(
                                                children:  <Widget>[
                                                  Icon(
                                                    Icons.group,
                                                    color: Colors.black,
                                                    size: 20.0,
                                                  ),
                                                  Text(snapshot.data?.docs[index]['teambTP'],
                                                      style: TextStyle(
                                                          fontSize: 9)),
                                                ],
                                              ),

                                            ),
                                            SizedBox(width: 10,),
                                            Container(
                                              height: 50,
                                              width: 25,
//color: Colors.green,
                                              child: Column(
                                                children:  <Widget>[
                                                  Icon(
                                                    Icons.person_add,
                                                    color: Colors.green,
                                                    size: 20.0,
                                                  ),
                                                  Text((snapshot.data?.docs[index]['JoindePersonTeamB']).toString(),
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
                      // Flexible(
                      //   flex: 1,
                      //   child: SizedBox(
                      //       height: 150,
                      //       // width: 100,
                      //       //color: Colors.red,
                      //       child: InkWell(
                      //         child: Container(
                      //             height: 150,
                      //             color: Colors.teal[900],
                      //             child: RotatedBox(
                      //                 quarterTurns: 1,
                      //                 child: Center(
                      //                   child: const Text("Apply",
                      //                       style: TextStyle(
                      //                           letterSpacing: 5,
                      //                           color: Colors.white,
                      //                           fontSize: 20,
                      //                           fontWeight: FontWeight.bold
                      //                       )),
                      //                 )
                      //             )
                      //         ),
                      //         onTap: () {
                      //           print("button pressed : $index");
                      //           print(snapshot.data?.docs[index].reference.id);
                      //           showDialog(
                      //             context: context,
                      //             builder: (BuildContext context) {
                      //               return AlertDialog(
                      //                 title: Text("Are You Sure"),
                      //                 content: Text("are you sure to became the participant of this event ??"),
                      //                 actions: <Widget>[
                      //                   ElevatedButton(
                      //                     child: Text("NO"),
                      //                     style: ElevatedButton.styleFrom(
                      //                         primary: Colors.red[900],
                      //                         //padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                      //                         textStyle: TextStyle(
                      //                             fontSize: 15,
                      //                             fontWeight: FontWeight.bold)),
                      //                     onPressed: () {
                      //                       Navigator.of(context).pop();
                      //                     },
                      //                   ),
                      //                   ElevatedButton(
                      //                     style: ElevatedButton.styleFrom(
                      //                         primary: Colors.teal[900],
                      //                         //padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                      //                         textStyle: TextStyle(
                      //                             fontSize: 15,
                      //                             fontWeight: FontWeight.bold)),
                      //                     child: Text("YES"),
                      //                     onPressed: () async {
                      //                       var selectedProjectId = snapshot.data?.docs[index].reference.id;
                      //                       await FirebaseFirestore.instance.collection("events").doc(selectedProjectId)
                      //                           .update({"joinedPerson" : FieldValue.arrayUnion([loginUserid])});
                      //                       Navigator.of(context).pop();
                      //                       showAlertDialog(context,"Done","You can joined the event successfully");
                      //                     },
                      //                   ),
                      //                 ],
                      //               );
                      //             },
                      //           );
                      //         },
                      //       )
                      //   ),
                      // ),
                    ],
                  ),
                ),
              );
            });
      },
    );
  }
}

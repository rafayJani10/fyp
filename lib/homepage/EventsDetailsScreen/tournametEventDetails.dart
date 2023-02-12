import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fyp/CreateEvents/CreateEvents.dart';
import '../../MyEventList/MyEventList.dart';

import 'package:fyp/homepage/homepage.dart';
import 'package:fyp/login/view/LoginScreen.dart';
import 'package:fyp/services/firebase_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../UIcomponents/UIcomponents.dart';
import '../Tabs/TeamATabs/tabTeamA.dart';
import '../Tabs/TeamATabs/tabTeamB.dart';
import '../Tabs/friendlyGame.dart';
import '/ProfilePage/ProfilePage.dart';
import '/databaseManager/databaseManager.dart';

class tournamentEventDetail extends StatefulWidget {
  final String? authoreId;
  final String? eventID;
  final List listJoinedUser ;

  tournamentEventDetail({required this.authoreId,required this.eventID, required this.listJoinedUser});

  @override
  State<tournamentEventDetail> createState() => _tournamentEventDetailState();
}

class _tournamentEventDetailState extends State<tournamentEventDetail> {

  var dbmanager = DatabaseManager();
  var LoginUserId = "";
  var tournamentUserList = [];

  Future getLoginUserData()async{
    var data =  await dbmanager.getData('userBioData');
    var daaa = json.decode(data);
    var userid = daaa['id'];
    setState(() {
      LoginUserId = userid;
    });

  }
  Future getTeamJoinUserLists() async{
    var collection = FirebaseFirestore.instance.collection('TourEvents');
    var docSnapshot = await collection.doc(widget.eventID).get();
    if (docSnapshot.exists) {
      Map<String, dynamic>? data = docSnapshot.data();
      var tourListUser = data?['joinedUserList'];
      setState(()  {
        // print(userData.length);
        var projLength = tourListUser.length;
        print(projLength);
        for (var i = 0; i < projLength; i++) {
          print(i);
          tournamentUserList.add(tourListUser[i]);
          print("sdmasdmgadsjgdasjsad");
          print(tournamentUserList);
          //stream = FirebaseFirestore.instance.collection('events').doc(projectList[i]).snapshots();
        }
      });
    }

  }
  Future joimSelectedEvent() async{
    var data =  await dbmanager.getData('userBioData');
    var daaa = json.decode(data);
    var userid = daaa['id'];

    await FirebaseFirestore.instance.collection("TourEvents").doc(widget.eventID)
        .update(
        {"joinedUserList": FieldValue.arrayUnion([LoginUserId])}
    ).then((value) {
      showAlertDialog(context,"Successfully Join","you successfully join the teams");
      getTeamJoinUserLists();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLoginUserData();
    getTeamJoinUserLists();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //drawer: SideMenueBar(),
      appBar: AppBar(
        title: const Text("Event List"),
        backgroundColor: Colors.teal[900],
      ),
      body: ListView.builder(
          itemCount: tournamentUserList.length,//myProjectId.length,
          itemBuilder: (BuildContext context, int index){
            return StreamBuilder(
              stream: FirebaseFirestore.instance.collection('users').doc(tournamentUserList[index]).snapshots(),
              builder: (context, snapshot){
                if (snapshot.data == null ) {
                  return Center(child: Text('NO DATA'));
                }
                return Center(
                    child: Container(
                      margin: EdgeInsets.all(15),
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.6),
                            spreadRadius: 6, blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Flexible(
                              flex: 1,
                              child: Container(
                                height: 150,
                                color: Colors.teal[900],
                                child: Center(
                                  child: CircleAvatar(
                                    radius: 50,
                                    child: ClipOval(
                                        child: snapshot.data?['picture'] != "" ?Image.network(snapshot.data?['picture'],  fit: BoxFit.fill) :Image.network("https://img.freepik.com/premium-vector/anonymous-user-circle-icon-vector-illustration-flat-style-with-long-shadow_520826-1931.jpg?w=2000",  fit: BoxFit.fill)
                                    ),
                                  ),
                                ),
                              )),
                          Flexible(
                              flex: 2,
                              child: Container(
                                height: 150,
// color: Colors.orange,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(top: 10,left: 10),
                                      child: Text(snapshot.data?['fullname'],
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(top: 10,left: 10),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.email,
                                              size: 20,
                                              color: Colors.grey,
                                            ),
                                            SizedBox(width: 4,),
                                            Text(snapshot.data?['email'],

                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
//fontWeight: FontWeight.bold
                                              ),
                                            ),
                                          ],
                                        )
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(top: 3,left: 10),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.male,
                                              size: 20,
                                              color: Colors.grey,
                                            ),
                                            SizedBox(width: 4,),
                                            Text(snapshot.data?['gender'],

                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
//fontWeight: FontWeight.bold
                                              ),
                                            ),
                                          ],
                                        )
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(top: 3,left: 10),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.phone_android_sharp,
                                              size: 20,
                                              color: Colors.grey,
                                            ),
                                            SizedBox(width: 4,),
                                            Text(snapshot.data?['phoneNumber'],

                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
//fontWeight: FontWeight.bold
                                              ),
                                            ),
                                          ],
                                        )
                                    )
                                  ],
                                ),
                              ))
                        ],
                      ),

                    )
                );
              },
            );
          }
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {

          if(LoginUserId != ""  && !widget.listJoinedUser.contains(LoginUserId)){
            joimSelectedEvent();

          }else{
            showAlertDialog(context,"Error","you already in the tournaments");
          }

        },
        label:  Text('Join Team',
          style: TextStyle(color: Colors.white),),
        icon:  Icon(Icons.add,color: Colors.white,),

        backgroundColor: Colors.teal[900],
      ),

    );
  }
}

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../UIcomponents/UIcomponents.dart';
import '../../../databaseManager/databaseManager.dart';



class TeamBTab extends StatefulWidget {

  final String AuthoreId ;
  final List teamAlist;
  final List teamBlist;
  final String eventId;
  TeamBTab({super.key, required this.AuthoreId,required this.teamAlist,required this.teamBlist,required this.eventId});

  @override
  State<TeamBTab> createState() => _TeamBTabState();
}

class _TeamBTabState extends State<TeamBTab> {

  var dbmanager = DatabaseManager();
  var useriddd = "";
  var pic = "";
  var name = "";
  var email = "";
  var gender = "";
  var phoneNo = "";
  var TeamB_joinUser = [];
  var joinPersoTeamA = 0;
  var joinedUserStatus = false;


  Future getAuthoreData() async{
    var collection = FirebaseFirestore.instance.collection('users');
    //print(widget.AuthoreId);
    var docSnapshot = await collection.doc(widget.AuthoreId).get();
    if (docSnapshot.exists) {
      Map<String, dynamic>? data = docSnapshot.data();

      //print(data?['fullname']);

      setState(()  {
        pic = data?['picture'];
        name = data?['fullname'];
        email = data?['email'];
        gender = data?['gender'];
        phoneNo = data?['phoneNumber'];
      });
    }
  }

  Future getLoginUserData()async{
    var data =  await dbmanager.getData('userBioData');
    var daaa = json.decode(data);
    var userid = daaa['id'];
    setState(() {
      useriddd = userid;
    });

  }

  Future getTeamJoinUserList() async{
    var collection = FirebaseFirestore.instance.collection('events');
    var docSnapshot = await collection.doc(widget.eventId).get();
    if (docSnapshot.exists) {
      Map<String, dynamic>? data = docSnapshot.data();
      var teamAlist = data?['teamB'];
      setState(()  {
        // print(userData.length);
        var projLength = teamAlist.length;
        var joinedUserStatus = data?['JoindePersonTeamA'];
        print(projLength);
        for (var i = 0; i < projLength; i++) {
          print(i);
          if(teamAlist[i] == widget.AuthoreId){
            print("already be a part of team");
            setState(() {
              joinedUserStatus = true;
            });
          }else{
            TeamB_joinUser.add(teamAlist[i]);

          }
          print("sdmasdmgadsjgdasjsad");
          print(TeamB_joinUser);
          //stream = FirebaseFirestore.instance.collection('events').doc(projectList[i]).snapshots();
        }
      });
    }

  }

  Future joindeTeam()async{
    await FirebaseFirestore.instance.collection('events').doc(widget.eventId).update(
        {
          'teamB': FieldValue.arrayUnion([useriddd]),
          'JoindePersonTeamB': FieldValue.increment(1)
        }).then((value) {
      showAlertDialog(context,"Success","Successfully join the group");
      setState(() {
        TeamB_joinUser.add(useriddd);
      });

    });


  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAuthoreData();
    getLoginUserData();
    getTeamJoinUserList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
          itemCount: TeamB_joinUser.length,//myProjectId.length,
          itemBuilder: (BuildContext context, int index){
            return StreamBuilder(
              stream: FirebaseFirestore.instance.collection('users').doc(TeamB_joinUser[index]).snapshots(),
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
                                                fontSize: 12,
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
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: () {
      //     getLoginUserData();
      //
      //     print(widget.teamAlist);
      //
      //     if(TeamB_joinUser.isEmpty){
      //       print("team b is empty");
      //       if(widget.teamAlist.contains(useriddd)){
      //         print("user in team a");
      //         showAlertDialog(context,"Error","User Already in Team A");
      //       }
      //       else{
      //         joindeTeam();
      //       }
      //
      //     }else{
      //       print("team b list is not epmty");
      //       for (int i = 0; i < TeamB_joinUser.length; i++) {
      //         if (TeamB_joinUser[i] == useriddd){
      //           print("user in team b");
      //           showAlertDialog(context,"Error","User Already in Team B");
      //         }else{
      //           print("user not in team b");
      //           if(widget.teamAlist.contains(useriddd)){
      //             showAlertDialog(context,"Error","User Already in Team A");
      //           }
      //           else{
      //             print("user going to add");
      //             joindeTeam();
      //           }
      //         }
      //       }
      //     }
      //
      //
      //
      //     // if(useriddd != widget.AuthoreId){
      //     //   if(TeamB_joinUser.isEmpty){
      //     //     joindeTeam();
      //     //   }else{
      //     //     for (int i = 0; i < TeamB_joinUser.length; i++) {
      //     //       if(TeamB_joinUser[i] == useriddd){
      //     //         showAlertDialog(context,"Error","You are already joined");
      //     //       }else{
      //     //         joindeTeam();
      //     //       }
      //     //     }
      //     //   }
      //     //
      //     // }else{
      //     //   showAlertDialog(context,"Error","You are already joinedddd");
      //     // }
      //   },
      //   label:  Text('Joined Team',
      //     style: TextStyle(color: Colors.white),),
      //   icon:  Icon(Icons.add,color: Colors.white,),
      //
      //   backgroundColor: Colors.teal[900],
      // ),
    );
  }
}

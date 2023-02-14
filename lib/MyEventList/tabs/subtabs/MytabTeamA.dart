import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../UIcomponents/UIcomponents.dart';
import '../../../databaseManager/databaseManager.dart';



class MyTeamATab extends StatefulWidget {

  final String AuthoreId ;
  final List teamAlist;
  final List teamBlist;
  final String eventId;
  MyTeamATab({super.key, required this.AuthoreId,required this.teamAlist,required this.teamBlist,required this.eventId});

  @override
  State<MyTeamATab> createState() => _MyTeamATabState();
}

class _MyTeamATabState extends State<MyTeamATab> {

  var dbmanager = DatabaseManager();
  var useriddd = "";
  var pic = "";
  var name = "";
  var email = "";
  var gender = "";
  var phoneNo = "";
  var TeamA_joinUser = [];
  var joinPersoTeamA = 0;
  var department  = "";
  var skillset = "";
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
        department = data?['deptname'];
        skillset = data?['skillset'];
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
      var teamAlist = data?['teamA'];
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
            TeamA_joinUser.add(teamAlist[i]);

          }
          print("sdmasdmgadsjgdasjsad");
          print(TeamA_joinUser);
          //stream = FirebaseFirestore.instance.collection('events').doc(projectList[i]).snapshots();
        }
      });
    }

  }

  Future joindeTeam()async{
    //var joinedUserLength = TeamA_joinUser.length;
    await FirebaseFirestore.instance.collection('events').doc(widget.eventId).update(
        {
          'teamA': FieldValue.arrayUnion([useriddd]),
          'JoindePersonTeamA': FieldValue.increment(1)
        }).then((value) {
      showAlertDialog(context,"Success","Successfully join the group");
      setState(() {
        TeamA_joinUser.add(useriddd);
      });

    });


  }

  Future deleteUser(String useriid) async{
    var collection = FirebaseFirestore.instance.collection('events');
    collection
        .doc(widget.eventId)
        .update(
        {
          'teamA': FieldValue.arrayRemove([useriid]),
        }
    ).then((value) {
      showAlertDialog(context,"Success","you delete the user");
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
      body: Column(
        children: [
          Flexible(
              flex: 1,
              child: Container(
                width: double.infinity,
                //color: Colors.green,
                child:  Center(
                    child: Container(
                      margin: EdgeInsets.all(10),
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
                                        child: pic != "" ?Image.network(pic,  fit: BoxFit.fill) :Image.network("https://img.freepik.com/premium-vector/anonymous-user-circle-icon-vector-illustration-flat-style-with-long-shadow_520826-1931.jpg?w=2000",  fit: BoxFit.fill)
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
                                      child: Text(name,
                                        softWrap: false,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
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
                                            Text(email,

                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
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
                                              Icons.add_business_outlined,
                                              size: 20,
                                              color: Colors.grey,
                                            ),
                                            SizedBox(width: 4,),
                                            Text(department,

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
                                              Icons.equalizer,
                                              size: 20,
                                              color: Colors.grey,
                                            ),
                                            SizedBox(width: 4,),
                                            Text(skillset,


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
                                              Icons.phone_android_sharp,
                                              size: 20,
                                              color: Colors.grey,
                                            ),
                                            SizedBox(width: 4,),
                                            Text(phoneNo,

                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
//fontWeight: FontWeight.bold
                                              ),
                                            ),
                                          ],
                                        )
                                    ),

                                  ],
                                ),
                              ))
                        ],
                      ),

                    )
                ),
              )),
          Flexible(
              flex: 3,
              child: Container(
                width: double.infinity,
                //color: Colors.red,
                child: ListView.builder(
                    itemCount: TeamA_joinUser.length,//myProjectId.length,
                    itemBuilder: (BuildContext context, int index){
                      return StreamBuilder(
                        stream: FirebaseFirestore.instance.collection('users').doc(TeamA_joinUser[index]).snapshots(),
                        builder: (context, snapshot){
                          if (snapshot.data == null ) {
                            return Center(child: Text('NO DATA'));
                          }
                          return Center(
                              child: Container(
                                margin: EdgeInsets.all(10),
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
                                        child: Stack(
                                          children: [
                                            Container(
                                              height: 150,
// color: Colors.orange,
                                              child: Column(
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(top: 10,left: 0),
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
                                                            size: 15,
                                                            color: Colors.grey,
                                                          ),
                                                          SizedBox(width: 4,),
                                                          Text(snapshot.data?['email'],
                                                            style: TextStyle(
                                                              color: Colors.black,
                                                              fontSize: 11,
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
                                                            Icons.add_business_outlined,
                                                            size: 20,
                                                            color: Colors.grey,
                                                          ),
                                                          SizedBox(width: 4,),
                                                          Text(snapshot.data?['deptname'],

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
                                                            Icons.equalizer,
                                                            size: 20,
                                                            color: Colors.grey,
                                                          ),
                                                          SizedBox(width: 4,),
                                                          Text(snapshot.data?['skillset'],

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
                                                  ),

                                                ],
                                              ),
                                            ),
                                            Align(
                                              alignment: Alignment.bottomRight,
                                              child: Container(
                                                height: 30,
                                                width: 30,
                                                //color: Colors.green,
                                                child: InkWell(
                                                  onTap: (){
                                                    print("button pressed");
                                                    print(snapshot.data?['id']);
                                                    deleteUser(snapshot.data?['id']);
                                                  },
                                                  child: Icon(
                                                    Icons.delete,
                                                    size: 25,
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ))
                                  ],
                                ),

                              )
                          );
                        },
                      );
                    }
                ),
              )
          )
        ],
      )
    );
  }
}

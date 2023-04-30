import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fyp/homepage/EventsDetailsScreen/tournametEventDetails.dart';
import 'dart:convert';

import '../../UIcomponents/UIcomponents.dart';
import '../../databaseManager/databaseManager.dart';

class tournamentJoinedTeams extends StatefulWidget {
  final String? authoreId;
  final String? eventID;


  tournamentJoinedTeams({required this.authoreId,required this.eventID});


  @override
  State<tournamentJoinedTeams> createState() => _tournamentJoinedTeamsState();
}

class _tournamentJoinedTeamsState extends State<tournamentJoinedTeams> {


  var dbmanager = DatabaseManager();
  var loginUserName = "";
  var eventid = "";
  var joinedTeamList = [];
  var firestore = FirebaseFirestore.instance;

  final teamName_textController = TextEditingController();
  final tplayer_textController = TextEditingController();

  Future getLoginUserData()async{
    var data =  await dbmanager.getData('userBioData');
    var daaa = json.decode(data);
    var userid = daaa['id'];
    setState(() {
      loginUserName = daaa['fullname'];
    });

  }
  Future getJoinedTeamList() async {
    var docSnapshot = await firestore.collection('TourEvents').doc(widget.eventID).get();
    if (docSnapshot.exists) {
      Map<String, dynamic>? data = docSnapshot.data();
      print(data?['joinedTeamList']);
      for (var i in data?['joinedTeamList']){
        setState(() {
          joinedTeamList.add(i);
        });
      }

      print(joinedTeamList);
    }
  }
  Dialog joinTeamForm(){
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Create Team',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: teamName_textController,
              decoration: InputDecoration(
                hintText: 'Enter Your Team Name',
                hintStyle: TextStyle(color: Colors.black),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              style: TextStyle(color: Colors.black),
              controller: tplayer_textController,
              decoration: InputDecoration(
                hintText: 'Enter Total No of Players',
                hintStyle: TextStyle(color: Colors.black),
              ),
            ),
            SizedBox(height: 24),
            Align(
                alignment: Alignment.topRight,
                child: Container(
                  width: 160,
                  height: 50,
                  //color: Colors.orange,
                  child: Row(
                    children: [
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Close'),
                      ),
                      SizedBox(width: 20,),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.teal),
                        ),
                        onPressed: () {
                          print(teamName_textController.text);
                          print(tplayer_textController.text);
                          print(eventid);

                          var jteamHitter = dbmanager.joinedTournamentTeams(teamName_textController.text, tplayer_textController.text, loginUserName, eventid);
                          if (jteamHitter == false){
                            teamName_textController.clear();
                            tplayer_textController.clear();
                            Navigator.pop(context);
                            print("sorry");
                            showAlertDialog(context, "Something Wrong!", "you are not registered in this team ,try again");
                          }else{
                            print("ssssss done done");
                            teamName_textController.clear();
                            tplayer_textController.clear();
                            joinedTeamList = [];
                            getJoinedTeamList();
                            Navigator.pop(context);
                            showAlertDialog(context, "Done", "you are successfukky joined the team ");
                          }
                        },
                        child: Text('Done'),
                      ),
                    ],
                  ),
                )
            )
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLoginUserData();
    setState(() {
      eventid = widget.eventID!;
    });
    getJoinedTeamList();
  }
  @override
  void dispose() {
    teamName_textController.dispose();
    tplayer_textController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
   return Scaffold(
      appBar: AppBar(
        title: const Text("Joined Teams List"),
        backgroundColor: Colors.teal[900],
      ),
      body: ListView.builder(
          itemCount: joinedTeamList.length,//myProjectId.length,
          itemBuilder: (BuildContext context, int index){
            return StreamBuilder(
              stream: FirebaseFirestore.instance.collection('JoinedTeams').doc(joinedTeamList[index]).snapshots(),
              builder: (context, snapshot){
                if (snapshot.data == null ) {
                  return Center(child: Text('NO DATA'));
                }
                return Padding(
                  padding: EdgeInsets.all(10),
                  child: InkWell(
                    onTap: (){
                      print('team ${snapshot.data?['teamName']} is clicked ');
                      print(snapshot.data?.id);
                      var tournamentID = snapshot.data?.id;
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>  tournamentEventDetail(authoreId: widget.authoreId,teamID: snapshot.data?.id)),
                      );


                    },
                    child: Container(
                        height: 100,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.6),
                              spreadRadius: 7,
                              blurRadius: 4,
                              offset: Offset(0, 0), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                                height: 100,
                                width: 80,
//color: Colors.green,
                                child: Center(
                                  child: Text("${index + 1}",
                                    style: TextStyle(
                                        fontSize: 50,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.teal
                                    ),
                                  ),
                                )
                            ),
                            Column(
                              children: <Widget>[
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Container(
                                    width: 300,
                                    //color: Colors.green,
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 10, top: 5),
                                      child: Text(snapshot.data?['teamName'],
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Container(
                                      width: 300,
                                      //color: Colors.green,
                                      child: Row(
                                        children: [
                                          Padding(
                                              padding: EdgeInsets.only(left: 10, top: 5),
                                              child: Icon(Icons.person, size: 18,)
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(left: 10, top: 5),
                                            child: Text(snapshot.data?['creatorName'],
                                              style: TextStyle(
                                                  fontSize: 15
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Container(
                                      width: 300,
                                      //color: Colors.green,
                                      child: Row(
                                        children: [
                                          Padding(
                                              padding: EdgeInsets.only(left: 10, top: 5),
                                              child: Icon(Icons.person, size: 18,)
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(left: 10, top: 5),
                                            child: Text(snapshot.data?['Tplayers'],
                                              style: TextStyle(
                                                  fontSize: 15
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                  ),
                                ),

                              ],
                            ),
                          ],
                        )
                    ),
                  ),);
              },
            );
          }
      ),
     floatingActionButton: FloatingActionButton.extended(
       onPressed: () {
         showDialog(
           context: context,
           builder: (BuildContext context) {
             return joinTeamForm();
           },
         );

       },
       label:  Text('Create Your Team',
         style: TextStyle(color: Colors.white),),
       icon:  Icon(Icons.add,color: Colors.white,),
       backgroundColor: Colors.teal[900],
     ),
    );
  }
}


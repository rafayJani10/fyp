import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fyp/homepage/EventsDetailsScreen/tournametEventDetails.dart';
import 'dart:convert';
import '../../UIcomponents/UIcomponents.dart';
import '../../databaseManager/databaseManager.dart';
import 'package:http/http.dart' as http;

class tournamentJoinedTeams extends StatefulWidget {
  final String? authoreId;
  final String? eventID;
  final bool? role_status;

  tournamentJoinedTeams(
      {required this.authoreId, required this.eventID, this.role_status});

  @override
  State<tournamentJoinedTeams> createState() => _tournamentJoinedTeamsState();
}

class _tournamentJoinedTeamsState extends State<tournamentJoinedTeams> {
  var dbmanager = DatabaseManager();
  var loginUserName = "";
  var loginuserNO = "";
  var eventid = "";
  var joinedTeamList = [];
  var firestore = FirebaseFirestore.instance;
  var authoreDeviceToken = "";
  var _isloading = true;
  var _noDataALert = false;
  final teamName_textController = TextEditingController();
  final tplayer_textController = TextEditingController();
  var role_check = false;
  var admin_right_to_delete_team = false;

  Future getLoginUserData() async {
    var data = await dbmanager.getData('userBioData');
    var daaa = json.decode(data);
    var userid = daaa['id'];
    setState(() {
      loginUserName = daaa['fullname'];
      loginuserNO = daaa["phoneNumber"];
      if (daaa?['roles'] == 2) {
        role_check = true;
        admin_right_to_delete_team = false;
      } else {
        role_check = false;
        admin_right_to_delete_team = true;
      }
    });
  }

  Future getJoinedTeamList() async {
    var docSnapshot =
        await firestore.collection('TourEvents').doc(widget.eventID).get();
    if (docSnapshot.exists) {
      Map<String, dynamic>? data = docSnapshot.data();
      print(data?['joinedTeamList']);
      setState(() {
        for (var i in data?['joinedTeamList']) {
          joinedTeamList.add(i);
        }
        print(joinedTeamList);
        if (joinedTeamList.isNotEmpty) {
          _isloading = false;
        } else {
          _isloading = false;
          _noDataALert = true;
        }
      });
    }
  }

  Future getAuthoreDeviceToken() async {
    var docSnapshot =
        await firestore.collection('users').doc(widget.authoreId).get();
    if (docSnapshot.exists) {
      Map<String, dynamic>? data = docSnapshot.data();
      print(data?['deviceToken']);
      setState(() {
        authoreDeviceToken = data?['deviceToken'];
      });

      print(authoreDeviceToken);
    }
  }

  Dialog joinTeamForm() {
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
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.red),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Close'),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.teal),
                        ),
                        onPressed: () async {

                          if(teamName_textController.text.isEmpty || teamName_textController.text == " "){
                            showAlertDialog(context, "Error", "Team name was not entered");
                          }else{
                            var jteamHitter = dbmanager.createTeamsInTornament(
                                teamName_textController.text,
                                loginuserNO,
                                loginUserName,
                                eventid);
                            if (jteamHitter == false) {
                              teamName_textController.clear();
                              //tplayer_textController.clear();
                              Navigator.pop(context);
                              print("sorry");
                              showAlertDialog(context, "Something Wrong!",
                                  "you are not registered in this team ,try again");
                            } else {
                              print("ssssss done done");
                              teamName_textController.clear();
                              tplayer_textController.clear();
                              setState(() {
                                _noDataALert = false;
                                joinedTeamList = [];
                                getJoinedTeamList();
                              });

                              Navigator.pop(context);
                              showAlertDialog(
                                  context, "Done", "Team created successfully ");
                              var data = {
                                'to': authoreDeviceToken,
                                'priority': 'high',
                                'notification': {
                                  'title': 'New Team',
                                  'body': 'New team included in team list'
                                }
                              };
                              await http.post(
                                  Uri.parse(
                                      'https://fcm.googleapis.com/fcm/send'),
                                  body: jsonEncode(data),
                                  headers: {
                                    'Content-Type':
                                    'application/json; character=UTF-8',
                                    'Authorization':
                                    'key=AAAA4vnms68:APA91bHEf5AiZNGMPVT4jhpwG-ch-xibl1bHViNssWa21fYTsCCs0AMuLGPVqzDnhNOcwGTc_YvGrUqAyKSf2VU-jAJZ70I8J6vhHbZMd2WK898FjxZJ2pJAUv6H_MBF4-lUridh9q8P'
                                  });
                            }
                          }

                        },
                        child: Text('Done'),
                      ),
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }

  Future<void> deleteJoinTeam(documentId, tournamentID) async {
    try {
      await FirebaseFirestore.instance
          .collection('JoinedTeams')
          .doc(documentId)
          .delete()
          .then((value) async {
        await FirebaseFirestore.instance
            .collection('TourEvents')
            .doc(tournamentID)
            .update({
          'joinedTeamList': FieldValue.arrayRemove([documentId])
        });
        showAlertDialog(context, "Done", "You successfully delete the event");
        setState(() {
          _isloading = false;
          joinedTeamList = [];
          getJoinedTeamList();
        });
      });
      print('Document deleted successfully.');
    } catch (e) {
      print('Error deleting document: $e');
    }
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
    getAuthoreDeviceToken();
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
        body: Stack(
          children: [
            ListView.builder(
                itemCount: joinedTeamList.length, //myProjectId.length,
                itemBuilder: (BuildContext context, int index) {
                  return StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('JoinedTeams')
                        .doc(joinedTeamList[index])
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Padding(
                          padding: EdgeInsets.all(10),
                          child: InkWell(
                            onTap: () {
                              print(
                                  'team ${snapshot.data?['teamName']} is clicked ');
                              print(snapshot.data?.id);
                              var tournamentID = snapshot.data?.id;
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => tournamentEventDetail(
                                        authoreId: widget.authoreId,
                                        teamID: snapshot.data?.id,
                                        role_status: widget.role_status)),
                              );
                            },
                            child: Container(
                                width: double.infinity,
                                height: 100,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.3),
                                      spreadRadius: 7,
                                      blurRadius: 4,
                                      offset: Offset(
                                          0, 0), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: Stack(
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                            height: 100,
                                            width: 80,
                                            child: Center(
                                              child: Text(
                                                "${index + 1}",
                                                style: TextStyle(
                                                    fontSize: 50,
                                                    fontWeight: FontWeight.w900,
                                                    color: Colors.teal),
                                              ),
                                            )),
                                        Column(
                                          children: <Widget>[
                                            Align(
                                              alignment: Alignment.topLeft,
                                              child: Container(
                                                width: 200,
                                                //color: Colors.green,
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 10, top: 5),
                                                  child: Text(
                                                    snapshot.data?['teamName'],
                                                    softWrap: false,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 20),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Align(
                                              alignment: Alignment.topLeft,
                                              child: Container(
                                                  width: 200,
                                                  //color: Colors.green,
                                                  child: Row(
                                                    children: [
                                                      Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 10,
                                                                  top: 5),
                                                          child: Icon(
                                                            Icons.person,
                                                            size: 18,
                                                          )),
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 10,
                                                                top: 5),
                                                        child: Text(
                                                          snapshot.data?[
                                                              'creatorName'],
                                                          softWrap: false,
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                              fontSize: 15),
                                                        ),
                                                      ),
                                                    ],
                                                  )),
                                            ),
                                            Align(
                                              alignment: Alignment.topLeft,
                                              child: Container(
                                                  width: 200,
                                                  //color: Colors.green,
                                                  child: Row(
                                                    children: [
                                                      Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 10,
                                                                  top: 5),
                                                          child: Icon(
                                                            Icons
                                                                .phone_android_sharp,
                                                            size: 18,
                                                          )),
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 10,
                                                                top: 5),
                                                        child: Text(
                                                          snapshot
                                                              .data?['phoneNO'],
                                                          softWrap: false,
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                              fontSize: 15),
                                                        ),
                                                      ),
                                                    ],
                                                  )),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.only(top: 10, right: 10),
                                      child: Visibility(
                                          visible: admin_right_to_delete_team,
                                          child: Align(
                                            alignment: Alignment.topRight,
                                            child: InkWell(
                                              onTap: () {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title: Text(
                                                          "Want to delete the team in tournament ?"),
                                                      actions: <Widget>[
                                                        ElevatedButton(
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                                  primary:
                                                                      Colors.red
                                                                  //onPrimary: Colors.black,
                                                                  ),
                                                          child: Text("No"),
                                                          onPressed: () {
                                                            setState(() {
                                                              _isloading =
                                                                  false;
                                                            });
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                        ),
                                                        ElevatedButton(
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                                  primary: Colors
                                                                      .teal[900]
                                                                  //onPrimary: Colors.black,
                                                                  ),
                                                          child: Text("Yes"),
                                                          onPressed: () {
                                                            _isloading = true;
                                                            print(
                                                              snapshot.data?.id,
                                                            );
                                                            deleteJoinTeam(
                                                                snapshot
                                                                    .data?.id,
                                                                widget.eventID);
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              },
                                              child: Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                              ),
                                            ),
                                          )),
                                    )
                                  ],
                                )),
                          ),
                        );
                      }
                      return SizedBox();
                    },
                  );
                }),
            Visibility(
                visible: _isloading,
                child: Center(
                  child: CircularProgressIndicator(),
                )),
            Visibility(
                visible: _noDataALert,
                child: Center(
                  child: Container(
                    height: 400,
                    width: 300,
                    //color: Colors.teal,
                    child: Column(
                      children: [
                        Container(
                          height: 300,
                          width: 300,
                          child: Image.asset('assets/images/team.png'),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Text(
                          "No Team Joined",
                          style: TextStyle(fontSize: 20, color: Colors.grey),
                        )
                      ],
                    ),
                  ),
                )),
          ],
        ),
        floatingActionButton: Visibility(
          visible: role_check,
          child: FloatingActionButton.extended(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return joinTeamForm();
                },
              );
            },
            label: const Text(
              'Create Your Team',
              style: TextStyle(color: Colors.white),
            ),
            icon: Icon(
              Icons.add,
              color: Colors.white,
            ),
            backgroundColor: Colors.teal[900],
          ),
        ));
  }
}

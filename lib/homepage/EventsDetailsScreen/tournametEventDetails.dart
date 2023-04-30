import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../UIcomponents/UIcomponents.dart';
import '/databaseManager/databaseManager.dart';

class tournamentEventDetail extends StatefulWidget {
  final String? authoreId;
  final String? teamID;


  tournamentEventDetail({required this.authoreId,required this.teamID});

  @override
  State<tournamentEventDetail> createState() => _tournamentEventDetailState();
}

class _tournamentEventDetailState extends State<tournamentEventDetail> {

  var dbmanager = DatabaseManager();
  var firestore = FirebaseFirestore.instance;
  var LoginUserId = "";
  var LoginUserName = "";
  var LoginUserDept = "";
  var LoginUserSkills = "";
  var LoginUserImage = "";
  var joinUsersInTeams = [];


  final teamName_textController = TextEditingController();
  final pSkill_textController = TextEditingController();

  // Future getLoginUserData()async{
  //   var data =  await dbmanager.getData('userBioData');
  //   var daaa = json.decode(data);
  //   var userid = daaa['id'];
  //   setState(() {
  //     LoginUserId = userid;
  //   });
  //
  // }
  // Future getTeamJoinUserLists() async {
  //   var collection = FirebaseFirestore.instance.collection('TourEvents');
  //   var docSnapshot = await collection.doc(widget.eventID).get();
  //   if (docSnapshot.exists) {
  //     Map<String, dynamic>? data = docSnapshot.data();
  //     var tourListUser = data?['joinedUserList'];
  //     setState(()  {
  //       var projLength = tourListUser.length;
  //       for (var i = 0; i < projLength; i++) {
  //         print(i);
  //         tournamentUserList.add(tourListUser[i]);
  //         print("sdmasdmgadsjgdasjsad");
  //         print(tournamentUserList);
  //       }
  //     });
  //   }
  //
  // }
  // Future joimSelectedEvent() async{
  //   var data =  await dbmanager.getData('userBioData');
  //   var daaa = json.decode(data);
  //   var userid = daaa['id'];
  //
  //   await FirebaseFirestore.instance.collection("TourEvents").doc(widget.eventID)
  //       .update(
  //       {"joinedUserList": FieldValue.arrayUnion([LoginUserId])}
  //   ).then((value) {
  //     tournamentUserList = [];
  //     showAlertDialog(context,"Successfully Join","Your team successfully join the tournaments");
  //     getTeamJoinUserLists();
  //   });
  // }
  // Future wantDeleteYourself() async{
  //   var collection = FirebaseFirestore.instance.collection('TourEvents');
  //   collection
  //       .doc(widget.eventID)
  //       .update(
  //       {
  //         'joinedUserList': FieldValue.arrayRemove([LoginUserId]),
  //       }
  //   ).then((value){
  //
  //     showAlertDialog(context,"Successfull","you deleted from this toyrnament");
  //     tournamentUserList = [];
  //     getTeamJoinUserLists();
  //   });
  //
  // }

  Dialog joinInTeamForm(){
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
              'Join The Team',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              enabled: false,
              controller: teamName_textController,
              decoration: InputDecoration(
                hintText: LoginUserName,
                hintStyle: TextStyle(color: Colors.black),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              enabled: false,
              controller: teamName_textController,
              decoration: InputDecoration(
                hintText: LoginUserDept,
                hintStyle: TextStyle(color: Colors.black),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              style: TextStyle(color: Colors.black),
              controller: pSkill_textController,
              decoration: InputDecoration(
                hintText: 'Enter Your Skill',
                hintStyle: TextStyle(color: Colors.black),
              ),
            ),
            const SizedBox(height: 24),
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
                        onPressed: () async {
                          var jteam = await joinTheTeamButton(pSkill_textController.text);
                          print("ccccccc");
                          if(pSkill_textController.text == ''){
                            print("jdbjggffaj");
                            Navigator.pop(context);
                            showAlertDialog(context, "Error!", "Kindly add your skill");
                          }else{
                            if(jteam == true ){
                              Navigator.pop(context);
                              joinUsersInTeams = [];
                              joinUserInteam();

                              showAlertDialog(context, "Done!", "you are in this team");
                            }
                            else{
                              Navigator.pop(context);
                              print("sorry");
                              showAlertDialog(context, "Something Wrong!", "you are not registered in this team ,try again");
                            }
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
  Future getLoginUserDataa()async{
    var data =  await dbmanager.getData('userBioData');
    var daaa = json.decode(data);
    setState(() {
      LoginUserId = daaa['id'];
      LoginUserName = daaa['fullname'];
      LoginUserDept = daaa['deptname'];
      LoginUserSkills = daaa['skillset'];
      LoginUserImage = daaa['picture'];
    });
  }
  Future<bool?> joinTheTeamButton(skillsett) async{
    var joinTeamStatus = false;
    await FirebaseFirestore.instance.collection('users').doc(LoginUserId)
    .update({'skillset': skillsett})
        .then((value) async{
          await FirebaseFirestore.instance.collection('JoinedTeams').doc(widget.teamID).update(
            {'joinedPlayerInTeam': FieldValue.arrayUnion([LoginUserId])
            });
         joinTeamStatus = true;
        });
    return joinTeamStatus;
    }
  Future joinUserInteam()async{
    var docSnapshot = await firestore.collection('JoinedTeams').doc(widget.teamID).get();
    if (docSnapshot.exists) {
      Map<String, dynamic>? data = docSnapshot.data();
      print(data?['joinedPlayerInTeam']);
      for (var i in data?['joinedPlayerInTeam']){
        setState(() {
          joinUsersInTeams.add(i);
        });
      }

      print(joinUsersInTeams);
    }
  }




  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLoginUserDataa();
    joinUserInteam();
    print(joinUsersInTeams);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    pSkill_textController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Event List"),
        backgroundColor: Colors.teal[900],
      ),
      body: ListView.builder(
          itemCount: joinUsersInTeams.length,//myProjectId.length,
          itemBuilder: (BuildContext context, int index){
            return StreamBuilder(
              stream: FirebaseFirestore.instance.collection('users').doc(joinUsersInTeams[index]).snapshots(),
              builder: (context, snapshot){
                if (snapshot.data == null ) {
                  return Center(child: Text('NO DATA'));
                }
                return Container(
                  margin: EdgeInsets.all(8),
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
                                    child: snapshot.data?['picture'] != "" ?Image.network(snapshot.data?['picture'],  fit: BoxFit.fill) :Image.network("https://img.freepik.com/premium-vector/anonymous-user-circle-icon-vector-illustration-flat-style-with-long-shadow_520826-1931.jpg?w=2000",  fit: BoxFit.fitHeight),
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
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(top: 8,left: 8),
                                      child: Text(snapshot.data?['fullname'],
// snapshot.data?['fullname'],
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
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
// snapshot.data?['email'],


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
                                              Icons.equalizer,
                                              size: 20,
                                              color: Colors.grey,
                                            ),
                                            SizedBox(width: 4,),
                                            Text(snapshot.data?['skillset'],
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
                                            Text(snapshot.data?['phoneNumber'],
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 12,
//fontWeight: FontWeight.bold
                                              ),
                                            ),
                                          ],
                                        )
                                    )
                                  ],
                                ),
                              ),
// if(snapshot.data?['id'] == LoginUserId)
//   InkWell(
//     onTap: (){
//       showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: Text("Want to quit???"),
//             actions: <Widget>[
//               ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                     primary: Colors.red
//                   //onPrimary: Colors.black,
//                 ),
//                 child: Text("No"),
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//               ),
//               ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   primary: Colors.teal[900],
//                   //onPrimary: Colors.black,
//                 ),
//                 child: Text("Yes"),
//                 onPressed: () {
//                   setState(() {
//                     wantDeleteYourself();
//                   });
//                   Navigator.of(context).pop();
//                 },
//               ),
//             ],
//           );
//         },
//       );
//
//     },
//     child: Align(
//       alignment: Alignment.bottomRight,
//       child: Container(
//         height: 50,
//         width: 50,
//         // color: Colors.orange,
//         child: Icon(Icons.delete,
//           color: Colors.red,
//         ),
//       ),
//     ),
//   )

                            ],
                          ))
                    ],
                  ),
                );
              },
            );
          }
      ),



      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return joinInTeamForm();
            },
          );
        },
        label:  Text('Join',
          style: TextStyle(color: Colors.white),),
        icon:  Icon(Icons.add,color: Colors.white,),
        backgroundColor: Colors.teal[900],
      ),
    );
  }
}


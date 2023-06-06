import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../UIcomponents/UIcomponents.dart';
import '/databaseManager/databaseManager.dart';

class tournamentEventDetail extends StatefulWidget {
  final String? authoreId;
  final String? teamID;
  final bool? role_status;


  tournamentEventDetail({required this.authoreId,required this.teamID, required this.role_status});

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
  var _isloading = true;
  var _isNodataAlert = false;
  var role_check = false;


  final teamName_textController = TextEditingController();
  final pSkill_textController = TextEditingController();


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
                          if(pSkill_textController.text == ''){
                            showAlertDialog(context, "Error!", "Kindly add your skill");
                          }else{
                            if(jteam == true ){
                              var _joinedteam = await dbmanager.joinedMemeberInteam(widget.teamID, LoginUserId);
                              Navigator.pop(context);
                              if(_joinedteam == true){
                                setState(() {
                                  _isNodataAlert = false;
                                  joinUsersInTeams = [];
                                  joinUserInteam();
                                });
                                showAlertDialog(context, "Done!", "You are in this team");
                              }

                            }
                            else{
                              Navigator.pop(context);
                              print("sorry");
                              showAlertDialog(context, "Something Wrong!", "You are already registered in this team");
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
      if(daaa?['roles'] == 2){
        role_check = true;
      }else{
        role_check = false;
      }
    });
  }
  Future<bool?> joinTheTeamButton(skillsett) async{
    var joinTeamStatus = false;
    bool containeUsers = joinUsersInTeams.contains(LoginUserId);
    if(containeUsers == true){
      print("already in table");
    }
    else{
      print("new use rfound");
      joinTeamStatus = true;

    }
    return joinTeamStatus;
    }
  Future joinUserInteam()async{
    var docSnapshot = await firestore.collection('JoinedTeams').doc(widget.teamID).get();
    if (docSnapshot.exists) {
      Map<String, dynamic>? data = docSnapshot.data();
      print(data?['joinedPlayerInTeam']);
      setState(() {
        for (var i in data?['joinedPlayerInTeam']){
            joinUsersInTeams.add(i);
        }
        if(joinUsersInTeams.isNotEmpty){
          _isloading = false;
        }else{
          _isloading = false;
          _isNodataAlert = true;
        }
      });


      print(joinUsersInTeams);
    }
  }
  Future deleteownSelf() async{
    var collection = FirebaseFirestore.instance.collection('JoinedTeams');
    collection
        .doc(widget.teamID)
        .update(
        {
          'joinedPlayerInTeam': FieldValue.arrayRemove([LoginUserId]),
        }
    ).then((value){

      showAlertDialog(context,"Successfull","You deleted from this tournament");
      joinUsersInTeams = [];
      joinUserInteam();
      setState(() {
        _isloading = false;
      });
    });
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
      body: Stack(
        children: [
          ListView.builder(
              itemCount: joinUsersInTeams.length,//myProjectId.length,
              itemBuilder: (BuildContext context, int index){
                return StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('users').doc(joinUsersInTeams[index]).snapshots(),
                  builder: (context, snapshot){
                   if(snapshot.hasData){
                     return Container(
                       margin: EdgeInsets.all(8),
                       height: 150,
                       decoration: BoxDecoration(
                         color: Colors.white,
                         boxShadow: [
                           BoxShadow(
                             color: Colors.grey.withOpacity(0.3),
                             spreadRadius: 6, blurRadius: 7,
                             offset: Offset(0, 3), // changes position of shadow
                           ),
                         ],
                       ),
                       child: Row(
                         children: [
                           SizedBox(width: 5,),
                           Flexible(
                             flex: 1,
                             child:  Stack(
                               children: [
                                 // Circular avatar with image or placeholder
                                 CircleAvatar(
                                     radius: 40,
                                     backgroundColor: Colors.grey, // Placeholder color
                                     backgroundImage: snapshot.data?['picture'] == null || snapshot.data?['picture'] == ""
                                         ?  NetworkImage("https://img.freepik.com/premium-vector/anonymous-user-circle-icon-vector-illustration-flat-style-with-long-shadow_520826-1931.jpg?w=2000")
                                         : NetworkImage(snapshot.data?['picture'])
                                 ),

                                 // // Loader
                                 // if (is_image_loading)
                                 //   Positioned.fill(
                                 //     child: CircularProgressIndicator(),
                                 //   ),
                               ],
                             ),),
                           SizedBox(width: 5,),
                           Flexible(
                               flex: 2,
                               child: Stack(
                                 children: [
                                   Container(
                                     height: 150,
                                     child: Stack(
                                       children: [
                                         Column(
                                           children: [
                                             Padding(
                                               padding: EdgeInsets.only(top: 8,left: 8),
                                               child: Text(snapshot.data?['fullname'],
                                                 softWrap: false,
                                                 maxLines: 1,
                                                 overflow: TextOverflow.ellipsis,
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
                                                       softWrap: false,
                                                       maxLines: 1,
                                                       overflow: TextOverflow.ellipsis,
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
                                                       softWrap: false,
                                                       maxLines: 1,
                                                       overflow: TextOverflow.ellipsis,
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
                                                       softWrap: false,
                                                       maxLines: 1,
                                                       overflow: TextOverflow.ellipsis,
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
                                                       softWrap: false,
                                                       maxLines: 1,
                                                       overflow: TextOverflow.ellipsis,
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

                                         if(snapshot.data!["id"] == LoginUserId)
                                         Align(
                                           alignment: Alignment.bottomRight,
                                           child: InkWell(
                                             onTap: (){
                                               setState(() {
                                                 _isloading = true;
                                               });
                                               deleteownSelf();
                                             },
                                             child: Container(
                                               child: Icon(Icons.delete, color: Colors.red,),
                                             ),
                                           ),
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
                   }
                    return SizedBox();
                  },
                );
              }
          ),
          Visibility(visible:_isloading,child: Center(child: CircularProgressIndicator(),)),
          Visibility(visible:_isNodataAlert, child: Center(
            child: Container(
              height: 400,
              width: 300,
              //color: Colors.teal,
              child: Column(
                children: [
                  Container(
                    height: 300,
                    width: 300,
                    child: Image.asset('assets/images/profile.png'),
                  ),
                  SizedBox(height: 40,),
                  const Text("No User Joined", style: TextStyle(fontSize: 20,  color: Colors.grey),)
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
                return joinInTeamForm();
              },
            );
          },
          label:  const Text('Join',
            style: TextStyle(color: Colors.white),),
          icon:  const Icon(Icons.add,color: Colors.white,),
          backgroundColor: Colors.teal[900],
        ),
      )
    );
  }
}


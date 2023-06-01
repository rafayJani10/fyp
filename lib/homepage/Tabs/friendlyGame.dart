import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../UIcomponents/UIcomponents.dart';
import '../../databaseManager/databaseManager.dart';
import '../EventsDetailsScreen/friendlyGameDetails.dart';
import '../UserEventJoined/EventParticipantUser.dart';

class FriendlyGame extends StatefulWidget {
  const FriendlyGame({Key? key}) : super(key: key);

  @override
  State<FriendlyGame> createState() => _FriendlyGameState();
}

class _FriendlyGameState extends State<FriendlyGame> {
  var dbmanager = DatabaseManager();
  var loginUserid = "";
  var serachList = [];
  var searchKey = "";
  var roles = false;

  //Login user data
  var dept = "";
  var phoneNumber = "";
  var _isloading = true;
  var _isNodataAlert = false;

  Stream<QuerySnapshot> stream() async* {
    var firestore = FirebaseFirestore.instance;
    var _stream = firestore.collection('events').snapshots();

    yield* _stream;
  }

  Stream<QuerySnapshot> searchData(String string) async* {
    var stringg = string;
    var firestore = FirebaseFirestore.instance;
    var _search = firestore
        .collection('events')
        .where('sports', isGreaterThanOrEqualTo: stringg)
        .where('sports', isLessThan: stringg + 'z')
        .snapshots();
    yield* _search;
  }

  Future<dynamic> getUserData() async {
    var data = await dbmanager.getData('userBioData');
    var daaa = json.decode(data);
    setState(() {
      dept = daaa['deptname'];
      phoneNumber = daaa['phoneNumber'];
      print(dept + phoneNumber);

      if(daaa['roles'] == 2){
        setState(() {
          roles = false;
        });
      }else{
        setState(() {
          roles = true;
        });
      }
    });
  }

  Future<void> deleteDocument(documentId, authore_id) async {
    try {
      await FirebaseFirestore.instance
          .collection('events')
          .doc(documentId)
          .delete().then((value) async {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(authore_id)
            .update({
          'projects': FieldValue.arrayRemove([documentId])
        });
        showAlertDialog(context,"Done","You successfully delete the event");
            setState(() {
              _isloading = false;
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
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Container(
              width: double.infinity,
              height: 80,
              color: Colors.white,
              child: Container(
                margin: EdgeInsets.all(10),
                height: 80,
                decoration: BoxDecoration(
                  //color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 3,
                      blurRadius: 4,
                      offset: Offset(0, 0), // changes position of shadow
                    ),
                  ],
                ),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      searchKey = value;
                      searchData(searchKey);
                    });
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors
                            .transparent, // Set the desired color for the focused border
                      ),
                    ),
                    suffixIcon: Icon(Icons.search),
                    suffixIconColor: Colors.teal[900],
                    hintText: 'Type Text Here...',
                    hintStyle: TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                child: StreamBuilder<QuerySnapshot>(
                  stream: (searchKey != null || searchKey != "")
                      ? searchData(searchKey)
                      : stream(),
                  builder: (context, snapshot) {

                    if (snapshot.data == null) {
                      _isloading = false;

                      return SizedBox();
                    }
                    return ListView.builder(
                        itemCount: snapshot.data?.docs.length,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          var data = snapshot.data?.docs;
                          _isloading = false;

                          return InkWell(
                              onTap: () {
                                if (phoneNumber == "" || dept == "") {
                                  showAlertDialog(context, "Error",
                                      "Sorry you are not able to do further process kindly updaet your profile");
                                } else {
                                  var authorId = snapshot.data?.docs[index]
                                      ['eventAuthore'];
                                  var eventIdd =
                                      snapshot.data?.docs[index].reference.id;
                                  var teamAJoindeList =
                                      snapshot.data?.docs[index]['teamA'];
                                  var teamBJoindeList =
                                      snapshot.data?.docs[index]['teamB'];
                                  print(authorId);
                                  print(eventIdd);
                                  print(teamAJoindeList);
                                  print(teamBJoindeList);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              FriendlyEventDetails(
                                                AuthoreId: authorId,
                                                teamAlist: teamAJoindeList,
                                                teamBlist: teamBJoindeList,
                                                eventId: eventIdd!,
                                              )));
                                }
                              },
                              child:Container(
                                  margin: EdgeInsets.all(8),
                                  height: 150,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.3),
                                        spreadRadius: 6,
                                        blurRadius: 7,
                                        offset: Offset(0,
                                            3), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: Stack(
                                    children: [
                                      Row(
                                        children: <Widget>[
                                          Flexible(
                                            flex: 2,
                                            child: SizedBox(
                                              height: 130,
                                              child: Center(
                                                  child: snapshot.data
                                                      ?.docs[index]
                                                  ['picture'] ==
                                                      ""
                                                      ? Image.network(
                                                    "https://firebasestorage.googleapis.com/v0/b/bukc-sports-hub.appspot.com/o/imgPh.jpeg?alt=media&token=e41c5f50-8ccb-4276-9538-bacf349f24ba",
                                                    //height: 150,
                                                    fit: BoxFit.fitHeight,
                                                  )
                                                      : Image.network(
                                                    snapshot.data
                                                        ?.docs[index]
                                                    ['picture'],
                                                    //height: 150,
                                                    fit: BoxFit.fitHeight,
                                                  )),
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
                                                        padding: EdgeInsets.only(
                                                            left: 10, top: 15),
                                                        //color: Colors.yellow,
                                                        height: 50,
                                                        child: Text(
                                                            snapshot.data
                                                                ?.docs[index]
                                                            ['name'],
                                                            softWrap: false,
                                                            maxLines: 1,
                                                            overflow: TextOverflow
                                                                .ellipsis,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .grey[800],
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold,
                                                                fontSize: 20)),
                                                      )),
                                                  Flexible(
                                                      flex: 2,
                                                      child: Container(
                                                          width: double.infinity,
                                                          height: 50,
                                                          //color: Colors.green,
                                                          padding:
                                                          EdgeInsets.only(
                                                              left: 10),
                                                          child: Column(
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Icon(
                                                                    Icons.sports,
                                                                    color: Colors
                                                                        .orange,
                                                                    size: 20.0,
                                                                  ),
                                                                  Text(
                                                                      snapshot.data
                                                                          ?.docs[index]
                                                                      [
                                                                      'sports'],
                                                                      style: TextStyle(
                                                                          color: Colors.grey[
                                                                          600],
                                                                          fontSize:
                                                                          15))
                                                                ],
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Icon(
                                                                    Icons
                                                                        .location_on_rounded,
                                                                    color: Colors
                                                                        .red,
                                                                    size: 20.0,
                                                                  ),
                                                                  Text(
                                                                      snapshot.data
                                                                          ?.docs[index]
                                                                      [
                                                                      'address'],
                                                                      style: TextStyle(
                                                                          color: Colors.grey[
                                                                          600],
                                                                          fontSize:
                                                                          15))
                                                                ],
                                                              )
                                                            ],
                                                          ))),
                                                  Flexible(
                                                      flex: 2,
                                                      child: Container(
                                                        //color: Colors.red,
                                                        width: double.infinity,
                                                        child: Padding(
                                                            padding:
                                                            const EdgeInsets
                                                                .only(
                                                                left: 15.0,
                                                                top: 5),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceEvenly,
                                                              children: [
                                                                IconContainer(
                                                                    "",
                                                                    Icons
                                                                        .date_range,
                                                                    data![index]
                                                                    ["date"],
                                                                    Colors.grey),
                                                                IconContainer(
                                                                    "",
                                                                    Icons.timer,
                                                                    data![index][
                                                                    "time"][0],
                                                                    Colors.black),
                                                                IconContainer(
                                                                    "",
                                                                    Icons.group,
                                                                    data![index][
                                                                    "teamsATP"]
                                                                        .toString(),
                                                                    Colors
                                                                        .blueAccent),
                                                                IconContainer(
                                                                    "",
                                                                    Icons
                                                                        .person_add,
                                                                    data![index][
                                                                    "JoindePersonTeamA"]
                                                                        .toString(),
                                                                    Colors
                                                                        .lightBlue),
                                                                IconContainer(
                                                                    "",
                                                                    Icons.group,
                                                                    data![index][
                                                                    "teambTP"]
                                                                        .toString(),
                                                                    Colors
                                                                        .orange),
                                                                IconContainer(
                                                                    "",
                                                                    Icons
                                                                        .person_add,
                                                                    data![index][
                                                                    "JoindePersonTeamB"]
                                                                        .toString(),
                                                                    Colors
                                                                        .orangeAccent),
                                                              ],
                                                            )),
                                                      ))
                                                ],
                                              )),
                                        ],
                                      ),
                                      Padding(padding: EdgeInsets.only(top: 10,right: 10),

                                      child: Visibility(
                                          visible: roles,
                                          child: Align(
                                            alignment: Alignment.topRight,
                                            child: InkWell(
                                              onTap: (){

                                                showDialog(
                                                  context: context,
                                                  builder: (BuildContext context) {
                                                    return AlertDialog(
                                                      title: Text("Want to delete the event ?"),
                                                      actions: <Widget>[
                                                        ElevatedButton(
                                                          style: ElevatedButton.styleFrom(
                                                              primary: Colors.red
                                                            //onPrimary: Colors.black,
                                                          ),
                                                          child: Text("No"),
                                                          onPressed: () {
                                                            Navigator.of(context).pop();
                                                          },
                                                        ),
                                                        ElevatedButton(
                                                          style: ElevatedButton.styleFrom(
                                                              primary: Colors.teal[900]
                                                            //onPrimary: Colors.black,
                                                          ),
                                                          child: Text("Yes"),
                                                          onPressed: () {
                                                            _isloading = true;
                                                            deleteDocument(
                                                                snapshot.data?.docs[index].id,
                                                                snapshot.data?.docs[index]["eventAuthore"]
                                                            );
                                                            Navigator.of(context).pop();
                                                          },
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );

                                              },
                                              child: Icon(Icons.delete, color: Colors.red,),
                                            ),

                                          )),)
                                    ],
                                  )
                              ),);
                        });
                  },
                ),
              ),
            ),
          ],
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
    );
  }

  Widget IconContainer(
      String message, IconData icon, String value, Color iconTint) {
    return Tooltip(
      message: message,
      child: Column(
        children: <Widget>[
          Icon(
            icon,
            color: iconTint,
            size: 20.0,
          ),
          const SizedBox(
            height: 8,
          ),
          Text(value, maxLines: 2, style: const TextStyle(fontSize: 10)),
        ],
      ),
    );
  }
}

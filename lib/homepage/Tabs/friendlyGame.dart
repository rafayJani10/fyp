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



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
                var data = snapshot.data?.docs;

                if (!snapshot.hasData) return const Text('loading ...');

                return ListView.builder(
                    itemCount: snapshot.data?.docs.length,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {
                          var authorId =
                              snapshot.data?.docs[index]['eventAuthore'];
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
                                  builder: (context) => FriendlyEventDetails(
                                        AuthoreId: authorId,
                                        teamAlist: teamAJoindeList,
                                        teamBlist: teamBJoindeList,
                                        eventId: eventIdd!,
                                      )));
                        },
                        child: Column(
                          children: [
                            Container(
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
                                    offset:
                                    Offset(0, 3), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: Row(
                                children: <Widget>[
                                  Flexible(
                                    flex: 2,
                                    child: SizedBox(
                                      height: 130,
                                      child: Center(
                                          child: snapshot.data?.docs[index]
                                          ['picture'] ==
                                              ""
                                              ? Image.network(
                                            "https://firebasestorage.googleapis.com/v0/b/bukc-sports-hub.appspot.com/o/imgPh.jpeg?alt=media&token=e41c5f50-8ccb-4276-9538-bacf349f24ba",
                                            //height: 150,
                                            fit: BoxFit.fitHeight,
                                          )
                                              : Image.network(
                                            snapshot.data?.docs[index]
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
                                                    snapshot.data?.docs[index]
                                                    ['name'],
                                                    softWrap: false,
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
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
                                                  //color: Colors.green,
                                                  padding:
                                                  EdgeInsets.only(left: 10),
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Icon(
                                                            Icons.sports,
                                                            color: Colors.orange,
                                                            size: 20.0,
                                                          ),
                                                          Text(
                                                              snapshot.data
                                                                  ?.docs[index]
                                                              ['sports'],
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .grey[600],
                                                                  fontSize: 15))
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Icon(
                                                            Icons
                                                                .location_on_rounded,
                                                            color: Colors.red,
                                                            size: 20.0,
                                                          ),
                                                          Text(
                                                              snapshot.data
                                                                  ?.docs[index]
                                                              ['address'],
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .grey[600],
                                                                  fontSize: 15))
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
                                                    padding: const EdgeInsets.only(
                                                        left: 15.0, top: 5),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                      children: [
                                                        IconContainer(
                                                            "",
                                                            Icons.date_range,
                                                            data![index]["date"],
                                                            Colors.grey),
                                                        IconContainer(
                                                            "",
                                                            Icons.timer,
                                                            data![index]["time"][0],
                                                            Colors.black),
                                                        IconContainer(
                                                            "",
                                                            Icons.group,
                                                            data![index]["teamsATP"]
                                                                .toString(),
                                                            Colors.blueAccent),
                                                        IconContainer(
                                                            "",
                                                            Icons.person_add,
                                                            data![index][
                                                            "JoindePersonTeamA"]
                                                                .toString(),
                                                            Colors.lightBlue),
                                                        IconContainer(
                                                            "",
                                                            Icons.group,
                                                            data![index]["teambTP"]
                                                                .toString(),
                                                            Colors.orange),
                                                        IconContainer(
                                                            "",
                                                            Icons.person_add,
                                                            data![index][
                                                            "JoindePersonTeamB"]
                                                                .toString(),
                                                            Colors.orangeAccent),
                                                      ],
                                                    )),
                                              ))
                                        ],
                                      )),
                                ],
                              ),
                            ),
                          ],
                        )
                      );
                    });
              },
            ),
          ),
        ),
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

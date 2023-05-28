import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../databaseManager/databaseManager.dart';
import '../../services/NotificationServices.dart';
import '../EventsDetailsScreen/tournamentJoinedTeams.dart';

class tournamentEventList extends StatefulWidget {
  const tournamentEventList({Key? key}) : super(key: key);

  @override
  State<tournamentEventList> createState() => _tournamentEventListState();
}

class _tournamentEventListState extends State<tournamentEventList> {
  var dbmanager = DatabaseManager();
  var loginUserid = "";
  var searchKey = "";

  Stream<QuerySnapshot> stream() async* {
    var firestore = FirebaseFirestore.instance;
    var _stream = firestore.collection('TourEvents').snapshots();
    yield* _stream;
  }

  Stream<QuerySnapshot> searchData(String string) async* {
    var stringg = string.toLowerCase();
    var firestore = FirebaseFirestore.instance;
    var _search = firestore
        .collection('TourEvents')
        .where('sports', isGreaterThanOrEqualTo: stringg)
        .where('sports', isLessThan: '${stringg}z')
        .snapshots();
    yield* _search;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    NotificationServices().getDeviceToken();
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //Serach bar
        Container(
          width: double.infinity,
          height: 80,
          color: Colors.white,
          child: Container(
            margin: EdgeInsets.all(8),
            height: 80,
            decoration: BoxDecoration(
              //color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 3,
                  blurRadius: 3,
                  offset: Offset(0, 0), // changes position of shadow
                ),
              ],
            ),
            child:
            TextField(
              onChanged: (value){
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
                ),),
          ),
        ),
        // body of screen
        Expanded(
          child: Container(
            child: StreamBuilder<QuerySnapshot>(
              stream: (searchKey != null || searchKey != "")
                  ? searchData(searchKey)
                  : stream(),
              builder: (context, snapshot){
                if(!snapshot.hasData) return const
                Text('loading ...');
                return ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: snapshot.data?.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      return snapshot.data?.docs[index]["approval"] == false
                          ? Spacer()
                          : InkWell(
                        onTap: (){
                          var authorId = snapshot.data?.docs[index]['eventAuthore'];
                          var eventIdd = snapshot.data?.docs[index].reference.id;
                          print("authore id : $authorId");
                          print("event id : $eventIdd");

                          Navigator.push(context,
                              MaterialPageRoute(
                                  builder: (context) => tournamentJoinedTeams(authoreId: authorId, eventID: eventIdd, role_status: true,)
                              )
                          );
                          },
                        child:  Container(
                          margin: EdgeInsets.all(8),
                          height: 150,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
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
                                        fit: BoxFit.fitHeight,
                                      ): Image.network(
                                        snapshot.data?.docs[index]['picture'],
                                        fit: BoxFit.fitHeight,
                                      )


                                  ),
                                ),
                              ),
                              Flexible(
                                  flex: 5,
                                  child: Column(
                                    children: [
                                      Flexible(
                                          flex: 2,
                                          child: Container(
                                            width: double.infinity,
                                            padding: EdgeInsets.only(left: 10, top: 15),
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
                                              child: Column(
                                                children: [
                                                  SizedBox(height: 5),
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons.sports,
                                                        color: Colors.orange,
                                                        size: 20.0,
                                                      ),
                                                      Text(snapshot.data?.docs[index]['sports'],
                                                          style: TextStyle(
                                                              color: Colors.grey[600],
                                                              fontSize: 13))

                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons.location_on_rounded,
                                                        color: Colors.red,
                                                        size: 20.0,
                                                      ),
                                                      Text(snapshot.data?.docs[index]['address'],
                                                          style: TextStyle(
                                                              color: Colors.grey[600],
                                                              fontSize: 13))

                                                    ],
                                                  )
                                                ],
                                              )
                                          )),
                                      Flexible(
                                          flex: 2,
                                          child: Container(
                                            //color: Colors.red,
                                            child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10.0, top: 5),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      height: 50,
                                                      width: 35,
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
                                                    SizedBox(width: 5,),
                                                    Container(
                                                      height: 50,
                                                      width: 35,
//color: Colors.green,
                                                      child: Column(
                                                        children:  <Widget>[
                                                          Icon(
                                                            Icons.timer,
                                                            color: Colors.black,
                                                            size: 20.0,
                                                          ),
                                                          Text(snapshot.data?.docs[index]['time'][0],
                                                              style: TextStyle(
                                                                  fontSize: 9)),
                                                        ],
                                                      ),

                                                    ),
                                                    SizedBox(width: 5,),
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
                                                          Text(snapshot.data?.docs[index]['totalTeams'],
                                                              style: TextStyle(
                                                                  fontSize: 9)),
                                                        ],
                                                      ),

                                                    ),
                                                    SizedBox(width: 5,),
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
                                                          Text('ss',
                                                              style: TextStyle(
                                                                  fontSize: 9)),
                                                        ],
                                                      ),

                                                    ),
                                                    SizedBox(width: 5,),
                                                    Tooltip(
                                                      message: "Winning Price",
                                                      child:  Container(
                                                        height: 50,
                                                        width: 35,


//color: Colors.green,
                                                        child: Column(
                                                          children:  <Widget>[
                                                            Icon(
                                                              Icons.military_tech_outlined,
                                                              color: Colors.yellow[800],
                                                              size: 20.0,
                                                            ),
                                                            Text(snapshot.data?.docs[index]['total_winning'] ?? "0",
                                                                style: TextStyle(
                                                                    fontSize: 9)),
                                                          ],
                                                        ),

                                                      ),
                                                    ),
                                                    SizedBox(width: 5,),
                                                    Container(
                                                      height: 50,
                                                      width: 35,
//color: Colors.green,
                                                      child: Column(
                                                        children:  <Widget>[
                                                          Icon(
                                                            Icons.attach_money,
                                                            color: Colors.green,
                                                            size: 20.0,
                                                          ),
                                                          Text(snapshot.data?.docs[index]['perhead'] ?? "0",
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
                            ],
                          ),
                        ),
                      );
                    });
              },
            ),
          ),
        )
      ],
    );
  }
}

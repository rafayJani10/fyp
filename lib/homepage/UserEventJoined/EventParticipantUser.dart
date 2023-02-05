
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../SideBar/SideMenuBar.dart';

class EventParticipant extends StatefulWidget {

  final List eventId;

  EventParticipant(this.eventId);

  @override
  State<EventParticipant> createState() => _EventParticipantState();
}

class _EventParticipantState extends State<EventParticipant> {


 Future getUserDataEnvoledInEvents() async {

 }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        //drawer: SideMenueBar(),
        appBar: AppBar(
          title: const Text("Event List"),
          backgroundColor: Colors.teal[900],
        ),
        body: ListView.builder(
            itemCount: widget.eventId.length,//myProjectId.length,
            itemBuilder: (BuildContext context, int index){
              return StreamBuilder(
                stream: FirebaseFirestore.instance.collection('users').doc(widget.eventId[index]).snapshots(),
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
                                          child: Image.network("https://img.freepik.com/premium-vector/anonymous-user-circle-icon-vector-illustration-flat-style-with-long-shadow_520826-1931.jpg?w=2000",  fit: BoxFit.fill)
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

    );


  }
}





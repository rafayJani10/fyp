import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../UIcomponents/UIcomponents.dart';
import '../../services/NotificationServices.dart';
import 'package:http/http.dart' as http;


class Approval_form extends StatefulWidget {

  final String? eventID;
   const Approval_form({super.key, required this.eventID});

  @override
  State<Approval_form> createState() => _Approval_formState();
}

class _Approval_formState extends State<Approval_form> {

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  var event_name = "";
  var event_address = "";
  var event_date = "";
  var event_time = "";
  var event_winning = "";
  var event_perhead = "";
  var event_authore_id = "";


  var authore_name = "";
  var authore_email = "";
  var authore_dept = "";
  var authore_phone_number = "";
  var authore_device_token = "";

  var notificationservices = NotificationServices();
  Future<DocumentSnapshot<Map<String, dynamic>>> getDocumentById(String documentId) {
    return firestore.collection('TourEvents').doc(documentId).get();
  }
  Future<DocumentSnapshot<Map<String, dynamic>>> AuthoreById(String documentId) {
    return firestore.collection('users').doc(documentId).get();
  }


  Future get_approval_event_detail() async{
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot = await getDocumentById(widget.eventID!);
    if (documentSnapshot.exists) {
      // Access the data using documentSnapshot.data()
      Map<String, dynamic>? data = documentSnapshot.data();
      // Process the data as needed
      setState(() {
        event_name = data!["name"];
        event_address = data["address"];
        event_date = data["date"];
        event_time = data["time"][0];
        event_winning = data["total_winning"];
        event_perhead = data["perhead"];
        event_authore_id = data["eventAuthore"];
      });
      get_event_authore_data();
    } else {
      // Document doesn't exist
      print("Document doesn't exist");
    }
  }

  Future get_event_authore_data() async{
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot = await AuthoreById(event_authore_id);
    if (documentSnapshot.exists) {
      // Access the data using documentSnapshot.data()
      Map<String, dynamic>? data = documentSnapshot.data();
      // Process the data as needed
      setState(() {
        authore_name = data!["fullname"];
        authore_dept = data["deptname"];
        authore_email = data["email"];
        authore_phone_number = data["phoneNumber"];
        authore_device_token = data["deviceToken"];
      });

    } else {
      // Document doesn't exist
      print("Document doesn't exist");
    }
  }

  Future approveEvent (String eventid) async{
    await FirebaseFirestore.instance.collection("TourEvents").doc(eventid).update(
        {
          'approval': true
        }).then((value) {
      showAlertDialog(context,'Success',"You approved this event.");
    }).onError((error, stackTrace) {
      showAlertDialog(context,'Success',error.toString());
    });
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get_approval_event_detail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        title:  Text("Approval Event Form"),
        backgroundColor: Colors.teal[900],

      ),
      body: Center(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(15),
              height: 180,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 6,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Column(
                children: [
                  Padding(padding: EdgeInsets.only(top: 10)),
                  Text('Author details', style: TextStyle(fontSize:20 ),),
                  Padding(padding: EdgeInsets.only(top: 10)),
                  Row(
                    children: [
                      Padding(padding: EdgeInsets.only(top: 20, left: 10)),
                      Text("Name : ",style: TextStyle(fontSize:16 ),),
                      Padding(padding: EdgeInsets.only(top: 20, left: 10)),
                      Text(authore_name,style: TextStyle(fontSize:16 ),)
                    ],
                  ),
                  Padding(padding: EdgeInsets.only(top: 10)),
                  Row(
                    children: [
                      Padding(padding: EdgeInsets.only(top: 20, left: 10)),
                      Text("Email : ",style: TextStyle(fontSize:16 ),),
                      Padding(padding: EdgeInsets.only(top: 20, left: 10)),
                      Text(authore_email,style: TextStyle(fontSize:16 ),)
                    ],
                  ),
                  Padding(padding: EdgeInsets.only(top: 10)),
                  Row(
                    children: [
                      Padding(padding: EdgeInsets.only(top: 20, left: 10)),
                      Text("Dept : ",style: TextStyle(fontSize:16 ),),
                      Padding(padding: EdgeInsets.only(top: 20, left: 10)),
                      Text(authore_dept,style: TextStyle(fontSize:16 ),)
                    ],
                  ),
                  Padding(padding: EdgeInsets.only(top: 10)),
                  Row(
                    children: [
                      Padding(padding: EdgeInsets.only(top: 20, left: 10)),
                      Text("Phone Number : ",style: TextStyle(fontSize:16 ),),
                      Padding(padding: EdgeInsets.only(top: 20, left: 10)),
                      Text(authore_phone_number,style: TextStyle(fontSize:16 ),)
                    ],
                  )
                ],
              )
            ),
            Container(
                margin: EdgeInsets.all(15),
                height: 250,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 6,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Padding(padding: EdgeInsets.only(top: 10)),
                    Text('Event details', style: TextStyle(fontSize:20 ),),
                    Padding(padding: EdgeInsets.only(top: 20)),
                    Row(
                      children: [
                        Padding(padding: EdgeInsets.only(top: 20, left: 10)),
                        Text("Name : ",style: TextStyle(fontSize:16 ),),
                        Padding(padding: EdgeInsets.only(top: 20, left: 10)),
                        Text(event_name,style: TextStyle(fontSize:16 ),)
                      ],
                    ),
                    Padding(padding: EdgeInsets.only(top: 10)),
                    Row(
                      children: [
                        Padding(padding: EdgeInsets.only(top: 10, left: 10)),
                        Text("Address : ",style: TextStyle(fontSize:16 ),),
                        Padding(padding: EdgeInsets.only(top: 10, left: 10)),
                        Text(event_address,style: TextStyle(fontSize:16 ),)
                      ],
                    ),
                    Padding(padding: EdgeInsets.only(top: 10)),
                    Row(
                      children: [
                        Padding(padding: EdgeInsets.only(top: 10, left: 10)),
                        Text("date : ",style: TextStyle(fontSize:16 ),),
                        Padding(padding: EdgeInsets.only(top: 10, left: 10)),
                        Text(event_date,style: TextStyle(fontSize:16 ),)
                      ],
                    ),
                    Padding(padding: EdgeInsets.only(top: 10)),
                    Row(
                      children: [
                        Padding(padding: EdgeInsets.only(top: 10, left: 10)),
                        Text("Time : ",style: TextStyle(fontSize:16 ),),
                        Padding(padding: EdgeInsets.only(top: 10, left: 10)),
                        Text(event_time,style: TextStyle(fontSize:16 ),)
                      ],
                    ),
                    Padding(padding: EdgeInsets.only(top: 10)),
                    Row(
                      children: [
                        Padding(padding: EdgeInsets.only(top: 10, left: 10)),
                        Text("Winning : ",style: TextStyle(fontSize:16 ),),
                        Padding(padding: EdgeInsets.only(top: 10, left: 10)),
                        Text(event_winning,style: TextStyle(fontSize:16 ),)
                      ],
                    ),
                    Padding(padding: EdgeInsets.only(top: 10)),
                    Row(
                      children: [
                        Padding(padding: EdgeInsets.only(top: 10, left: 10)),
                        Text("Perhead team : ",style: TextStyle(fontSize:16 ),),
                        Padding(padding: EdgeInsets.only(top: 10, left: 10)),
                        Text(event_perhead,style: TextStyle(fontSize:16 ),)


                      ],
                    )
                  ],
                )
            ),
            Container(
                margin: EdgeInsets.all(15),
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
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
                children: [
                  Flexible(
                      flex: 1,
                      child: InkWell(
                        onTap: () async {
                          print(authore_device_token);
                          var data = {
                            'to': authore_device_token,
                            'priority': 'high',
                            'notification' : {
                              'title' : 'Event Not Approved',
                              'body' : 'Admin does not approved your event which is name as $event_name'
                            }
                          };
                          await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
                              body: jsonEncode(data) ,
                              headers: {
                                'Content-Type' : 'application/json; character=UTF-8',
                                'Authorization' : 'key=AAAA4vnms68:APA91bHEf5AiZNGMPVT4jhpwG-ch-xibl1bHViNssWa21fYTsCCs0AMuLGPVqzDnhNOcwGTc_YvGrUqAyKSf2VU-jAJZ70I8J6vhHbZMd2WK898FjxZJ2pJAUv6H_MBF4-lUridh9q8P'
                              }
                          );

                        },
                        child: Container(
                            height: 50,
                            color: Colors.red,
                            child:Center(
                              child:  Text('Rejected the event',
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white
                                ),
                              ),
                            )
                        ),
                      )
                  ),
                  Container(
                    width: 20,
                  ),
                  Flexible(
                      flex: 1,
                      child:InkWell(
                        onTap: () async {
                          print("device token :::::::::::::::::::::");
                          print(authore_device_token);
                          approveEvent(widget.eventID!);
                          print(authore_device_token);
                          var data = {
                            'to': authore_device_token,
                            'priority': 'high',
                            'notification' : {
                              'title' : 'Event Approved',
                              'body' : 'Admin approved your event which is name as $event_name'
                            }
                          };
                          await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
                              body: jsonEncode(data) ,
                              headers: {
                                'Content-Type' : 'application/json; character=UTF-8',
                                'Authorization' : 'key=AAAA4vnms68:APA91bHEf5AiZNGMPVT4jhpwG-ch-xibl1bHViNssWa21fYTsCCs0AMuLGPVqzDnhNOcwGTc_YvGrUqAyKSf2VU-jAJZ70I8J6vhHbZMd2WK898FjxZJ2pJAUv6H_MBF4-lUridh9q8P'
                              }
                          );
                        },
                        child:  Container(
                            height: 50,
                            color: Colors.green,
                            child:Center(
                              child:  Text('Approved the event',
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white
                                ),
                              ),
                            )
                        ),
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}




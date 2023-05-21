import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../UIcomponents/UIcomponents.dart';
import '../../../databaseManager/databaseManager.dart';
import '../../homepage/EventsDetailsScreen/tournametEventDetails.dart';
import 'approvalEventForm.dart';

//??sssuuuu

class AdminApprovalList extends StatefulWidget {
  const AdminApprovalList({Key? key}) : super(key: key);

  @override
  State<AdminApprovalList> createState() => _AdminApprovalListState();
}

class _AdminApprovalListState extends State<AdminApprovalList> {
  var dbmanager = DatabaseManager();
  var loginUserid = "";

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        title:  Text("Approval Event"),
        backgroundColor: Colors.teal[900],

      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('TourEvents').snapshots(),
        builder: (context, snapshot){
          if(!snapshot.hasData) return const
          Text('loading ...');
          return ListView.builder(
              itemCount: snapshot.data?.docs.length,
              itemBuilder: (BuildContext context, int index) {
                if(snapshot.data?.docs[index]["approval"] == false){
                  return InkWell(
                    onTap: (){
                      print("");
                      Navigator.push(context,
                          MaterialPageRoute(
                              builder: (context) =>  Approval_form(eventID: snapshot.data?.docs[index].id)));
                    },
                    child:  Container(
                      margin: EdgeInsets.all(15),
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.6),
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
                                    //height: 150,
                                    fit: BoxFit.fitHeight,
                                  ): Image.network(
                                    snapshot.data?.docs[index]['picture'],
                                    //height: 150,
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
                                        //color: Colors.yellow,
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
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.location_on_rounded,
                                                color: Colors.red,
                                                size: 20.0,
                                              ),
                                              Text(snapshot.data?.docs[index]['address'],
                                                  style: TextStyle(
                                                      color: Colors.grey[800],
                                                      fontSize: 15))

                                            ],
                                          )
                                      )),
                                  Flexible(
                                      flex: 3,
                                      child: Container(
                                        //color: Colors.red,
                                        child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10.0, top: 15),
                                            child: Row(
                                              children: [
                                                Container(
                                                  height: 50,
                                                  width: 25,
//color: Colors.green,
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
                                                  width: 25,
//color: Colors.green,
                                                  child: Column(
                                                    children:  <Widget>[
                                                      Icon(
                                                        Icons.timer,
                                                        color: Colors.black,
                                                        size: 20.0,
                                                      ),
                                                      Text((snapshot.data?.docs[index]['time'][0]).toString() ?? "kk",

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
                                                      Text("0",
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
                                                    width: 25,
                                                    child: Column(
                                                      children:  <Widget>[
                                                        Icon(
                                                          Icons.military_tech_outlined,
                                                          color: Colors.yellow[800],
                                                          size: 20.0,
                                                        ),
                                                        Text(snapshot.data?.docs[index]['total_winning'] ,
                                                            style: TextStyle(
                                                                fontSize: 9)),
                                                      ],
                                                    ),

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
                                                        Icons.attach_money,
                                                        color: Colors.green,
                                                        size: 20.0,
                                                      ),
                                                      Text(snapshot.data?.docs[index]['perhead'],
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
                }else{
                  return Text("");
                }
              });
        },
      ),
    );
  }
}
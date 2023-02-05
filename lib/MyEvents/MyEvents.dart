import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fyp/databaseManager/databaseManager.dart';

import '../homepage/SideBar/SideMenuBar.dart';

class MyEvents extends StatefulWidget {
  const MyEvents({Key? key}) : super(key: key);

  @override
  State<MyEvents> createState() => _MyEventsState();
}

class _MyEventsState extends State<MyEvents> {

  var dbmanager = DatabaseManager();
  var myProjectId = [];
  Stream? stream ;

  get projectList => null;

  Future<dynamic> getUserData() async{
    var data =  await dbmanager.getData('userBioData');
    var daaa = json.decode(data);
    setState(() {
      print(daaa['prijects']);
      var projectList = daaa['prijects'];
      var projLength = projectList.length;
      print(projLength);
      for (var i = 0; i < projLength; i++) {
        print(i);
        myProjectId.add(projectList[i]);
        print(myProjectId);

        //stream = FirebaseFirestore.instance.collection('events').doc(projectList[i]).snapshots();
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    //var myevents = myProjectId.length;
    return Scaffold(
        //drawer: SideMenueBar(),
        appBar: AppBar(
          title: const Text("My Event List"),
          backgroundColor: Colors.teal[900],
        ),
        body: ListView.builder(
           itemCount: myProjectId.length,
            itemBuilder: (BuildContext context, int index){
             return StreamBuilder(
               stream: FirebaseFirestore.instance.collection('events').doc(myProjectId[index]).snapshots(),
               builder: (context, snapshot){
                 if (snapshot.data == null ) {
                   return Center(child: Text('NO DATA'));
                 }
                 return Container(
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
                               child: snapshot.data?['picture'] == "" ?  Image.network("https://t3.ftcdn.net/jpg/02/48/42/64/360_F_248426448_NVKLywWqArG2ADUxDq6QprtIzsF82dMF.jpg",
                                 //height: 150,
                                 fit: BoxFit.fitHeight,
                               ): Image.network(
                                 snapshot.data?['picture'],
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
                                     child: Text(snapshot.data?['name'],
                                         style: TextStyle(
                                             color: Colors.grey[800],
                                             fontWeight: FontWeight.bold,
                                             fontSize: 25)),
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
                                           Text(snapshot.data?['address'],
                                               style: TextStyle(
                                                   color: Colors.grey[800],
                                                   fontSize: 12))

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
                                               width: 45,
//color: Colors.green,
                                               child: Column(
                                                 children:  <Widget>[
                                                   Icon(
                                                     Icons.calendar_month,
                                                     color: Colors.grey,
                                                     size: 30.0,
                                                   ),
                                                   Text(snapshot.data?['date'],
                                                       style: TextStyle(
                                                           fontSize: 7)),
                                                 ],
                                               ),

                                             ),
                                             Container(
                                               height: 50,
                                               width: 45,
//color: Colors.green,
                                               child: Column(
                                                 children:  <Widget>[
                                                   Icon(
                                                     Icons.timer,
                                                     color: Colors.black,
                                                     size: 30.0,
                                                   ),
                                                   Text(snapshot.data?['time'],
                                                       style: TextStyle(
                                                           fontSize: 9)),
                                                 ],
                                               ),

                                             ),
                                             Container(
                                               height: 50,
                                               width: 45,
//color: Colors.green,
                                               child: Column(
                                                 children:  <Widget>[
                                                   Icon(
                                                     Icons.person,
                                                     color: Colors.black,
                                                     size: 30.0,
                                                   ),
                                                   Text(snapshot.data?['totalperso'],
                                                       style: TextStyle(
                                                           fontSize: 9)),
                                                 ],
                                               ),

                                             ),
                                             Container(
                                               height: 50,
                                               width: 45,
//color: Colors.green,
                                               child: Column(
                                                 children:  <Widget>[
                                                   Icon(
                                                     Icons.person_add,
                                                     color: Colors.green,
                                                     size: 30.0,
                                                   ),
                                                   Text((snapshot.data?['TjoinPerson']).toString(),
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
                 );
               },
             );
            }
        )

    );
  }
}

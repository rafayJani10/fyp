import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../databaseManager/databaseManager.dart';
import '../../homepage/EventsDetailsScreen/tournamentJoinedTeams.dart';


class MytournamentEventList extends StatefulWidget {
  const MytournamentEventList({Key? key}) : super(key: key);

  @override
  State<MytournamentEventList> createState() => _MytournamentEventListState();
}

class _MytournamentEventListState extends State<MytournamentEventList> {
  var dbmanager = DatabaseManager();
  var myTournamentId = [];
  var _isLoading = true;
  var _isNoDataAlert = false;


  Future<dynamic> getUserDataTour() async{
    var data =  await dbmanager.getData('userBioData');
    var daaa = json.decode(data);
    var userid = daaa['id'];
    var collection = FirebaseFirestore.instance.collection('users');
    var docSnapshot = await collection.doc(userid).get();
    if (docSnapshot.exists) {
      Map<String, dynamic>? data = docSnapshot.data();
      var projectList = data?['TourProjects'];
      setState(()  {
        var projLength = projectList.length;
        print(projLength);
        for (var i = 0; i < projLength; i++) {
          myTournamentId.add(projectList[i]);
          print(myTournamentId);
        }
        _isLoading = false;
        if(myTournamentId.isEmpty){
          _isNoDataAlert = true;
        }
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserDataTour();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //drawer: SideMenueBar(),
        body:
         Stack(children: [
           ListView.builder(
               itemCount: myTournamentId.length,
               itemBuilder: (BuildContext context, int index){
                 return StreamBuilder(
                   stream: FirebaseFirestore.instance.collection('TourEvents').doc(myTournamentId[index]).snapshots(),
                   builder: (context, snapshot){
                     if(snapshot.hasData){
                       return InkWell(
                         onTap: (){
                           var authorId = snapshot.data?['eventAuthore'];
                           var eventIdd = snapshot.data?.reference.id;
                           //var joinedUserList = snapshot.data?['joinedUserList'];
                           print(authorId);
                           print(eventIdd);
                           Navigator.push(context,
                               MaterialPageRoute(
                                   builder: (context) => tournamentJoinedTeams(authoreId: authorId, eventID: eventIdd,role_status: false)
                               )
                           );
                         },
                         child:  Container(
                           margin: EdgeInsets.all(15),
                           width: double.infinity,
                           height: 150,
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
                           child: Stack(
                             children: [
                               Row(
                                 children: <Widget>[
                                   Flexible(
                                     flex: 3,
                                     child: SizedBox(
                                       height: 130,
                                       child: Center(
                                           child: snapshot.data?['picture'] == "" ?  Image.network("https://firebasestorage.googleapis.com/v0/b/bukc-sports-hub.appspot.com/o/imgPh.jpeg?alt=media&token=e41c5f50-8ccb-4276-9538-bacf349f24ba",
                                             fit: BoxFit.fitHeight,
                                           ): Image.network(
                                             snapshot.data?['picture'],
                                             fit: BoxFit.fitHeight,
                                           )
                                       ),
                                     ),
                                   ),
                                   Flexible(
                                       flex: 9,
                                       child: Column(
                                         children: [
                                           Flexible(
                                               flex: 2,
                                               child: Container(
                                                 //color: Colors.red,
                                                 width: double.infinity,
                                                 padding: EdgeInsets.only(left: 10, top: 10),
//color: Colors.yellow,
                                                 height: 50,
                                                 child: Text(snapshot.data?['name'],
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
                                                   padding: EdgeInsets.only(left: 5),
                                                   child: Row(
                                                     children: [
                                                       const Icon(
                                                         Icons.location_on_rounded,
                                                         color: Colors.red,
                                                         size: 20.0,
                                                       ),
                                                       Text(snapshot.data?['address'],
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
                                                         left: 25.0, top: 15),
                                                     child: Row(
                                                       children: [
                                                         Container(
                                                           height: 50,
                                                           width: 45,
                                                           child: Column(
                                                             children:  <Widget>[
                                                               Icon(
                                                                 Icons.calendar_month,
                                                                 color: Colors.grey,
                                                                 size: 20.0,
                                                               ),
                                                               Text(snapshot.data?['date'],
                                                                   maxLines: 2,
                                                                   style: TextStyle(
                                                                       fontSize: 9)),
                                                             ],
                                                           ),

                                                         ),
                                                         SizedBox(width: 8,),
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
                                                               Text(snapshot.data?['time'][0],
                                                                   style: TextStyle(
                                                                       fontSize: 9)),
                                                             ],
                                                           ),

                                                         ),
                                                         SizedBox(width: 8,),
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
                                                               Text(snapshot.data?['totalTeams'],
                                                                   style: TextStyle(
                                                                       fontSize: 9)),
                                                             ],
                                                           ),

                                                         ),
                                                         SizedBox(width: 8,),
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
                                                               Text("100",
                                                                   // (snapshot.data?['joinedUserList'].length).toString(),
                                                                   style: TextStyle(
                                                                       fontSize: 9)),
                                                             ],
                                                           ),

                                                         ),
                                                         SizedBox(width: 8,),
                                                         Tooltip(
                                                           message: "Winning Price",
                                                           child:  Container(
                                                             height: 50,
                                                             width: 25,


//color: Colors.green,
                                                             child: Column(
                                                               children:  <Widget>[
                                                                 Icon(
                                                                   Icons.military_tech_outlined,
                                                                   color: Colors.yellow[800],
                                                                   size: 20.0,
                                                                 ),
                                                                 Text("2000",
                                                                     style: TextStyle(
                                                                         fontSize: 9)),
                                                               ],
                                                             ),

                                                           ),
                                                         ),
                                                         SizedBox(width: 8,),
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
                                                               Text("1000",
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
                               Align(
                                 alignment: Alignment.topRight,
                                 child: Container(
                                   height: 30,
                                   width: 80,
                                   color: snapshot.data?['approval']! == true ? Colors.green : Colors.red,
                                   child: Center(
                                     child: Text(snapshot.data?['approval']! == true ? 'Approved' : 'Not Approved',
                                       style: TextStyle(fontSize: 10, color: Colors.white),),
                                   ),
                                 ),
                               )
                             ],
                           ),
                         ),
                       );
                     }
                     return SizedBox();
                   },
                 );
               }
           ),
          Visibility(visible: _isLoading,child: const Center(child: CircularProgressIndicator(),),),
          Visibility(visible: _isNoDataAlert,child: Center(
            child: Container(
              height: 400,
              width: 300,
              //color: Colors.teal,
              child: Column(
                children: [
                  Container(
                    height: 300,
                    width: 300,
                    child: Image.asset('assets/images/no_data.png'),
                  ),
                  SizedBox(height: 40,),
                  Text("No data Found", style: TextStyle(fontSize: 20,  color: Colors.grey),)
                ],
              ),
            ),
          ))

         ],)
    );
  }
}



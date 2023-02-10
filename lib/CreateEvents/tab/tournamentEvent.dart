import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fyp/databaseManager/databaseManager.dart';
import '../../UIcomponents/UIcomponents.dart';


class tournamentEvent extends StatefulWidget {
  const tournamentEvent({Key? key}) : super(key: key);

  @override
  State<tournamentEvent> createState() => _tournamentEventState();
}

class _tournamentEventState extends State<tournamentEvent> {
  var dbmanager = DatabaseManager();
  var date = "Pick a Date";
  var time = "Pick  Time";
  var userList = [];
  var EventAuthor = "";
  var selectedLocation = "Table Tennis Area";
  var selectedsports = "Table Tennis";
  var teamAlist = [];
  var selectedTp = "2";
  var selectteamss = "4";
  List<DropdownMenuItem<String>>? totalPersonDropDownList = [];

  TextEditingController eventNameController = TextEditingController();
  TextEditingController totalPersonTeamA = TextEditingController();
  TextEditingController totalPersonTeamB = TextEditingController();


  List<DropdownMenuItem<String>> get locationList{
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("Table Tennis Area"),value: "Table Tennis Area"),
      DropdownMenuItem(child: Text("Foot Ball Ground"),value: "Foot Ball Ground"),
      DropdownMenuItem(child: Text("Bedminton Area"),value: "Bedminton Area"),
      DropdownMenuItem(child: Text("Basket Ball Area"),value: "Basket Ball Area"),
    ];
    return menuItems;
  }

  List<DropdownMenuItem<String>> get sportsList{
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("Table Tennis"),value: "Table Tennis"),
      DropdownMenuItem(child: Text("futsul"),value: "futsul"),
      DropdownMenuItem(child: Text("cricket"),value: "cricket"),
      DropdownMenuItem(child: Text("bedminton"),value: "bedminton"),
      DropdownMenuItem(child: Text("Volley Ball"),value: "Volley Ball"),
      DropdownMenuItem(child: Text("Basket Ball"),value: "Basket Ball")
    ];
    return menuItems;
  }
  List<DropdownMenuItem<String>> get selectedTotalPerson{
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("2"),value: "2"),
      DropdownMenuItem(child: Text("3"),value: "3"),
      DropdownMenuItem(child: Text("4"),value: "4"),
      DropdownMenuItem(child: Text("5"),value: "5"),
      DropdownMenuItem(child: Text("6"),value: "6"),
      DropdownMenuItem(child: Text("11"),value: "11"),
    ];
    return menuItems;
  }
  List<DropdownMenuItem<String>> get selectteams{
    List<DropdownMenuItem<String>> menuItems = [

      DropdownMenuItem(child: Text("4"),value: "4"),
      DropdownMenuItem(child: Text("6"),value: "6"),
      DropdownMenuItem(child: Text("8"),value: "8"),
    ];
    return menuItems;
  }


  Future<dynamic> getUserData() async{
    var data =  await dbmanager.getData('userBioData');
    var daaa = json.decode(data);
    setState(() {
      EventAuthor = daaa['id'];
      print(EventAuthor);
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
    return Center(
      child: Column(
        children: <Widget>[
          Padding(padding: EdgeInsets.only(top: 35)),
          Padding(
              padding: EdgeInsets.all(8.0),
              child:  TextField(
                obscureText: false,
                controller: eventNameController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintStyle: TextStyle(
                        color: Colors.black
                    ),
                    labelStyle:  TextStyle(
                        color: Colors.black
                    ),
                    labelText: 'Tournament Name',
                    hintText: "Enter Tournament  Name"
                ),
              )
          ),
          Padding(
              padding: EdgeInsets.all(8.0),
              child:  Container(
                width: double.infinity,
                height: 60,
                //color: Colors.red,
                child: Row(
                  children: [
                    Flexible(
                        flex: 1,
                        child: Container(
                            height: 60,
                            //color: Colors.teal,
                            child: Center(
                              child: Text(
                                "Select Sports Area"
                              ),
                            )
                        )),
                    // SizedBox(width: 10,),
                    Flexible(
                        flex: 1,
                        child: Container(
                          height: 60,
                          //color: Colors.blue,
                          child:  Center(
                            child:  DropdownButton(
                              value: selectedLocation,
                              items: locationList,
                              onChanged: (String? value) {
                                setState(() {
                                  selectedLocation = value!;
                                });
                              },
                            ),
                          )
                        ))
                  ],
                ),
              )
          ),
          Padding(
              padding: EdgeInsets.all(8.0),
              child:  Container(
                width: double.infinity,
                height: 60,
                //color: Colors.red,
                child: Row(
                  children: [
                    Flexible(
                        flex: 1,
                        child: Container(
                            height: 60,
                            //color: Colors.teal,
                            child: Center(
                              child: Text(
                                  "Select Sports"
                              ),
                            )
                        )),
                    // SizedBox(width: 10,),
                    Flexible(
                        flex: 1,
                        child: Container(
                          height: 60,
                          //color: Colors.blue,
                          child:  Center(
                            child:  DropdownButton(
                              value: selectedsports,
                              items: sportsList,
                              onChanged: (String? value) {
                                setState(() {
                                  selectedsports = value!;

                                });
                              },
                            ),
                          ),
                        ))
                  ],
                ),
              )
          ),
          Padding(
              padding: EdgeInsets.all(8.0),
              child:  Container(
                width: double.infinity,
                height: 60,
                //color: Colors.red,
                child: Row(
                  children: [
                    Flexible(
                        flex: 1,
                        child: Container(
                            height: 60,
                            //color: Colors.teal,
                            child: Center(
                              child: Text(
                                  "Number of Players"
                              ),
                            )
                        )),

                   Flexible(
                      flex: 1,
                      //color: Colors.blue,
                      child:  Center(
                        child:  DropdownButton(
                          value: selectedTp,
                          items: selectedTotalPerson,
                          onChanged: (String? value) {
                            setState(() {
                              selectedTp = value!;

                            });
                          },
                        ),
                      ),
                    ),

    ],
    )

              )
          ),

          // Padding(
          //     padding: EdgeInsets.all(8.0),
          //     child:  TextField(
          //      // enabled: false,
          //       controller: totalPersonTeamA,
          //       obscureText: false,
          //       decoration: InputDecoration(
          //           border: OutlineInputBorder(),
          //           hintStyle: TextStyle(
          //               color: Colors.black
          //           ),
          //           labelStyle:  TextStyle(
          //               color: Colors.black
          //           ),
          //           labelText: 'Team A total Person',
          //           hintText: "Enter Team A total Personn"
          //       ),
          //     )
          // ),
          // Padding(
          //     padding: EdgeInsets.all(8.0),
          //     child:  TextField(
          //       controller: totalPersonTeamB,
          //       obscureText: false,
          //       decoration: InputDecoration(
          //           border: OutlineInputBorder(),
          //           hintStyle: TextStyle(
          //               color: Colors.black
          //           ),
          //           labelStyle:  TextStyle(
          //               color: Colors.black
          //           ),
          //           labelText: 'Team B total Person',
          //           hintText: "Enter Team B total Personn"
          //       ),
          //     )
          // ),

          Padding(
              padding: EdgeInsets.all(8.0),
              child:  Container(
                width: double.infinity,
                height: 60,
                //color: Colors.red,
                child: Row(
                  children: [
                    Flexible(
                        flex: 1,
                        child: Container(
                            height: 60,
                            //color: Colors.teal,
                            child: Center(
                              child: Text(
                                  "Number of Teams"
                              ),
                            )
                        )),
                    // SizedBox(width: 10,),
                    Flexible(
                        flex: 1,
                        child: Container(
                            height: 60,
                            //color: Colors.blue,
                            child:  Center(
                              child:  DropdownButton(
                                value: selectteamss,
                                items: selectteams,
                                onChanged: (String? value) {
                                  setState(() {
                                    selectteamss = value!;
                                  });
                                },
                              ),
                            )
                        ))
                  ],
                ),
              )
          ),
          Padding(
              padding: EdgeInsets.all(8.0),
              child:  Container(
                //padding: EdgeInsets.all(8.0),
                height: 50,
                width: double.infinity,
                child: Row(
                  children: [
                    Flexible(
                      flex: 1,
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: Colors.black,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Flexible(
                              flex: 3,
                              child: Container(
                                height: 50,
                                //color: Colors.green,
                                //color: Colors.green,
                                child: Center(child: Text(date)),
                              ),),
                            Flexible(
                                flex: 1,
                                child: InkWell(
                                  onTap: () async{
                                    DateTime? datePicked =  await  showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2011),
                                      lastDate: DateTime(2030),
                                    );
                                    if(datePicked != null){
                                      print("${datePicked.day}/${datePicked.month}/${datePicked.year}");
                                      var formattDate = "${datePicked.day}/${datePicked.month}/${datePicked.year}";
                                      setState(() {
                                        date = formattDate;
                                      });
                                    }
                                  },
                                  child: Container(
                                    height: 50,
                                    child: const Center(
                                        child: Icon(
                                            Icons.calendar_month_sharp
                                        )
                                    ),
                                  ),
                                )
                            ),
                          ],
                        ),
                        //color: Colors.green,
                      ),
                    ),
                    SizedBox(width: 10,),
                    Flexible(
                      flex: 1,
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: Colors.black,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Flexible(
                              flex: 3,
                              child: Container(
                                height: 50,
                                child:Center(child: Text(time)),
                                //color: Colors.green,
                                //color: Colors.green,

                              ),),
                            Flexible(
                                flex: 1,
                                child: InkWell(
                                  onTap: () async{
                                    TimeOfDay? pickedtime = await showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                      initialEntryMode: TimePickerEntryMode.dial,
                                    );
                                    if(pickedtime != null){
                                      print("${pickedtime.hour}:${pickedtime.minute}");
                                      var formatTime = "${pickedtime.hour}:${pickedtime.minute}";
                                      setState(() {
                                        time = formatTime;
                                      });
                                    }
                                  },

                                  child: Container(
                                    height: 50,
                                    //color: Colors.red,
                                    //color: Colors.green,
                                    child: const Center(
                                        child: Icon(
                                            Icons.timer
                                        )
                                    ),
                                  ),
                                )
                            ),
                          ],
                        ),
                        //color: Colors.green,
                      ),
                    ),


                  ],

                ),
              )
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.teal[900],
              onPrimary: Colors.white,
              shadowColor: Colors.green,
              elevation: 6,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32.0)),
            ),
            onPressed: () async{
              var sportsImage = "";
              if (selectedsports == "Table Tennis"){
                setState(() {
                  sportsImage = "https://firebasestorage.googleapis.com/v0/b/bukc-sports-hub.appspot.com/o/360_F_303275863_EWavqozgkXmiSNoz3zKXoQKcZcGJoGyt.jpeg?alt=media&token=6de2de47-246e-43ac-81d6-4bde71ea869b";
                });
              }else if (selectedsports == "futsul"){
                setState(() {
                  sportsImage = "https://firebasestorage.googleapis.com/v0/b/bukc-sports-hub.appspot.com/o/soccer-ball-design_1818040.jpeg?alt=media&token=735416c8-6e71-41c8-92b5-b963c628ea8a";
                });
              }else if (selectedsports == "cricket"){
                setState(() {
                  sportsImage = "https://firebasestorage.googleapis.com/v0/b/bukc-sports-hub.appspot.com/o/cricket.jpeg?alt=media&token=d04e57c6-3d39-4733-a164-15e7fbe3d9df";
                });
              }else if (selectedsports == "bedminton"){
                setState(() {
                  sportsImage = "https://firebasestorage.googleapis.com/v0/b/bukc-sports-hub.appspot.com/o/360_F_239265142_41Z8WiZDNdGsjVhcK4IGE2EFnZSJxfxs.jpeg?alt=media&token=9459d5c5-cab4-4864-99b0-4bb5a5e1e79e";
                });
              }else{
                setState(() {
                  sportsImage = "https://firebasestorage.googleapis.com/v0/b/bukc-sports-hub.appspot.com/o/sport-logo-free-vector.jpeg?alt=media&token=05274441-cbe9-4ec7-b1f7-15b16765ec0f";
                });
              }
              setState(() {
                teamAlist.add(EventAuthor);
              });
              var eventCreate = await dbmanager.createFriendlyEventData(EventAuthor,eventNameController.text,selectedLocation,selectedsports,sportsImage, time, date, selectedTp, selectedTp,1,0,teamAlist);
              if(eventCreate == true){
                showAlertDialog(context,"Done","Event created successfully");
              }else{
                showAlertDialog(context,"Error","Event Not created");
              }
            },
            child: Text('Create Event'),
          ),
        ],
      ),
    );
  }
}

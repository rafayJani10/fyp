import 'dart:convert';
import 'dart:core';
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fyp/databaseManager/databaseManager.dart';
import '../../UIcomponents/UIcomponents.dart';
import 'package:http/http.dart' as http;

class friendlyEvent extends StatefulWidget {
  const friendlyEvent({Key? key}) : super(key: key);

  @override
  State<friendlyEvent> createState() => _friendlyEventState();
}

class _friendlyEventState extends State<friendlyEvent> {
  var dbmanager = DatabaseManager();
  var firebasestore = FirebaseFirestore.instance;
  var date = "Pick a Date";
  var time = [];
  var login_user_phone_no = "";
  var login_user_dept = "";
  var userList = [];
  var EventAuthor = "";
  var selectedLocation = "Table Tennis Area";
  var selectedsports = "Table Tennis";
  var teamAlist = [];
  var selectedTp = "2";
  var tteams = "2";
  var deviceToken = "";

  var timeSlotsList = ['9-10 am','10-11 am','11-12 am','12-1 pm','3-4 pm','4-5 pm'];
  var userSelectedTime = [];
  var _isloading = false;

  List<Map<String, dynamic>> timeSlotModelList = [
    {'time': '9-10 am', 'isBooked': false},
    {'time': '10-11 am', 'isBooked': false},
    {'time': '11-12 am', 'isBooked': false},
    {'time': '12-1 pm', 'isBooked': false},
    {'time': '3-4 pm', 'isBooked': false},
    {'time': '4-5 pm', 'isBooked': false}
  ];
  List<DropdownMenuItem<String>>? totalPersonDropDownList = [];
  TextEditingController eventNameController = TextEditingController();
  TextEditingController totalPersonTeamA = TextEditingController();
  TextEditingController totalPersonTeamB = TextEditingController();

  List<DropdownMenuItem<String>> get locationList {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(
          child: Text("Table Tennis Area"), value: "Table Tennis Area"),
      DropdownMenuItem(
          child: Text("Foot Ball Ground"), value: "Foot Ball Ground"),
      DropdownMenuItem(child: Text("Bedminton Area"), value: "Bedminton Area"),
      DropdownMenuItem(
          child: Text("Basket Ball Area"), value: "Basket Ball Area"),
    ];
    return menuItems;
  }
  List<DropdownMenuItem<String>> get sportsList {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("Table Tennis"), value: "Table Tennis"),
      DropdownMenuItem(child: Text("Futsul"), value: "Futsul"),
      DropdownMenuItem(child: Text("Cricket"), value: "Cricket"),
      DropdownMenuItem(child: Text("Bedminton"), value: "Bedminton"),
      DropdownMenuItem(child: Text("Volley Ball"), value: "Volley Ball"),
      DropdownMenuItem(child: Text("Basket Ball"), value: "Basket Ball")
    ];
    return menuItems;
  }
  List<DropdownMenuItem<String>> get selectedTotalPerson {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("2"), value: "2"),
      DropdownMenuItem(child: Text("3"), value: "3"),
      DropdownMenuItem(child: Text("4"), value: "4"),
      DropdownMenuItem(child: Text("5"), value: "5"),
      DropdownMenuItem(child: Text("6"), value: "6"),
      DropdownMenuItem(child: Text("11"), value: "11"),
    ];
    return menuItems;
  }
  List<DropdownMenuItem<String>> get teams {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("2"), value: "2"),
    ];
    return menuItems;
  }


  Future<dynamic> getUserData() async {
    var data = await dbmanager.getData('userBioData');
    var daaa = json.decode(data);
    setState(() {
      EventAuthor = daaa['id'];
      login_user_dept = daaa['deptname'];
      login_user_phone_no = daaa['phoneNumber'];
      print(EventAuthor);
    });
  }
  Future getTimeSlot() async{
    var docsnapshot = await firebasestore.collection('timeSlots').get();
    print(docsnapshot.docs.length);
    for (var i in docsnapshot.docs){
      print(i.data().values.last);
    }
  }
  Future CheckTheTimeSlots() async{
    final collectionReference = FirebaseFirestore.instance.collection('events');
    final querySnapshot = await collectionReference
        .where('date', isEqualTo: date)
        .where('sports', isEqualTo: selectedsports)
        .get();

    if (querySnapshot.size > 0) {
      for (final document in querySnapshot.docs) {
        final timeList = List<String>.from(document.get('time') as List<dynamic>);
        print(timeList);
        for (var i in timeList){
          if (timeSlotsList.contains(i)){
            print('existing time is $i');
            setState(() {
              timeSlotsList.remove(i);
            });
          }
        }
      }
    } else {
      // No documents found with matching date and game
      print('no date and sports match on same day');
      setState(() {
        timeSlotsList = ['9-10 am','10-11 am','11-12 am','12-1 pm','3-4 pm','4-5 pm'];
      });
    }
  }
  clearTextInput() {
    setState(() {
      eventNameController.clear();
      timeSlotsList = ['9-10 am','10-11 am','11-12 am','12-1 pm','3-4 pm','4-5 pm'];
      date = "Pick a Date";
    });
  }
  Future getAdminDeviceToken()async{
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .get();

    querySnapshot.docs.forEach((doc) {
      final roles = doc.get('roles');
      print(roles);
      // prints the name value of each document in the "users" collection
      if(roles == -1){
        setState(() {
          deviceToken = doc.get('deviceToken');
        });
        print(deviceToken);

      }else{
        print('sorry no admin found');
      }
      print("device token ::::::::: $deviceToken");
      //print(authorName);
    });
  }




  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
    getTimeSlot();
    getAdminDeviceToken();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Stack(
          children: [
            Column(
              children: <Widget>[
                Padding(padding: EdgeInsets.only(top: 35)),
                Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextField(
                      obscureText: false,
                      controller: eventNameController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintStyle: TextStyle(color: Colors.black),
                          labelStyle: TextStyle(color: Colors.black),
                          labelText: 'Event Name',
                          hintText: "Enter Event Name"),
                    )),
                Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Container(
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
                                    child: Text("Select Sports"),
                                  ))),
                          // SizedBox(width: 10,),
                          Flexible(
                              flex: 1,
                              child: Container(
                                height: 60,
                                //color: Colors.blue,
                                child: Center(
                                  child: DropdownButton(
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
                    )),
                Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Container(
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
                                    child: Text("Select Sports Area"),
                                  ))),
                          // SizedBox(width: 10,),
                          Flexible(
                              flex: 1,
                              child: Container(
                                  height: 60,
                                  //color: Colors.blue,
                                  child: Center(
                                    child: DropdownButton(
                                      value: selectedLocation,
                                      items: locationList,
                                      onChanged: (String? value) {
                                        setState(() {
                                          selectedLocation = value!;
                                        });
                                      },
                                    ),
                                  )))
                        ],
                      ),
                    )),
                Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Container(
                        width: double.infinity,
                        height: 60,
                        child: Row(
                          children: [
                            Flexible(
                                flex: 1,
                                child: Container(
                                    height: 60,
                                    //color: Colors.teal,
                                    child: Center(
                                      child: Text("Number of Players"),
                                    ))),
                            Flexible(
                              flex: 1,
                              //color: Colors.blue,
                              child: Center(
                                child: DropdownButton(
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
                        ))),
                Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Container(
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
                                      child: Text("Number of teams"),
                                    ))),
                            Flexible(
                              flex: 1,
                              //color: Colors.blue,
                              child: Center(
                                child: DropdownButton(
                                  value: tteams,
                                  items: teams,
                                  onChanged: (String? value) {
                                    setState(() {
                                      tteams = value!;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ))),
                Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Container(
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
                                      child: Center(child: Text(date)),
                                    ),
                                  ),
                                  Flexible(
                                      flex: 1,
                                      child: InkWell(
                                        onTap: () async {
                                          DateTime? datePicked = await showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime.now(),
                                            lastDate: DateTime(2030),
                                          );
                                          if (datePicked != null) {
                                            print(
                                                "${datePicked.day}/${datePicked
                                                    .month}/${datePicked.year}");
                                            var formattDate =
                                                "${datePicked.day}/${datePicked
                                                .month}/${datePicked.year}";
                                            setState(() {
                                              date = formattDate;
                                            });
                                            CheckTheTimeSlots();


                                          }
                                        },
                                        child: Container(
                                          height: 50,
                                          child: const Center(
                                              child:
                                              Icon(Icons.calendar_month_sharp)),
                                        ),
                                      )),
                                ],
                              ),
                              //color: Colors.green,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
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
                                      child: Center(child: Text('Pick a time')),
                                    ),
                                  ),
                                  Flexible(
                                      flex: 1,
                                      child: InkWell(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            barrierDismissible: false,
                                            builder: (BuildContext context) {
                                              return TimeSlotsDialog(timeSlotsList,userSelectedTime,
                                                      (value, index) {
                                                    // setState(() {
                                                    //   timeSlotModelList[index]['isBooked'] = value;
                                                    // });
                                                  });
                                            },
                                          );
                                        },
                                        child: Container(
                                          height: 50,
                                          child:
                                          const Center(child: Icon(Icons.timer)),
                                        ),
                                      )),
                                ],
                              ),
                              //color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    )),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.teal[900],
                    onPrimary: Colors.white,
                    shadowColor: Colors.green,
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32.0)),
                  ),
                  onPressed: () async {
                    setState(() {
                      _isloading = true;
                    });
                    if(login_user_phone_no == "" || login_user_dept == ""){
                      showAlertDialog(context, "Error", "Kindlu update your profile");
                      setState(() {
                        _isloading = false;
                      });

                    }else{
                      var sportsImage = "";
                      if (selectedsports == "Table Tennis") {
                        setState(() {
                          sportsImage =
                          "https://firebasestorage.googleapis.com/v0/b/bukc-sports-hub.appspot.com/o/360_F_303275863_EWavqozgkXmiSNoz3zKXoQKcZcGJoGyt.jpeg?alt=media&token=6de2de47-246e-43ac-81d6-4bde71ea869b";
                        });
                      } else if (selectedsports == "Futsul") {
                        setState(() {
                          sportsImage =
                          "https://firebasestorage.googleapis.com/v0/b/bukc-sports-hub.appspot.com/o/soccer-ball-design_1818040.jpeg?alt=media&token=735416c8-6e71-41c8-92b5-b963c628ea8a";
                        });
                      } else if (selectedsports == "Cricket") {
                        setState(() {
                          sportsImage =
                          "https://firebasestorage.googleapis.com/v0/b/bukc-sports-hub.appspot.com/o/cricket.jpeg?alt=media&token=d04e57c6-3d39-4733-a164-15e7fbe3d9df";
                        });
                      } else if (selectedsports == "Bedminton") {
                        setState(() {
                          sportsImage =
                          "https://firebasestorage.googleapis.com/v0/b/bukc-sports-hub.appspot.com/o/360_F_239265142_41Z8WiZDNdGsjVhcK4IGE2EFnZSJxfxs.jpeg?alt=media&token=9459d5c5-cab4-4864-99b0-4bb5a5e1e79e";
                        });
                      } else {
                        setState(() {
                          sportsImage =
                          "https://firebasestorage.googleapis.com/v0/b/bukc-sports-hub.appspot.com/o/sport-logo-free-vector.jpeg?alt=media&token=05274441-cbe9-4ec7-b1f7-15b16765ec0f";
                        });
                      }
                      setState(() {
                        teamAlist.add(EventAuthor);
                      });

                      if (eventNameController.text == "Event Name" ||
                          userSelectedTime == null ||
                          date == "Pick a Date") {
                        showAlertDialog(context, "Error", "Kindly add all event info");
                        setState(() {
                          _isloading = false;
                        });
                      } else {
                        var eventCreate = await dbmanager.createFriendlyEventData(
                            EventAuthor,
                            eventNameController.text,
                            selectedLocation,
                            selectedsports,
                            sportsImage,
                            userSelectedTime,
                            date,
                            selectedTp,
                            selectedTp,
                            1,
                            0,
                            teamAlist);
                        if (eventCreate == true) {
                          setState(() {
                            _isloading = false;
                          });
                          showAlertDialog(
                              context, "Done", "Event created successfully");

                          clearTextInput();
                          var data = {
                            'to': deviceToken,
                            'priority': 'high',
                            'notification' : {
                              'title' : 'New Event',
                              'body' : 'New friendly event created'
                            }
                          };
                          await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
                              body: jsonEncode(data) ,
                              headers: {
                                'Content-Type' : 'application/json; character=UTF-8',
                                'Authorization' : 'key=AAAA4vnms68:APA91bHEf5AiZNGMPVT4jhpwG-ch-xibl1bHViNssWa21fYTsCCs0AMuLGPVqzDnhNOcwGTc_YvGrUqAyKSf2VU-jAJZ70I8J6vhHbZMd2WK898FjxZJ2pJAUv6H_MBF4-lUridh9q8P'
                              }
                          );
                        } else {
                          showAlertDialog(context, "Error", "Event Not created");
                          setState(() {
                            _isloading = false;
                          });
                          clearTextInput();
                        }
                      }
                    }
                  },
                  child: Text('Create Event'),
                ),
              ],
            ),
            Visibility(
              visible: _isloading,
              child: Container(
                // color: Colors.black.withOpacity(0.5), // Overlay color
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
          ],
        )
      ),
    );
  }

}

typedef OnTimeSlotSelected = void Function(bool value, int index);
// class totalPersonDrop extends StatefulWidget {
//   final String value;
//   totalPersonDrop({required this.value});
//
//   @override
//   State<totalPersonDrop> createState() => _totalPersonDropState();
// }
//
// class _totalPersonDropState extends State<totalPersonDrop> {
//   @override
//   Widget build(BuildContext context) {
//     if (widget.value == "Table Tennis"){
//       return  DropdownButton(
//         value: _friendlyEventState().tabletennisTP,
//         items: _friendlyEventState().tabletennis,
//         onChanged: (String? value){
//           setState(() {
//             _friendlyEventState().selectedTotalPerson = value!;
//             print(_friendlyEventState().selectedTotalPerson);
//           });
//
//         },
//       );
//     }
//     else if (widget.value == "futsul"){
//       return  DropdownButton(
//         value: _friendlyEventState().footbalTP,
//         items: _friendlyEventState().footbal,
//         onChanged: (String? value){
//
//         },
//       );
//     }
//     else if (widget.value == "cricket"){
//       return  DropdownButton(
//         value: _friendlyEventState().cricketTP,
//         items: _friendlyEventState().cricket,
//         onChanged: (String? value){
//
//         },
//       );
//     }
//     else if (widget.value == "bedminton"){
//       return  DropdownButton(
//         value: _friendlyEventState().badmintonTP,
//         items: _friendlyEventState().badminton,
//         onChanged: (String? value){
//
//         },
//       );
//     }
//     else if (widget.value == "Volley Ball"){
//       return  DropdownButton(
//         value: _friendlyEventState().volleyballTP,
//         items: _friendlyEventState().volleyball,
//         onChanged: (String? value){
//
//         },
//       );
//     }
//     else if (widget.value == "Basket Ball"){
//       return  DropdownButton(
//         value: _friendlyEventState().basketballTP,
//         items: _friendlyEventState().basketball,
//         onChanged: (String? value){
//
//         },
//       );
//     }
//     else{
//       return DropdownButton(
//         value: _friendlyEventState().tabletennisTP,
//         items: _friendlyEventState().tabletennis,
//         onChanged: (String? value){
//
//         },
//       );
//     }
//   }
// }

// totalPersonDrop

class TimeSlotsDialog extends StatefulWidget {

  final timeSlotsList;
  final userSelectedTime;

  const TimeSlotsDialog(this.timeSlotsList, this.userSelectedTime, Null Function(dynamic value, dynamic index) param2, {super.key});

  @override
  State<TimeSlotsDialog> createState() => _TimeSlotsDialogState();
}

class _TimeSlotsDialogState extends State<TimeSlotsDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Select Time Slots'),
      content: Container(
          height: 230, // set fixed height
          child: Column(
            children: [

              if (widget.timeSlotsList != [])...[
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: List.generate(
                    widget.timeSlotsList.length,
                        (index) {
                      return Column(
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                widget.userSelectedTime.add(widget.timeSlotsList[index]);
                                widget.timeSlotsList.remove(widget.timeSlotsList[index]);
                              });
                            },
                            child: Container(
                              height: 40,
                              width: 60,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                  color: Colors.black,
                                  width: 1,
                                ),
                              ),
                              child: Center(
                                child: Text(widget.timeSlotsList[index],
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 13),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 30,
                          )
                        ],
                      );
                    },
                  ),
                ),
                SizedBox(
                            height: 10,
                          ),
                Container(
                            color: Colors.black,
                            width: 200,
                            height: 1,
                          ),
                SizedBox(
                            height: 10,
                          ),
                Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: List.generate(
                              widget.userSelectedTime.length,
                                  (index) {
                                return Column(
                                  children: [
                                    InkWell(
                                      onTap: (){
                                        setState(() {
                                          widget.timeSlotsList.add(widget.userSelectedTime[index]);
                                          widget.userSelectedTime.remove(widget.userSelectedTime[index]);
                                        });
                                      },
                                      child:  Container(
                                        height: 40,
                                        width: 60,
                                        decoration: BoxDecoration(
                                          color: Colors.teal,
                                          borderRadius: BorderRadius.circular(5),
                                          border: Border.all(
                                            color: Colors.black,
                                            width: 1,
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(widget.userSelectedTime[index],
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 13),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 30,
                                    )
                                  ],
                                );
                              },
                            ),
                          ),
        ]
              else
                Text("No time Slots available"),

            ],
          )
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Done'),
        ),
      ],
    );
  }
}


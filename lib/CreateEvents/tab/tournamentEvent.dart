import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fyp/databaseManager/databaseManager.dart';
import 'package:fyp/services/NotificationServices.dart';
import '../../UIcomponents/UIcomponents.dart';
import 'package:http/http.dart' as http;


class tournamentEvent extends StatefulWidget {
  const tournamentEvent({Key? key}) : super(key: key);
  @override
  State<tournamentEvent> createState() => _tournamentEventState();
}

class _tournamentEventState extends State<tournamentEvent> {
  var dbmanager = DatabaseManager();
  var date = "Pick a Date";
  var time = "Pick  Time";
  var authorName = "";
  var EventAuthor = "";
  var selectedLocation = "Table Tennis Area";
  var selectedsports = "Table Tennis";
  var teamAlist = [];
  var selectedTp = "2";
  var selectteamss = "4";

  var timeSlotsList = ['9-10 am','10-11 am','11-12 am','12-1 pm','3-4 pm','4-5 pm'];
  var userSelectedTime = [];
  var deviceToken = "";
  var isloading = false;
  var login_user_dept = "";
  var login_user_phoneNumber = "";

  NotificationServices notificationServices = NotificationServices();
  List<DropdownMenuItem<String>>? totalPersonDropDownList = [];
  TextEditingController tornamentNameController = TextEditingController();
  TextEditingController total_winning = TextEditingController();
  TextEditingController per_team = TextEditingController();




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
      DropdownMenuItem(child: Text("Table Tennis"), value: "Table Tennis"),
      DropdownMenuItem(child: Text("Futsul"), value: "Futsul"),
      DropdownMenuItem(child: Text("Cricket"), value: "Cricket"),
      DropdownMenuItem(child: Text("Bedminton"), value: "Bedminton"),
      DropdownMenuItem(child: Text("Volley Ball"), value: "Volley Ball"),
      DropdownMenuItem(child: Text("Basket Ball"), value: "Basket Ball")
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
      authorName = daaa['fullname'];
      login_user_dept = daaa['deptname'];
      login_user_phoneNumber = daaa['phoneNumber'];
      print(EventAuthor);
    });
  }
  Future CheckTheTimeSlots() async{
    final collectionReference = FirebaseFirestore.instance.collection('TourEvents');
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
  clearTextInput(){
    setState(() {
      tornamentNameController.clear();
      timeSlotsList = ['9-10 am','10-11 am','11-12 am','12-1 pm','3-4 pm','4-5 pm'];
      date = "Pick a Date";
      total_winning.clear();
      per_team.clear();

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
      print(authorName);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
    getAdminDeviceToken();
    notificationServices.requestNotificationPermission();
    notificationServices.firebaseinit();
    notificationServices.getDeviceToken();

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
                    child:  TextField(
                      obscureText: false,
                      controller: tornamentNameController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintStyle: TextStyle(
                            color: Colors.black12
                        ),
                        labelStyle:  TextStyle(
                            color: Colors.black
                        ),
                        labelText: 'Tournament Name',
                        hintText: "Enter Tournament  Name",

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
                                            initialDate: DateTime.now().add(Duration(days: 21)),
                                            firstDate: DateTime.now().add(Duration(days: 21)),
                                            lastDate: DateTime(2030),
                                          );
                                          if(datePicked != null){
                                            print("${datePicked.day}/${datePicked.month}/${datePicked.year}");
                                            var formattDate = "${datePicked.day}/${datePicked.month}/${datePicked.year}";
                                            setState(() {
                                              date = formattDate;
                                            });

                                            CheckTheTimeSlots();
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
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return TimeSlotsDialog(timeSlotsList,userSelectedTime,
                                                      (value, index) {});
                                            },
                                          );
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
                Padding(
                    padding: EdgeInsets.all(8.0),
                    child:  TextField(
                      obscureText: false,
                      controller: total_winning,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintStyle: TextStyle(
                            color: Colors.black12
                        ),
                        labelStyle:  TextStyle(
                            color: Colors.black
                        ),
                        labelText: 'Enter Winning Price',
                        hintText: "Enter Winning  Price",

                      ),
                    )
                ),
                Padding(
                    padding: EdgeInsets.all(8.0),
                    child:  TextField(
                      obscureText: false,
                      controller: per_team,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintStyle: TextStyle(
                            color: Colors.black12
                        ),
                        labelStyle:  TextStyle(
                            color: Colors.black
                        ),
                        labelText: 'Enter  Per Team',
                        hintText: "Enter Perhead",

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

                    if(login_user_phoneNumber == "" || login_user_dept == ""){
                      showAlertDialog(context, "Error", "Kindly update your profile");
                    }else{
                      setState(() {
                        isloading = true;
                      });
                      var sportsImage = "";
                      if (selectedsports == "Table Tennis"){
                        setState(() {
                          sportsImage = "https://firebasestorage.googleapis.com/v0/b/bukc-sports-hub.appspot.com/o/360_F_303275863_EWavqozgkXmiSNoz3zKXoQKcZcGJoGyt.jpeg?alt=media&token=6de2de47-246e-43ac-81d6-4bde71ea869b";
                        });
                      }else if (selectedsports == "Futsul"){
                        setState(() {
                          sportsImage = "https://firebasestorage.googleapis.com/v0/b/bukc-sports-hub.appspot.com/o/soccer-ball-design_1818040.jpeg?alt=media&token=735416c8-6e71-41c8-92b5-b963c628ea8a";
                        });
                      }else if (selectedsports == "Cricket"){
                        setState(() {
                          sportsImage = "https://firebasestorage.googleapis.com/v0/b/bukc-sports-hub.appspot.com/o/cricket.jpeg?alt=media&token=d04e57c6-3d39-4733-a164-15e7fbe3d9df";
                        });
                      }else if (selectedsports == "Bedminton"){
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
                      if (tornamentNameController.text == "Tournament Name" ||
                          userSelectedTime == null ||
                          date == "Pick a Date" ) {
                        setState(() {
                          isloading = false;
                        });
                        showAlertDialog(context, "Error", "Kindly add all event info");
                      }else{
                        var eventCreate = await dbmanager.createTournamentEvent(EventAuthor, tornamentNameController.text, selectedLocation, selectedsports, sportsImage, userSelectedTime, date, selectedTp, selectteamss, total_winning.text, per_team.text);
                        if(eventCreate == true){
                          setState(() {
                            isloading = false;
                          });
                          print(deviceToken);
                          var data = {
                            'to': deviceToken,
                            'priority': 'high',
                            'notification' : {
                              'title' : 'New Event',
                              'body' : 'new tournament created'
                            }
                          };
                          await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
                              body: jsonEncode(data) ,
                              headers: {
                                'Content-Type' : 'application/json; character=UTF-8',
                                'Authorization' : 'key=AAAA4vnms68:APA91bHEf5AiZNGMPVT4jhpwG-ch-xibl1bHViNssWa21fYTsCCs0AMuLGPVqzDnhNOcwGTc_YvGrUqAyKSf2VU-jAJZ70I8J6vhHbZMd2WK898FjxZJ2pJAUv6H_MBF4-lUridh9q8P'
                              }
                          );

                          showAlertDialog(context,"Done","Event created successfully");

                          clearTextInput();
                        }else{
                          showAlertDialog(context,"Error","Event Not created");
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
              visible: isloading,
              child: Container(
               // color: Colors.black.withOpacity(0.5), // Overlay color
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
          ],
        )
      )

    );
  }
}


// TIME SLOT SELECTION :::::::::::::::::::::::::::::::::::::::::::::::::::::::::
typedef OnTimeSlotSelected = void Function(bool value, int index);
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
            // var abovelcassRef = _friendlyEventState();
            // setState(() {
            //   abovelcassRef.timeSlotsList =  ['9-10 am','10-11 am','11-12 am','12-1 pm','3-4 pm','4-5 pm'];
            // });
          },
          child: Text('Done'),
        ),
      ],
    );
  }
}

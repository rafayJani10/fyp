

import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fyp/databaseManager/databaseManager.dart';

import '../UIcomponents/UIcomponents.dart';


class createEvents extends StatefulWidget {
  const createEvents({Key? key}) : super(key: key);

  @override
  State<createEvents> createState() => _createEventsState();
}

class _createEventsState extends State<createEvents> {

  var dbmanager = DatabaseManager();
  var date = "Pick Your Date";
  var time = "Pick Your Time";
  var userList = [];
  var EventAuthor = "";

  TextEditingController eventNameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController totalPersonNameController = TextEditingController();

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
    return Scaffold(
      appBar:  AppBar(
        title: const Text("Create Event"),
        backgroundColor: Colors.teal[900]
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Padding(padding: EdgeInsets.only(top: 10)),
            Container(
              width: 200,
              height: 200,
              color: Colors.green,
            ),
            Padding(padding: EdgeInsets.only(top: 35)),
             Padding(
              padding: EdgeInsets.all(8.0),
              child:  TextField(
                obscureText: true,
                controller: eventNameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintStyle: TextStyle(
                    color: Colors.black
                  ),
                  labelStyle:  TextStyle(
                      color: Colors.black
                  ),
                  labelText: 'Event Name',
                  hintText: "Enter Event Name"
                ),
              )
            ),
             Padding(
                padding: EdgeInsets.all(8.0),
                child:  TextField(
                  controller: addressController,
                  obscureText: true,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintStyle: TextStyle(
                          color: Colors.black
                      ),
                      labelStyle:  TextStyle(
                          color: Colors.black
                      ),
                      labelText: 'Address',
                      hintText: "Enter Address"
                  ),
                )
            ),
             Padding(
                padding: EdgeInsets.all(8.0),
                child:  TextField(
                  controller: totalPersonNameController,
                  obscureText: true,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintStyle: TextStyle(
                          color: Colors.black
                      ),
                      labelStyle:  TextStyle(
                          color: Colors.black
                      ),
                      labelText: 'Total Person',
                      hintText: "Enter Total No Of Person"
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
                var eventCreate = await dbmanager.createEventData(EventAuthor,eventNameController.text, addressController.text, totalPersonNameController.text, "", time, date, 0, userList);
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
      ),
    );
  }
}

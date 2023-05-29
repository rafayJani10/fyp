import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../UIcomponents/UIcomponents.dart';

class ChangePassword extends StatefulWidget {
  final String? userid;

  const ChangePassword({this.userid});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {

  TextEditingController ConfirmPasswordController = TextEditingController();
  TextEditingController NewPasswordController = TextEditingController();

  var _isloading = false;

  Future<bool?> updataUserPassword(password) async {
    print(widget.userid);
    var updateDataStatus = false;
    await FirebaseFirestore.instance.collection('users').doc(widget.userid).update(
        {
          "password":password,
        })
        .then((result){
      print("new password set");
      setState(() {
        _isloading = false;
      });
      updateDataStatus = true;
      showAlertDialog(context, "Successfully Password Changed", "");
      //return true;
    })
        .catchError((onError){
      print("onError");
      //return false;
    });
    print("object");
    return updateDataStatus;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        backgroundColor: Colors.teal[900],
      ),
      body: Center(
        child: Stack(
          children: [
            Center(
              child: Container(
                height: 400,
                width: 300,
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
                child: Column(
                  children: [
                    SizedBox(height: 20,),
                    Text("Change Password", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
                    SizedBox(height: 50,),
                    Padding(
                        padding: EdgeInsets.all(8.0),
                        child:  TextField(
                          obscureText: true,
                          controller: NewPasswordController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintStyle: TextStyle(
                                color: Colors.black12
                            ),
                            labelStyle:  TextStyle(
                                color: Colors.black
                            ),
                            labelText: 'New Password',
                            hintText: "Enter New  Password",

                          ),
                        )
                    ),
                    Padding(
                        padding: EdgeInsets.all(8.0),
                        child:  TextField(
                          obscureText: true,
                          controller: ConfirmPasswordController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintStyle: TextStyle(
                                color: Colors.black12
                            ),
                            labelStyle:  TextStyle(
                                color: Colors.black
                            ),
                            labelText: 'Confirm Password',
                            hintText: "Enter Confirm  Password",

                          ),
                        )
                    ),
                    SizedBox(height: 30,),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.teal[900],
                        onPrimary: Colors.white,
                        shadowColor: Colors.green,
                        elevation: 6,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0)),
                      ),
                      onPressed: (){
                        setState(() {
                          _isloading = true;
                        });
                        if(NewPasswordController.text == ConfirmPasswordController.text && NewPasswordController.text != ""){
                          print("enteygfajfgjgjgjgfjggggggg::::::::::::");
                          updataUserPassword(NewPasswordController.text);
                        }else{
                          showAlertDialog(context,"Something Wrong","Kindly check your password");
                        }
                      },
                      child: Text('Create Password'),
                    ),
                  ],
                ),
              ),
            ),
            Visibility(
                visible: _isloading,
                child: Center(child: CircularProgressIndicator(),))
          ],
        )
      ),
    );
  }
}


import 'dart:convert';

import 'dart:io';
// import 'dart:html';

import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';

import '../databaseManager/databaseManager.dart';


class ProflePage extends StatefulWidget {
   ProflePage({Key? key}) : super(key: key);

  @override
  State<ProflePage> createState() => _ProflePageState();
}



class _ProflePageState extends State<ProflePage> {

  File? _image;
  final  dbmanager = DatabaseManager();
  var userName = "";
  var userImage = "";
  var userEmail = "";
  var phoneNumber = "";
  var userRole = "";

  Future<dynamic> getUserData() async{
    var data =  await dbmanager.getData('userBioData');
    var daaa = json.decode(data);
    setState(() {
      userName = daaa['fullname'];
      userImage = "";
      userEmail = daaa['email'];
      phoneNumber = daaa['phoneNumber'];
      userRole = daaa['userRole'];

    });
  }

  Future getImage() async{
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if(image == null){return ;}

    final imageTemporary = File(image.path);
    setState(() {
      _image = imageTemporary;
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
        //drawer: SideMenueBar(),
        appBar: AppBar(
          title: const Text("Edit Profile"),
          backgroundColor: Colors.teal[900],
        ),
      body: Column(
        children: [
          Flexible(
            flex: 1,
              child: Container(
                width: double.infinity,
                //color: Colors.green,
                child: Center(
                  child: CircleAvatar(
                      radius: 70,
                      backgroundColor: Colors.teal,
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 69,
                            backgroundColor: Colors.teal,
                            child: ClipOval(
                              child: _image != null
                                  ? Image.file(_image! ,width: 130,height: 130, fit: BoxFit.fill)
                                  : Image.network(userImage,width: 130,height: 13, fit: BoxFit.fill),
                            ),
                          ),
                          Align(
                            alignment: FractionalOffset.bottomRight,
                            child: InkWell(
                              onTap: (){
                                getImage();
                              },
                              child: Container(
                                margin: EdgeInsetsDirectional.only(bottom: 10),
                                height: 50,
                                width: 50,
                                color: Colors.white12,
                                child: Center(
                                  child: Icon(
                                    Icons.camera_alt,
                                    color: Colors.grey,
                                    size: 40,
                                  ),
                                ),
                              ),
                            )
                          )
                        ],
                      )
                  ),
                ),
              )),
          Flexible(
              flex: 3,
              child: Container(
                width: double.infinity,
               // color: Colors.red,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(15),
                        child: TextField(
                          //controller: nameController,
                          decoration: InputDecoration(
                            labelStyle:   TextStyle(
                              color: Colors.black
                            ),
                            border: OutlineInputBorder(),
                            labelText: userName,
                            hintText: "Full Name",
                            fillColor: Colors.white54,
                            //filled: true

                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(15),
                        child: TextField(
                          //controller: nameController,
                          decoration: InputDecoration(
                            labelStyle:   TextStyle(
                                color: Colors.black
                            ),
                            border: OutlineInputBorder(),
                            labelText: userName,
                            hintText: "userName",
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(15),
                        child: TextField(
                          //controller: nameController,
                          decoration: InputDecoration(
                            labelStyle:   TextStyle(
                                color: Colors.black
                            ),
                            border: OutlineInputBorder(),
                            labelText: phoneNumber,
                            hintText: "phoneNumber",
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(15),
                        child: TextField(
                          //controller: nameController,
                          decoration: InputDecoration(
                            labelStyle:   TextStyle(
                                color: Colors.black
                            ),
                            border: OutlineInputBorder(),
                            labelText: userRole,
                            hintText: "userRole",
                          ),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.teal[900],
                          onPrimary: Colors.white,
                          shadowColor: Colors.green,
                          elevation: 6,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32.0)),
                          minimumSize: Size(200, 50), //////// HERE
                        ),
                        onPressed: () {},
                        child: Text('Update'),
                      ),
                      SizedBox(height: 30,)
                    ],
                  ),
                )
              ))
        ],
      ),
    );
  }
}

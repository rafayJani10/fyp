// TODO Implement this library.
import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp/CreateEvents/CreateEvents.dart';
import 'package:fyp/homepage/homepage.dart';
import 'package:fyp/login/view/LoginScreen.dart';
import 'package:fyp/services/firebase_services.dart';
import 'package:shared_preferences/shared_preferences.dart';


import '/MyEventList/MyEventList.dart';
import '/ProfilePage/ProfilePage.dart';
import '/databaseManager/databaseManager.dart';

class SideMenueBar extends StatefulWidget {
  const SideMenueBar({Key? key}) : super(key: key);

  @override
  State<SideMenueBar> createState() => _SideMenueBarState();
}

class _SideMenueBarState extends State<SideMenueBar> {

  final  dbmanager = DatabaseManager();
  var userName = "";
  var userImage = "";
  var noImagePlaceholder = "";
  var gender = "";
  var userId = "";

  Future<dynamic> getUserData() async{
    var data =  await dbmanager.getData('userBioData');
    var daaa = json.decode(data);
    setState(() {
      userName = daaa['fullname'];
      userImage = daaa["picture"];
      gender = daaa["gender"];
      userId = daaa["id"];
      if (gender == "mail"){
        noImagePlaceholder = "https://firebasestorage.googleapis.com/v0/b/bukc-sports-hub.appspot.com/o/menph.jpeg?alt=media&token=599c5531-d4d5-4776-8a3c-3eaf45a54d2e";
      }else{
        noImagePlaceholder = "https://firebasestorage.googleapis.com/v0/b/bukc-sports-hub.appspot.com/o/womenph.jpeg?alt=media&token=e91ba2c5-8737-411d-8be2-42e0cd2d6e35";
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
    //getUserData();
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
              decoration: const BoxDecoration(
                color: Color(0xff004D40),
              ),
              child: Column(
                children: <Widget>[
                  CircleAvatar(
                    radius: 50,
                    child: ClipOval(
                        child: userImage == "" ?Image.network(noImagePlaceholder,  fit: BoxFit.fill) :Image.network(userImage,  fit: BoxFit.fill)
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Text(userName,
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white
                      ),
                    ),
                  )
                ],
              )

          ),
          ListTile(
            title:   Text("Home"
            ),
            leading: const Icon(
                Icons.home_filled
            ),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(
                      builder: (context) => MyHomePage(title: "Home Page")
                  )
              );

              //Navigator.pop(context);
            },
          ),
          ListTile(
            title:   Text("Profile"
            ),
            leading: const Icon(
                Icons.account_circle_outlined
            ),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(
                      builder: (context) => ProflePage()
                  )
              );

              //Navigator.pop(context);
            },
          ),
          ListTile(
//            tileColor: Colors.blue ,

            title: const Text('My Events'),
            leading: const Icon(
                Icons.event_available_outlined
            ),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(
                      builder: (context) => MyEventList(title: 'My Eventa',)
                  )
              );
            },
          ),
          ListTile(

            title: const Text('Create Events'),
            leading: const Icon(
                Icons.add_circle_outline_outlined
            ),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(
                      builder: (context) => createEvents()
                  )
              );

            },
          ),
          ListTile(
            title:  const Text('Sign Out'),
            leading: const Icon(
                Icons.logout_outlined
            ),

            onTap: () async {
              await FirebaseServices().signOut();
              FirebaseAuth.instance.signOut().then((value) {
                print("Signed Out");
                Navigator.pushReplacement(context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()));
              });
              // Update the state of the app
              // ...
              // Then close the drawer

              //   Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
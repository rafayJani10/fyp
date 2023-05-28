// TODO Implement this library.
import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
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

  final dbmanager = DatabaseManager();
  var userName = "";
  var userImage = "";
  var noImagePlaceholder = "";
  var gender = "";
  var userId = "";
  var email = "";
  var is_image_loading = true;


  Future<dynamic> getUserData() async{
    var data =  await dbmanager.getData('userBioData');
    var daaa = json.decode(data);
    setState(() {
      userName = daaa['fullname'];
      userImage = daaa["picture"];
      gender = daaa["gender"];
      userId = daaa["id"];
      email = daaa["email"];
      if(userImage != ""){
        is_image_loading = false;
      }

    });
  }

  @override
  void initState() {

    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    var LoginUserRole = 1;
    //getUserData();
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
              decoration: const BoxDecoration(
                color: Color(0xff004D40),
              ),
              child: Column(
                children: <Widget>[
                  Stack(
                    children: [
                      // Circular avatar with image or placeholder
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.white, // Placeholder color
                        backgroundImage: userImage != ""
                            ? NetworkImage("$userImage")
                            : null, // Use NetworkImage only when imageUrl is not null
                      ),

                      // Loader
                      if (is_image_loading)
                        const Positioned.fill(
                          child: CircularProgressIndicator(
                            color: Colors.teal,
                          ),
                        ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Text(userName,
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.white
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Text(email,
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[200]
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
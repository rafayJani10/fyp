// TODO Implement this library.
import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp/CreateEvents/CreateEvents.dart';
import 'package:fyp/MyEvents/MyEvents.dart';
import 'package:fyp/admin/adminhomepage.dart';
//import 'package:fyp/homepage/homepage.dart';
import 'package:fyp/login/view/LoginScreen.dart';
import 'package:fyp/services/firebase_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  Future<dynamic> getUserData() async{
    var data =  await dbmanager.getData('userBioData');
    var daaa = json.decode(data);
    setState(() {
      userName = daaa['fullname'];
      userImage = daaa["picture"];
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
                        child: Image.network("https://user-images.githubusercontent.com/35910158/35493994-36e2c50e-04d9-11e8-8b38-890caea01850.png",  fit: BoxFit.fill)
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Text("ADMIN",
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
                      builder: (context) => MyAdminHomePage(title: "title")
                  )
              );

              //Navigator.pop(context);
            },
          ),
          ListTile(
            title:   Text("Approval Requests"
            ),
            leading: const Icon(
                Icons.add_task_outlined
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
            title:   Text("Tournaments"
            ),
            leading: const Icon(
                Icons.sports_kabaddi_outlined
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
            title:   Text("Sponsered Events"
            ),
            leading: const Icon(
                Icons.paid_outlined
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
                      builder: (context) => MyEvents()
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
            title:   Text("Add Subordinate"
            ),
            leading: const Icon(
                Icons.group_add_outlined
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
            title:  const Text('Sign Out'),
            leading: const Icon(
                Icons.logout_outlined
            ),

            onTap: () async {
              await FirebaseServices().signOut();
              FirebaseAuth.instance.signOut().then((value) {
                print("Signed Out");
                Navigator.push(context,
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
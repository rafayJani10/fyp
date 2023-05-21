// TODO Implement this library.
import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp/CreateEvents/CreateEvents.dart';
import 'package:fyp/admin/adminhomepage.dart';
import 'package:fyp/homepage/homepage.dart';
import 'package:fyp/login/view/LoginScreen.dart';
import 'package:fyp/services/firebase_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../MyEventList/MyEventList.dart';
import '/ProfilePage/ProfilePage.dart';
import '/databaseManager/databaseManager.dart';
import 'AdminCreateEvent.dart';
import 'AdminMyEvents.dart';
import 'AdminProfilePAge.dart';
import 'ApprovalEvent/approvals.dart';

class AdminSideMenueBar extends StatefulWidget {
  const AdminSideMenueBar({Key? key}) : super(key: key);

  @override
  State<AdminSideMenueBar> createState() => _AdminSideMenueBarState();
}

class _AdminSideMenueBarState extends State<AdminSideMenueBar> {

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
                        child: Image.network("https://firebasestorage.googleapis.com/v0/b/bukc-sports-hub.appspot.com/o/menph.jpeg?alt=media&token=599c5531-d4d5-4776-8a3c-3eaf45a54d2e",  fit: BoxFit.fill)
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Text("Admin",
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
                      builder: (context) => MyAdminHomePage(title: "Home Page")
                  )
              );

              //Navigator.pop(context);
            },
          ),
           ListTile(
//            tileColor: Colors.blue ,

            title: Text('My Events'),
            leading: Icon(
                Icons.event_available_outlined
            ),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(
                      builder: (context) => AdminMyEventList(title: 'My event',)
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
                      builder: (context) => AdmincreateEvents()
                  )
              );

            },
          ),
          ListTile(

            title: const Text('Approve Events'),
            leading: const Icon(
                Icons.approval
            ),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(
                      builder: (context) => AdminApprovalList()
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
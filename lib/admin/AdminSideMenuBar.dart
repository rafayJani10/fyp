// TODO Implement this library.
import 'dart:convert';
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
import 'ChangePassword.dart';

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
                  Stack(
                    children: [
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
                          fontSize: 16,
                          color: Colors.white
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Text(email,
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.white
                      ),
                    ),
                  ),
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

            title: const Text('Change Password'),
            leading: const Icon(
                Icons.approval
            ),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(
                      builder: (context) => ChangePassword(userid: userId,)
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
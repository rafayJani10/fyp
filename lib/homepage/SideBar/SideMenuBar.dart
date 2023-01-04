// TODO Implement this library.
import 'package:flutter/material.dart';
import 'package:fyp/login/view/LoginScreen.dart';
import 'package:fyp/profile/userprofile.dart';

//import 'package:easy_sidemenu/easy_sidemenu.dart';

class SideMenueBar extends StatelessWidget {
  const SideMenueBar({super.key});

  @override
  Widget build(BuildContext context) {
    // var iconList = ["person"];
  //  var optionList = ["Profile"];

    //               ),
    return Drawer(

      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
           DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.blue,
            ),
            child: CircleAvatar(
              radius: 50,
              child: ClipOval(
                child: Image.network('https://media.licdn.com/dms/image/C5603AQGkN-nR2UCVPQ/profile-displayphoto-shrink_800_800/0/1646931414781?e=1677715200&v=beta&t=Nvt7V0gjnGPFMP1euDP0a2ReGO8b56MSLNLPG2Xjz4o'
                    ,
                    width: 130,
                    fit: BoxFit.fill
                ),
              ),
                              // backgroundImage:
                              // NetworkImage('https://media.licdn.com/dms/image/C5603AQGkN-nR2UCVPQ/profile-displayphoto-shrink_800_800/0/1646931414781?e=1677715200&v=beta&t=Nvt7V0gjnGPFMP1euDP0a2ReGO8b56MSLNLPG2Xjz4o',fit: BoxFit.fill),
                              // radius: 30,

           // Text('Drawer Header'),
          ),
          ),
          ListTile(
            title:  const Text('My Profile'),
            leading: const Icon(
                Icons.account_circle_outlined
            ),
            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer
              Navigator.push(context,
              MaterialPageRoute(

              builder: (context) => userprofile()));
    // Then close the drawer
    // Navigator.pop(context);

            },
          ),
          ListTile(
//            tileColor: Colors.blue ,

            title: const Text('My Events'),
            leading: const Icon(
                Icons.event_available_outlined
            ),
            onTap: () {
              // Update the state of the app
              // ...
              // Navigator.push(context,
              //     MaterialPageRoute(
              //
              //         builder: (context) => userprofile()));
              // Then close the drawer
              // Navigator.pop(context);
            },
          ),
          ListTile(

            title: const Text('Create Events'),
            leading: const Icon(
                Icons.add_circle_outline_outlined
            ),
            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer
              Navigator.pop(context);
            },
          ),
          ListTile(
            title:  const Text('Sign Out'),
            leading: const Icon(
              Icons.logout_outlined
            ),

            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer
              Navigator.push(context,
                                    MaterialPageRoute(

                                        builder: (context) => const LoginScreen()));
           //   Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
  }
    //   child: Column(
    //     children: <Widget>[
    //       Container(
    //           width: double.infinity,
    //           height: 170,
    //           color: Colors.indigo,
    //           child: Center(
    //             child: Container(
    //               padding: const EdgeInsets.only(top: 8.0),
    //               height: 130,
    //               width: 130,
    //               //color: Colors.red,
    //               child: const CircleAvatar(
    //                 backgroundImage:
    //                 NetworkImage('https://picsum.photos/id/237/200/300'),
    //                 radius: 100,
    //               ),
    //             ),
    //           )
    //       ),
    //       SizedBox(
    //         width: double.infinity,
    //         height: 560,
    //         //color: Colors.blue,
    //         child: Column(
    //           children: <Widget>[
    //             for (var i = 0; i < optionList.length; i++) ...[
    //               Container(
    //                 width: double.infinity,
    //                 height: 3,
    //                 color: Colors.grey,
    //               ),
    //               SizedBox(
    //                 width: double.infinity,
    //                 height: 80,
    //                 //color: Colors.red,
    //                 child: Center(
    //                   child: Row(
    //                     children: <Widget>[
    //                       const SizedBox(
    //                         width: 50,
    //                         height: 50,
    //                         //color: Colors.orange,
    //                         child: Center(
    //                           child: Icon(Icons.person,
    //                             size: 35.0,
    //                             color: Colors.black,
    //                           ),
    //                         ),
    //                       ),
    //                       Container(
    //                         width: 250,
    //                         height: 50,
    //                         //color: Colors.orange,
    //                         padding: const EdgeInsets.only(left: 10.0, top: 12.0),
    //                         child:  Text(optionList[i],
    //                             style: const TextStyle(
    //                                 color: Colors.black,
    //                                 fontWeight: FontWeight.bold,
    //                                 fontSize: 25)
    //                         ),
    //                       )
    //                     ],
    //                   ),
    //                 ),
    //               )
    //             ],
    //          // ],
    //            const SizedBox(height: 10),
    //           GestureDetector(
    //             onTap: () {
    //               // String email = emailController.text;
    //               // String pass = passwordController.text;
    //               Navigator.push(context,
    //                   MaterialPageRoute(
    //
    //                       builder: (context) => const LoginScreen()));
    //             },
    //             child: Container(
    //
    //               margin: const EdgeInsets.only(left: 0, top: 30, right: 10, bottom: 5),
    //               width: 200,
    //               decoration: BoxDecoration(
    //
    //                 borderRadius: BorderRadius.circular(30),
    //                 color: Colors.black,
    //               ),
    //               child: const Center(
    //                 child: Padding(
    //                   padding: EdgeInsets.all(10.0),
    //                   child: Text(
    //                     ' Sign Out',
    //                     style: TextStyle(
    //                       color: Colors.white,
    //                       fontSize: 20,
    //                       fontWeight: FontWeight.w500,
    //                     ),
    //                   ),
    //
    //                 ),
    //               ),
    //             ),
    //           ),
    //      ],   ),
    //       ),
    //
    //
    //
    //     ],
    //   ),
    // );
//   }
// }
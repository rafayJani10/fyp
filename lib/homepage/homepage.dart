
import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fyp/databaseManager/databaseManager.dart';
import 'package:fyp/homepage/Tabs/friendlyGame.dart';
import 'package:fyp/homepage/Tabs/tournamentEvent.dart';
import '../Notifications/notificationScreen.dart';
import '../services/NavigationServices.dart';
import '../services/NotificationServices.dart';
import 'SideBar//SideMenuBar.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
}

Future<void> backgroundMessageHandler(RemoteMessage message) async {
  // Handle background message
  print('Handling a background message: ${message.messageId}');

  // Navigate to a specific screen when the user taps on the notification
  // In this example, we're navigating to the home screen
  NavigationService navigationService = NavigationService();
  navigationService.navigateTo('/home');
}


Future<void> main() async {
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(backgroundMessageHandler);

  runApp(const MyApp());
}
class MyApp extends StatelessWidget {

  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  int _cartBadgeAmount = 3;
  late bool _showCartBadge;
  var dbmanager = DatabaseManager();
  var notificationServices = NotificationServices();
  var login_user_id = "";
  late TabController _tabController;
  final List<Tab> myTabs =  <Tab>[
    new Tab(text: 'a'),
    new Tab(text: 'b'),
  ];




  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = new TabController(length: 2, vsync: this);

    //getUserData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    _showCartBadge = _cartBadgeAmount > 0;

    return Scaffold(
        drawer: SideMenueBar(),
        appBar: AppBar(
          title: const Text("Event List"),
          actions: [
           Stack(
            children: [
              InkWell(
                onTap: (){
                  print("yes clicked");
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  Notifications_Screen()),
                  );
                },
                child: Container(
                  height: 50,
                  width: 50,
                  //color: Colors.green,
                  child: Center(
                    child: Icon(Icons.notification_important,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
              ),
             Padding(
               padding: EdgeInsets.only(left: 22,top: 8),
               child:  Container(
                 height: 20,
                 width: 20,
                 decoration: BoxDecoration(
                     color: Colors.red,
                     borderRadius: BorderRadius.circular(100)
                   //more than 50% of width makes circle
                 ),
                 child: Center(
                   child : Text("99+",
                   style: TextStyle(
                     fontSize: 10
                   ),)
                 ),
               ),
             )
            ],
           )
          ],
          backgroundColor: Colors.teal[900],
          bottom: TabBar(
            controller: _tabController,
            tabs: [
              Tab(
                child: Text('Frinedly Games',
                style: TextStyle(
                  color: Colors.white
                ),
                ),
              ),
              Tab(
                child: Text('Tournament',
                  style: TextStyle(
                      color: Colors.white
                  ),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            FriendlyGame(),
            tournamentEventList()
          ],
        )
    );
  }

}


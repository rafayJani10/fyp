import 'dart:async';
import 'dart:convert';
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fyp/admin/adminhomepage.dart';
import 'package:fyp/UIcomponents/color_utils.dart';
import 'package:fyp/databaseManager/databaseManager.dart';
// import 'SecondScreen.dart';
import 'package:fyp/homepage/homepage.dart';
import 'package:fyp/services/firebase_services.dart';
import 'package:fyp/signup/view/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../UIcomponents/UIcomponents.dart';
import '../../services/NotificationServices.dart';
import '../../useable.dart';

void main()  async{
  WidgetsFlutterBinding.ensureInitialized();
 await Firebase.initializeApp();
  // Start the timer to update data every 2 days
  Timer.periodic(Duration(days: 2), (timer) {
    // checkAndDeleteDocuments();
  });
  runApp(
     MaterialApp(
      debugShowCheckedModeBanner: false,
       theme: ThemeData(
         primaryColor: Colors.white,
         accentColor: Colors.white,
         highlightColor: Colors.white,
         hintColor: Colors.white
       ),
       title: "Login Screen ",
       home: LoginScreen(),

    ),
  );
}


Future<void> checkAndDeleteDocuments() async {
  // Reference to the collection
  CollectionReference collectionReference =
  FirebaseFirestore.instance.collection('your_collection_path');
  DateTime now = DateTime.now();
  // Calculate the date threshold (2 days ago)
  DateTime threshold = now.subtract(Duration(days: 2));
  // Query the collection to find documents where the date is before the threshold
  QuerySnapshot querySnapshot = await collectionReference
      .where('your_date_field', isLessThan: threshold)
      .get();
  // Iterate through the documents
  querySnapshot.docs.forEach((DocumentSnapshot documentSnapshot) {
    // Delete the document
    documentSnapshot.reference.delete();
    print('Document deleted with ID: ${documentSnapshot.id}');
  });
}


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  // This widget is the root of your application.
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool _isHidden = true;
  var login_user_id = "";
  var deviceToken = "";
  var isloading = false;
  var dbmanager = DatabaseManager();
  var firebaseinstance = FirebaseFirestore.instance;
  NotificationServices notificationServices = NotificationServices();



  Future getDeviceToken() async{
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
    String? token = await _firebaseMessaging.getToken();
    setState(() {
      deviceToken = token!;
    });
    print("device token ::::::::::::::::::::");
    print(deviceToken);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    emailController.text = "syedahad921@gmail.com";
    passwordController.text = "12345678";

    getDeviceToken();
    notificationServices.requestNotificationPermission();
    notificationServices.firebaseinit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  hexStringColor("06424c"),
                  hexStringColor("104f56"),
                  hexStringColor("19676b"),
                  hexStringColor("19676b"),
                ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.fromLTRB(10, MediaQuery
                    .of(context)
                    .size
                    .height * 0.1, 20, 0),
                child: Column(
                  children: <Widget>[
                    Container(
                        height: 200,
                        width: double.infinity,
                        //color: Colors.orange,
                        child: Center(
                            child: Padding(
                                padding: EdgeInsets.all(10),
                                child: Row(
                                  children: [
                                    const RotatedBox(
                                      quarterTurns: 3,
                                      child: Text("Sign In",
                                        style: TextStyle(
                                            fontSize: 40,
                                            color: Colors.white,
                                            letterSpacing: 3,
                                            fontWeight: FontWeight.bold
                                        ),),
                                    ),
                                    const SizedBox(width: 20),
                                    Column(
                                      children: const [
                                        Padding(padding: EdgeInsets.only(top: 30)),
                                        Text("Be a guest     ",
                                          style: TextStyle(
                                              fontSize: 30,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold
                                          ),),
                                        Text("at your own   ",
                                          style: TextStyle(
                                              fontSize: 30,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold
                                          ),),
                                        Text("event              ",
                                          style: TextStyle(
                                              fontSize: 30,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold
                                          ),),
                                      ],
                                    ),
                                  ],
                                )
                            )
                        )
                    ),
                    reusableTextField(
                        "Email", Icons.person_outline, false, emailController
                      //, false
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    reusableTextField(
                        "Password", Icons.lock_outline, true, passwordController
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    signInSignUpButton(context, true, () async{
                      setState(() {
                        isloading = true;
                      });
                      print("object ::::::::::::::::::");

                      var loginCheck = await dbmanager.LoginAuth(emailController.text, passwordController.text, deviceToken);
                      print("login user status:::::::::::::::::::::::");
                      print(loginCheck);
                      num status = loginCheck as num;
                      if(status == 2){
                        setState(() {
                          isloading = false;
                        });
                        Navigator.push(context, MaterialPageRoute(builder: (context) =>  MyHomePage(title: '',)));
                      }if(status == -1){
                        setState(() {
                          isloading = false;
                        });
                        print(status);
                        Navigator.push(context, MaterialPageRoute(builder: (context) => MyAdminHomePage(title: "Admin")));
                      }else{
                        print("error");
                      }
                    }),

                    signUpOption(),
                    const SizedBox(height: 30,),
                  ],
                ),
              ),
            ),
          ),
          // Loader
          Visibility(
            visible: isloading,
            child: Container(
              color: Colors.black.withOpacity(0.5), // Overlay color
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
        ],
      )
    );
  }

  Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have an account?",
            style: TextStyle(color: Colors.white70)),
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(
                    builder: (context) => const SignUp(title: '',)));
          },
          child: const Text(
            "  Sign Up",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),

      ],
    );


  }
}


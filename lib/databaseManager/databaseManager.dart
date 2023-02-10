import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Model {
  final String fullname;
  final String email;
  final String password;
  final String confirmpassword;
  final String userRole;

  Model({ required this.fullname, required this.email, required this.password, required this.confirmpassword, required this.userRole });
  Model.fromJson(Map<String, dynamic> json)
      : this(
    fullname: json['fullname'] as String,
    email: json['email'] as String,
    password: json['password'] as String,
    confirmpassword: json['confirmpassword'] as String,
    userRole: json['userRole'] as String,
  );

  Map<String, Object?> toJson() {
    return {
      'fullname': fullname,
      'email': email,
      'password': password,
      'confirmpassword': confirmpassword,
      'userRole': userRole

    };
  }
}
class DatabaseManager {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final CollectionReference userData = FirebaseFirestore.instance.collection(
      "users");
  bool isEmailVerified = false;
  Timer? timer;
  var userid;
  var userPic = "";
  var userNumber = "";
  var emailVerifyStatus = false;

  Future sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      await user?.sendEmailVerification();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<String?> checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    if (isEmailVerified) {
      timer?.cancel();
      print(userid);
      return userid;
    }
    return "f";
  }

  Future<void> SignupWithEmailPassword(String email, String password) async {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
        email: email,
        password: password
    ).then((value) {
      userid = (value.user?.uid)!;
      userPic = (value.user?.photoURL) ?? "null";
      userNumber = (value.user?.phoneNumber) ?? "null";
      print("start verify the email address ::::::::::::::::::::::::");
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
      if (!isEmailVerified) {
        sendVerificationEmail();
      }
    }).onError((error, stackTrace) {
      print(error.toString());
    });
  }

  Future<void> createUserData(String fullname, String email, String password,
      String confirmpass, String enrollmentno, String deptName) async {
    await userData.doc(userid).set(
        {
          'id':userid,
          'fullname': fullname,
          'email': email,
          'password': password,
          'confirmpassword': confirmpass,
          'enrollmentNo': enrollmentno,
          'deptname': deptName,
          'picture' :  "",
          'phoneNumber': userNumber,
          'age':'',
          'gender':'',
          'skillset':"",
          "projects": []
        }
    ).then((value) => print("data added ::::::::::::::"));
  }

  Future<String?> LoginAuth(emailcheck, passwordcheck) async {

    var collection = FirebaseFirestore.instance.collection('users');
    var querySnapshot = await collection.get();
    for (var queryDocumentSnapshot in querySnapshot.docs)  {
      Map<String, dynamic> data = queryDocumentSnapshot.data();
      var emails = data['email'];
      var password = data['password'];
      print(emails);
      if(emails == emailcheck) {
        /// user Data save in shared prefernce
        saveData('userBioData', data);
        return 'Successfully login';
      }
    }
    return "Poor Internet Connection";
  }

  Future<bool?> updataUserData(useridd,username,gender,age,phoneNumber,picture,enrollment,department,skillset) async {
    var updateDataStatus = false;
    await FirebaseFirestore.instance.collection('users').doc(useridd).update(
        {
          "fullname":username,
          "gender":gender,
          "age":age,
          "phoneNumber":phoneNumber,
          "picture":picture,
          "enrollmentNo":enrollment,
          "deptname":department,
          "skillset":skillset

        })
        .then((result){
      print("new User true");
      updateDataStatus = true;
      //return true;
    })
        .catchError((onError){
      print("onError");
      //return false;
    });
    print("object");
    return updateDataStatus;
  }

  Future<bool?> createFriendlyEventData(EventAuthor,name,address,sports,picture,time,date,teamsATP,teambTP,JoindePersonTeamA,JoindePersonTeamB,teamA) async{
    var newEventStatus = false;
   await _firestore.collection("events").add(
        {
          'eventAuthore':EventAuthor,
          'name':name,
          'address':address,
          'sports': sports,
          'picture':picture,
          'time':time,
          'date':date,
          'teamsATP':teamsATP,
          'teambTP': teambTP,
          'JoindePersonTeamA':JoindePersonTeamA,
          'JoindePersonTeamB':JoindePersonTeamB,
          'teamA':teamA,
          'teamB':[]

        }).then((value) async{
          print("event created ::::::::::::::::");
          await _firestore.collection("users").doc(EventAuthor)
              .update({"prijects": FieldValue.arrayUnion([value.id])});
          newEventStatus = true;



    }).onError((error, stackTrace) {
      print("event not created ::::::::::");
      print(error.toString());
      newEventStatus = false;


    });
    return newEventStatus;
  }


  /// Login user data save in shared prefernce
  saveData(String key, Map<String, dynamic> value) async {
    print("inside save data shared prefernce");
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, jsonEncode(value));
  }

  Future<dynamic> getData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    print("isnide get function ::::::::::::::::::::::::::::::");
    print(prefs.get(key));
    return prefs.get(key);
  }

  }


















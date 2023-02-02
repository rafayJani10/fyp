import 'dart:async';
import 'dart:convert';
// import 'dart:ffi';
// import 'dart:html';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  final CollectionReference userData = FirebaseFirestore.instance.collection(
      "users");
  bool isEmailVerified = false;
  Timer? timer;
  var userid = "";
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

  Future<bool?> checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    if (isEmailVerified) {
      timer?.cancel();
      return true;
    }
    return false;
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
      String confirmpass, String userrole) async {

    await userData.doc(userid).set(
        {
          'fullname': fullname,
          'email': email,
          'password': password,
          'confirmpassword': confirmpass,
          'userRole': userrole,
          'picture' :  "https://www.pngitem.com/pimgs/m/168-1686201_clip-art-headshot-person-placeholder-image-png-transparent.png",
          'phoneNumber': userNumber
        }
    ).then((value) => print("data added ::::::::::::::"));
  }

  Future<bool?> LoginAuth(emailcheck, passwordcheck) async {

    var collection = FirebaseFirestore.instance.collection('users');
    var querySnapshot = await collection.get();
    for (var queryDocumentSnapshot in querySnapshot.docs) {
      Map<String, dynamic> data = queryDocumentSnapshot.data();
      var emails = data['email'];
      var password = data['password'];
      print(emails);

      if(emails == emailcheck) {
        /// user Data save in shared prefernce
        saveData('userBioData', data);
        return true;
      }

    }
    return false;
  }

  /// Login user data save in shared prefernce
  saveData(String key, Map<String, dynamic> value) async {
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

















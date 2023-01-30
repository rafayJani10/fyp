import 'package:cloud_firestore/cloud_firestore.dart';


class DatabaseManager {
  final CollectionReference userData = FirebaseFirestore.instance.collection("users");

  Future<void> createUserData(userid, String fullname, String email, String password, String confirmpass)async {
    await userData.doc(userid).set(
        {
          'fullname' : fullname,
          'email': email,
          'password': password,
          'confirmpassword': confirmpass
        }
    ).then((value) => print("data added ::::::::::::::"));

  }

  Future<void> getUsersData()async {

  }


}
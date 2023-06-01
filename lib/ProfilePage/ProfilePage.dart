
import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../UIcomponents/UIcomponents.dart';
import '../databaseManager/databaseManager.dart';

import '../homepage/SideBar/SideMenuBar.dart';
import '../services/twoFactorVerifications.dart';
import 'package:intl/intl.dart';



class ProflePage extends StatefulWidget {
  ProflePage({Key? key}) : super(key: key);

  @override
  State<ProflePage> createState() => _ProflePageState();
}



class _ProflePageState extends State<ProflePage> {

  File? _image;
  final  dbmanager = DatabaseManager();
  late final Map<String,dynamic> dataa;
  final _firebaseStorage = FirebaseStorage.instance;
  var imageurlfromfirestore = "";
  late File _imageFile;

  var user_id = "";
  var full_nameu ;
  var genderu = "";
  var ageeu = "";
  var PhoneNou = "";
  var pictureu = "";
  var enrollmentu = "";
  var departmentu = "";
  var skillsetu = "" ;

  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController enrollmentController = TextEditingController();
  TextEditingController departmentController = TextEditingController();
  TextEditingController skillsetController = TextEditingController();


  void startPhoneAuth(phoneeNumber) {
    String phoneNumber = phoneeNumber;
    if (phoneNumber.isNotEmpty) {
      var formattedPhonenumber = "+92" + phoneNumber;
      startPhoneAuthVerification(formattedPhonenumber);
    } else {
      // Handle empty phone number input
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Please enter a valid phone number.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
  void startPhoneAuthVerification(String phoneNumber) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    await auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await auth.signInWithCredential(credential);
        // Handle authentication success
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Success'),
              content: Text('Phone authentication successful.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      },
      verificationFailed: (FirebaseAuthException e) {
        // Verification failed
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Phone authentication failed. ${e.message}'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      },
      codeSent: (verificationId, resendToken) {
        // Save the verification ID and navigate to the verification code screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VerificationCodeScreen(
              verificationId: verificationId,
              userid: user_id,
              phoneno: phoneNumber,
            ),
          ),
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        // Called when the SMS code auto-retrieval times out
        print('Verification timeout');
      },
    );
  }
  Future<dynamic> getUserData() async{
    var data =  await dbmanager.getData('userBioData');
    var daaa = json.decode(data);
    var useridd = "";
    setState(() {
      dataa = daaa;
      print("lllllllllllllllllll");
      print(daaa);
      useridd = dataa['id'];
      user_id =  dataa['id'];
      print(dataa['id']);
    });
    getuserrDataup(useridd);
  }
  Future getuserrDataup(String id) async{
    var collection = FirebaseFirestore.instance.collection('users');
    var docSnapshot = await collection.doc(id).get();
    if (docSnapshot.exists) {
      Map<String, dynamic>? data = docSnapshot.data();
      dbmanager.saveData('userBioData', data!);
      setState(()  {
        print(data!['fullname']);
        full_nameu = data?['fullname'] ?? "Full name";
        genderu = data!['gender'] ?? "Gender";
        ageeu = data!['age'] ?? "Age";
        PhoneNou = data!['phoneNumber'] ?? "Phone Number";
        pictureu = data!['picture'];
         enrollmentu = data!['enrollmentNo'] ?? "Enrollment No";
         departmentu = data!['deptname'] ?? "Department Name";
         skillsetu = data!['skillset'] ?? "Skill Set";
      });
    }
  }
  Future getImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) {
      return;
    }

    final imageTemporary = File(image.path);
    if (image != null) {
      //Upload to Firebase
      var snapshot = await _firebaseStorage.ref()
          .child('image/$imageTemporary')
          .putFile(imageTemporary);
      var downloadUrl = await snapshot.ref.getDownloadURL();
      setState(() {
        _image = imageTemporary;

        print('::::::::::: image ::::');
        print(downloadUrl);
        imageurlfromfirestore = downloadUrl;

      });
    }
  }
  Future updateData(userId,full_name,gender,agee,PhoneNo,picture,enrollment,department,skillset) async {
    var updateDataa = await dbmanager.updataUserData(userId,full_name,gender,agee,PhoneNo,picture,enrollment,department,skillset);
    if(updateDataa! == true){
      print("dataa updated");
      showAlertDialog(context,"Done","Data Updated Successfully");
      dbmanager.saveData('userBioData', dataa);
    }else{
      print("data not updated");
      showAlertDialog(context,"Error","Data Not Updated ");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
   // getuserrDataup();

  }

  @override
  Widget build(BuildContext context) {
    //getUserData();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        backgroundColor: Colors.teal[900],
      ),
      body: Column(
        children: [
          Flexible(
              flex: 1,
              child: Container(
                width: double.infinity,
                //color: Colors.green,
                child: Center(
                  child: CircleAvatar(
                      radius: 70,
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 70,
                            backgroundColor: Colors.grey, // Placeholder color
                            backgroundImage: dataa["picture"] != null
                                ? NetworkImage(dataa["picture"])
                                : NetworkImage("https://st3.depositphotos.com/6672868/13701/v/450/depositphotos_137014128-stock-illustration-user-profile-icon.jpg"), // Use NetworkImage only when imageUrl is not null
                          ),
                          Align(
                              alignment: FractionalOffset.bottomRight,
                              child: InkWell(
                                onTap: (){
                                  getImage();
                                },
                                child: Container(
                                  margin: EdgeInsetsDirectional.only(bottom: 2),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.teal[900],
                                  ),
                                  height: 50,
                                  width: 50,
                                  child: const Center(
                                    child: Icon(
                                      Icons.camera_alt,
                                      color: Colors.white,
                                      size: 25,
                                    ),
                                  ),
                                ),
                              )
                          )
                        ],
                      )
                  ),
                ),
              )),
          Flexible(
              flex: 3,
              child: Container(
                  width: double.infinity,
                  // color: Colors.red,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(15),
                          child: TextField(
                            controller: userNameController,
                            decoration: InputDecoration(
                              labelStyle:   TextStyle(
                                  color: Colors.black
                              ),
                              border: OutlineInputBorder(),
                              labelText: "Full Name" ,
                              hintText: dataa["fullname"],
                              hintStyle: TextStyle(color: Colors.grey),
                              fillColor: Colors.white54,
                              //filled: true

                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(15),
                          child: TextField(
                            //enabled: false,
                            controller: emailController,
                            decoration: InputDecoration(
                              labelStyle:   TextStyle(
                                  color: Colors.black
                              ),
                              border: OutlineInputBorder(),
                              labelText: "Email",
                              hintText: dataa['email'],
                              hintStyle: TextStyle(color: Colors.grey),
                              fillColor: Colors.white54,
                             // hintText: "userName",
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(15),
                          child: TextField(
                            controller: enrollmentController,
                            decoration: InputDecoration(
                              labelStyle: TextStyle(
                                  color: Colors.black
                              ),
                              border: OutlineInputBorder(),
                              labelText: "Enrollment No",
                              hintText: dataa["enrollmentNo"],
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(15),
                          child: TextField(
                            controller: departmentController,
                            decoration: InputDecoration(
                              labelStyle: TextStyle(
                                  color: Colors.black
                              ),
                              border: OutlineInputBorder(),
                              labelText: "department Name",
                              hintText: dataa["deptname"],
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(15),
                          child: TextField(
                            controller: ageController,
                            decoration: InputDecoration(
                              labelStyle:   TextStyle(
                                  color: Colors.black
                              ),
                              border: OutlineInputBorder(),
                              labelText: "Age",
                              hintText: dataa["age"],
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(15),
                          child: TextField(
                            controller: genderController,
                            decoration: InputDecoration(
                                labelStyle:   TextStyle(
                                    color: Colors.black
                                ),
                              border: OutlineInputBorder(),
                              labelText: "gender",
                              hintText: dataa["gender"],
                              hintStyle: TextStyle(color: Colors.grey),

                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(15),
                          child: TextField(
                            controller: phoneNumberController,
                            decoration: InputDecoration(
                              labelStyle: TextStyle(
                                  color: Colors.black
                              ),
                              border: OutlineInputBorder(),
                              labelText: "Phone Number",
                              hintText: dataa["phoneNumber"],
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(15),
                          child: TextField(

                            controller: skillsetController,
                            decoration: InputDecoration(

                              labelStyle: TextStyle(
                                  color: Colors.black
                              ),
                              border: OutlineInputBorder(),
                              labelText: "Game Skill",
                              hintText: dataa["skillset"],
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),

                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.teal[900],
                            onPrimary: Colors.white,
                            shadowColor: Colors.green,
                            elevation: 6,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(32.0)),
                            minimumSize: Size(200, 50), //////// HERE
                          ),
                          onPressed: () {
                            var full_name = userNameController.text == "" ? full_nameu: userNameController.text;
                            var gender = genderController.text == "" ?dataa['gender'] : genderController.text;
                            var agee = ageController.text == "" ? dataa['age'] : ageController.text;
                            var PhoneNo = phoneNumberController.text == "" ? dataa['phoneNumber'] : phoneNumberController.text;
                            var picture = imageurlfromfirestore == "" ?pictureu: imageurlfromfirestore;
                            var enrollment = enrollmentController.text == "" ? dataa['enrollmentNo'] : enrollmentController.text;
                            var department = departmentController.text == "" ? dataa['deptname'] : departmentController.text;
                            var skillset = skillsetController.text == "" ? dataa['skillset'] :  skillsetController.text;
                            updateData(dataa['id'],full_name,gender,agee,PhoneNo,picture,enrollment,department,skillset);
                            getuserrDataup(dataa['id']);


                           //  if(dataa['phoneNumber'] == ""){
                           //   print("no number found");
                           //   // startPhoneAuth(PhoneNo);
                           //   // Navigator.push(
                           //   //   context,
                           //   //   MaterialPageRoute(builder: (context) =>  VerificationCodeScreen()),
                           //   // );
                           //
                           // }else{
                           //   print("yes");
                           //   // updateData(dataa['id'],full_name,gender,agee,PhoneNo,picture,enrollment,department,skillset);
                           //   // getuserrDataup(dataa['id']);
                           // }



                          },
                          child: Text('Update'),
                        ),
                        SizedBox(height: 30,)
                      ],
                    ),
                  )
              )
          )
        ],
      ),
    );
  }
}




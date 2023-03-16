
import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../UIcomponents/UIcomponents.dart';
import '../databaseManager/databaseManager.dart';

import '../homepage/SideBar/SideMenuBar.dart';


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

  var full_nameu ;
  var genderu = "";
  var ageeu = "";
  var PhoneNou = "";
  var pictureu = "";
  var enrollmentu = "";
  var departmentu = "";
  var skillsetu = "" ;

  TextEditingController userNameController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController enrollmentController = TextEditingController();
  TextEditingController departmentController = TextEditingController();
  TextEditingController skillsetController = TextEditingController();


  Future<dynamic> getUserData() async{
    var data =  await dbmanager.getData('userBioData');
    var daaa = json.decode(data);
    var useridd = "";
    setState(() {
      dataa = daaa;
      print("lllllllllllllllllll");
      print(daaa);
      useridd = dataa['id'];
      print(dataa['id']);
    });
    getuserrDataup(useridd);
  }
  Future getuserrDataup(String id) async{
    var collection = FirebaseFirestore.instance.collection('users');
    var docSnapshot = await collection.doc(id).get();
    if (docSnapshot.exists) {
      Map<String, dynamic>? data = docSnapshot.data();
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
                      backgroundColor: Colors.teal,
                      child: Stack(
                        children: [
                          Center(
                            child: CircleAvatar(
                              radius: 69,
                              backgroundColor: Colors.teal,
                              child: ClipOval(
                                child: _image != null
                                    ? Image.file(_image! ,width: 130,height: 130, fit: BoxFit.fill)
                                    : Image.network(pictureu, fit: BoxFit.fill),
                              ),
                            ),
                          ),
                          Align(
                              alignment: FractionalOffset.bottomRight,
                              child: InkWell(
                                onTap: (){
                                  getImage();
                                },
                                child: Container(
                                  margin: EdgeInsetsDirectional.only(bottom: 10),
                                  height: 50,
                                  width: 50,
                                  color: Colors.white12,
                                  child: Center(
                                    child: Icon(
                                      Icons.camera_alt,
                                      color: Colors.grey,
                                      size: 40,
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
                            enabled: false,
                            //controller: nameController,
                            decoration: InputDecoration(
                              labelStyle:   TextStyle(
                                  color: Colors.black
                              ),
                              border: OutlineInputBorder(),
                              labelText: dataa['email'] ?? "email",
                             // hintText: "userName",
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(15),
                          child: TextField(
                            controller: userNameController,
                            decoration: InputDecoration(
                              labelStyle:   TextStyle(
                                  color: Colors.black
                              ),
                              border: OutlineInputBorder(),
                              labelText: full_nameu ,
                              hintText: "Full Name",
                              hintStyle: TextStyle(color: Colors.black12),
                              fillColor: Colors.white54,
                              //filled: true

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
                              labelText: enrollmentu,
                              hintText: "Enrollment No",
                              hintStyle: TextStyle(color: Colors.black12),
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
                              labelText: departmentu,
                              hintText: "Department Name",
                              hintStyle: TextStyle(color: Colors.black12),
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
                              labelText: ageeu,
                              hintText: "Age",
                              hintStyle: TextStyle(color: Colors.black12),
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
                              labelText: genderu,
                              hintText: "Male or Female",
                              hintStyle: TextStyle(color: Colors.black12),

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
                              labelText: PhoneNou,
                              hintText: "Mobile Number",
                              hintStyle: TextStyle(color: Colors.black12),
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
                              labelText: skillsetu,
                              hintText: "Game Name and Game Skill",
                              hintStyle: TextStyle(color: Colors.black12),
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

                            print(full_name);
                            print(gender);
                            print(agee);
                            print(PhoneNo);
                            updateData(dataa['id'],full_name,gender,agee,PhoneNo,picture,enrollment,department,skillset);
                            getuserrDataup(dataa['id']);


                            // var updateData = await dbmanager.updataUserData(dataa['id'],full_name,gender,agee,PhoneNo);
                            // if (updateData == true){
                            //   print("data saved");
                            //   showAlertDialog(context,"Done","Data Updated Successfully");
                            //   dbmanager.saveData('userBioData', dataa);
                            //   getUserData();
                            // }else{
                            //   //showAlertDialog(context,"Error!","Data Not Updated");
                            //   print("error");
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


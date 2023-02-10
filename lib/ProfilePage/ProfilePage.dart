
import 'dart:convert';
import 'dart:io';
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
    setState(() {
      dataa = daaa;
      print("lllllllllllllllllll");
      print(daaa);
      print(dataa['id']);
    });
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
      // getUserData();
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
                                    : Image.network(dataa['picture'], fit: BoxFit.fill),
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
                              hintText: "userName",
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
                              labelText: dataa['fullname'] != "" ?dataa['fullname'] : "Full Name",
                              //hintText: "Full Name",
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
                              labelText: dataa["enrollmentNo"]  != "" ? dataa["enrollmentNo"] : "Enrollment No",
                              hintText: "Enrollment No",
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
                              labelText: dataa["deptname"]  != "" ? dataa["deptname"] : "Deptartment Name",
                              hintText: "Department Name",
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
                              labelText: dataa['age']  != "" ? dataa['age'] :'Age',
                              //hintText: "age",
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
                              labelText: dataa['gender'] != "" ? dataa['gender'] :"Gender",
                              hintText: "Male or Female",

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
                              labelText: dataa["phoneNumber"]  != "" ? dataa["phoneNumber"] : "Phone Number",
                              hintText: "Mobile Number",
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
                              labelText: dataa["skillset"]  != "" ? dataa["skillset"] : "Skill Set",
                              hintText: "Game Name and Game Skill",
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
                            var full_name = userNameController.text == "" ? dataa['fullname']: userNameController.text;
                            var gender = genderController.text == "" ?dataa['gender'] : genderController.text;
                            var agee = ageController.text == "" ? dataa['age'] : ageController.text;
                            var PhoneNo = phoneNumberController.text == "" ? dataa['phoneNumber'] : phoneNumberController.text;
                            var picture = imageurlfromfirestore;
                            var enrollment = enrollmentController.text == "" ? dataa['enrollmentNo'] : enrollmentController.text;
                            var department = departmentController.text == "" ? dataa['deptname'] : departmentController.text;
                            var skillset = skillsetController.text == "" ? dataa['skillset'] :  skillsetController.text;

                            print(full_name);
                            print(gender);
                            print(agee);
                            print(PhoneNo);
                            updateData(dataa['id'],full_name,gender,agee,PhoneNo,picture,enrollment,department,skillset);

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


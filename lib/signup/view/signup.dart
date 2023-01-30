import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fyp/homepage/homepage.dart';
import 'package:fyp/color_utils.dart';
import 'package:fyp/signup/view/signup.dart';
import 'package:fyp/signup/view/signup.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../databaseManager/databaseManager.dart';
import '../../useable.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Signup Screen ",
      home: SignUp(title: '',),
    ),
  );
}
enum userselect {Student , Organiser}
class SignUp extends StatefulWidget {
  const SignUp({super.key, required String title});


@override
State<SignUp> createState() => _SignUpState();

}

class _SignUpState extends State<SignUp> {

  var dbmanager = DatabaseManager();
  TextEditingController fullnameController = TextEditingController();
  TextEditingController EnrollmentIdController = TextEditingController();
  TextEditingController EmailController = TextEditingController();
  TextEditingController PasswordController = TextEditingController();
  TextEditingController ConfirmPasswordController = TextEditingController();
 userselect? user = userselect.Student;




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery
            .of(context)
            .size
            .width,
        height: MediaQuery
            .of(context)
            .size
            .height,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              hexStringColor("163ABB"),
              hexStringColor("061A62")
              //  hexStringColor("69EFF8")
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, MediaQuery
                .of(context)
                .size
                .height * 0.2, 20, 0),
            child: Column(
              children: <Widget>[
               Container(
                width: 200,
                 height: 55,
                 decoration: BoxDecoration(

                       borderRadius: BorderRadius.circular(30.0),
                       color: Colors.white70.withOpacity(0.3),

                       //borderSide: const BorderSide(width: 0, style: BorderStyle.none)

                 ),
                child: ListTile(

                  title: const Text('Student',
                    style: TextStyle(color: Colors.white,
                    fontSize: 16,
                      fontWeight: FontWeight.normal
                    ),


                  ),
                  leading: Radio<userselect>(
                    fillColor: MaterialStateColor.resolveWith((states) => Colors.white70),
                    value: userselect.Student,
                    groupValue: user,
                    onChanged: (userselect? value) {
                      setState(() {
                        user = value;
                      });
                    },
                  ),
                ),),
                SizedBox(
                  height: 10,
                ),

                Container(
                  width: 200,
                  height: 55,
                  decoration: BoxDecoration(

                    borderRadius: BorderRadius.circular(30.0),
                    color: Colors.white70.withOpacity(0.3),

                    //borderSide: const BorderSide(width: 0, style: BorderStyle.none)

                  ),
                  child: ListTile(

                    title: const Text('Organiser',
                      style: TextStyle(color: Colors.white,
                          fontSize: 16,
                          //fontWeight: FontWeight.normal
                      ),


                    ),
                    leading: Radio<userselect>(
                      fillColor: MaterialStateColor.resolveWith((states) => Colors.white70),
                      value: userselect.Organiser,
                      groupValue: user,
                      onChanged: (userselect? value) {
                        setState(() {
                          user = value;
                        });
                      },
                    ),
                  ),),
                SizedBox(
                  height: 30,
                ),

                reusableTextField("Full Name", Icons.person_outline, false,
                    fullnameController),
                SizedBox(
                  height: 30,
                ),
                reusableTextField(
                    "Email", Icons.email_outlined, false, EmailController),
                SizedBox(
                  height: 30,
                ),
                reusableTextField(
                    "Password", Icons.lock_outline, true, PasswordController),
                SizedBox(
                  height: 30,
                ),
                reusableTextField(
                    "Confirm Password", Icons.lock_outline, true, ConfirmPasswordController),
                SizedBox(
                  height: 30,
                ),
                signInSignUpButton(context, false, () async{
                  CollectionReference userdata = FirebaseFirestore.instance.collection("users");
                  await FirebaseAuth.instance
                  .createUserWithEmailAndPassword(
                      email: EmailController.text,
                      password: PasswordController.text
                  )
                  .then((value) async {
                   print( value.user?.uid);
                   print("Created New Account");

                    // add users
                    dbmanager.createUserData(value.user?.uid,fullnameController.text, EmailController.text, PasswordController.text, ConfirmPasswordController.text);








                    // FirebaseFirestore.instance.collection('UserData').doc(value.user?.uid).add(
                    //     {
                    //       "email":value.user?.email,
                    //       "username": fullnameController.text
                    //     }).then((value) {
                    //   print("data save in data stored");
                    //   });

                    Navigator.push(context, MaterialPageRoute(builder: (context) =>  MyHomePage(title: '',)));
                  }).onError((error, stackTrace) {
                    print("Error ${error.toString()}");

                  });


                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
//         child: Scaffold(
//        //   backgroundColor: Color(0xFF163ABB),
//           body: ListView(
//             children: [
//               Container(
//                 decoration: BoxDecoration(gradient: LinearGradient(colors: [
//                   hexStringColor("163ABB"),
//                   hexStringColor("061A62")
//             //  hexStringColor("69EFF8")
//
//             ]),),
//               child: SizedBox(
//                 width: double.infinity,
//                 height: MediaQuery.of(context).size.height / 5,
//                 // child: Image.asset('lib/images/facebook.png'),
//               ),),
//               //Expanded(
//               Container(
// //                    height: 200,
//                 width: double.infinity,
//                 decoration:   BoxDecoration(
//                   gradient: LinearGradient(colors: [
//                     hexStringColor("163ABB"),
//                     hexStringColor("061A62")
//                     //  hexStringColor("69EFF8")
//
//                   ]
//
//
//                   ),
//                   // borderRadius: const BorderRadius.only(
//                   //   topLeft: Radius.circular(30),
//                   //   topRight: Radius.circular(30),
//                   // ),
//
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(20.0),
//                   child: SingleChildScrollView(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // Text(
//                         //   'Full Name',
//                         //   style: TextStyle(
//                         //     color: Colors.black,
//                         //     fontSize: 20,
//                         //     fontWeight: FontWeight.bold,
//                         //   ),
//                         // ),
//                         const SizedBox(height: 10),
//
//                         Container(
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(12),
//                             color: Colors.black,
//                           ),
//
//                           child: TextField(
//                             controller: fullnameController,
//                             style: const TextStyle(color: Colors.white),
//                             decoration: const InputDecoration(
//                               border: InputBorder.none,
//                               prefixIcon: Icon(
//                                 Icons.perm_identity_rounded,
//                                 color: Colors.white,
//                               ),
//
//                               hintText: 'Full Name',
//                               hintStyle: TextStyle(color: Colors.white),
//                               //   validator: (String? value) {
//
//                               // }
//                             ),
//                           ),
//                         ),
//
//                         //<----------------------->//
//                         // SizedBox(height: 15),
//                         // const Text(
//                         //   'Password',
//                         //   style: TextStyle(
//                         //     color: Colors.black,
//                         //     fontSize: 20,
//                         //     fontWeight: FontWeight.bold,
//                         //
//                         //   ),
//                         // ),
//                         const SizedBox(height: 15),
//                         Container(
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(12),
//                             color: Colors.black,
//                           ),
//                           child: TextField(
//                             controller: EnrollmentIdController,
//                             style: const TextStyle(color: Colors.white),
//                             decoration: const InputDecoration(
//                               border: InputBorder.none,
//                               prefixIcon: Icon(
//                                 Icons.badge_outlined,
//                                 color: Colors.white,
//                               ),
//                               hintText: 'Enrollment Id',
//                               hintStyle: TextStyle(color: Colors.white),
//                             ),
//                           ),
//                         ),
//                         //<--------------------->//
//                         const SizedBox(height: 15),
//                         Container(
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(12),
//                             color: Colors.black,
//                           ),
//                           child: TextField(
//                             controller: EmailController,
//                             style: const TextStyle(color: Colors.white),
//                             decoration: const InputDecoration(
//                               border: InputBorder.none,
//                               prefixIcon: Icon(
//                                 Icons.email_outlined,
//                                 color: Colors.white,
//                               ),
//                               hintText: 'Email',
//                               hintStyle: TextStyle(color: Colors.white),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 15),
//                         Container(
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(12),
//                             color: Colors.black,
//                           ),
//                           child: TextField(
//                             controller: PasswordController,
//                             style: const TextStyle(color: Colors.white),
//                             decoration: const InputDecoration(
//                               border: InputBorder.none,
//                               prefixIcon: Icon(
//                                 Icons.lock,
//                                 color: Colors.white,
//                               ),
//                               hintText: 'Password',
//                               hintStyle: TextStyle(color: Colors.white),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 15),
//                         Container(
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(12),
//                             color: Colors.black,
//                           ),
//                           child: TextField(
//                             controller: ConfirmPasswordController,
//                             style: const TextStyle(color: Colors.white),
//                             decoration: const InputDecoration(
//                               border: InputBorder.none,
//                               prefixIcon: Icon(
//                                 Icons.lock_clock,
//                                 color: Colors.white,
//                               ),
//                               hintText: 'Confirm Password',
//                               hintStyle: TextStyle(color: Colors.white),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//
//
//               ),
//            //   const SizedBox(height: 10),
//               Container(
//                 decoration: BoxDecoration(gradient: LinearGradient(colors: [
//                   hexStringColor("163ABB"),
//                   hexStringColor("061A62")
//                   //  hexStringColor("69EFF8")
//
//                 ]),),
//               child: GestureDetector(
//
//
//                 onTap: () {
//                   // String email = emailController.text;
//                   // String pass = passwordController.text;
//                   Navigator.push(context,
//                       MaterialPageRoute(
//
//                           builder: (context) => const MyHomePage(title: '',)));
//                 },
//                 child: Container(
//
//                   margin: const EdgeInsets.only(left: 10, top: 30, right: 10, bottom: 5),
//
//                   decoration: BoxDecoration(
//
//
//                     borderRadius: BorderRadius.circular(30),
//                     color: Colors.black,
//                   ),
//                   child: const Center(
//                     child: Padding(
//                       padding: EdgeInsets.all(10.0),
//                       child: Text(
//                         ' Sign Up',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 30,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//
//                     ),
//                   ),
//                 ),
//               ),),
//            Container(
//            decoration: BoxDecoration(gradient: LinearGradient(colors: [
//     hexStringColor("163ABB"),
//     hexStringColor("061A62")
//     //  hexStringColor("69EFF8")
//
//     ]),),
//                child: const SizedBox(
//
//                  height:200),
//
//            ),
//             ],
//           )
//     ));
//   }
// //
//
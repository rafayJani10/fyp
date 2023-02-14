import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fyp/admin/adminhomepage.dart';
import 'package:fyp/color_utils.dart';
import 'package:fyp/databaseManager/databaseManager.dart';
// import 'SecondScreen.dart';
import 'package:fyp/homepage/homepage.dart';
import 'package:fyp/services/firebase_services.dart';
import 'package:fyp/signup/view/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../UIcomponents/UIcomponents.dart';
import '../../useable.dart';

void main()  async{
  WidgetsFlutterBinding.ensureInitialized();
 await Firebase.initializeApp();
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

  var dbmanager = DatabaseManager();

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
                //, true
                // ),
                // TextField(n

                //   controller: passwordController,
                //   obscureText: ,


                ),
                const SizedBox(
                  height: 30,
                ),

                // TextField(
                //   obscureText: _isHidden,
                //   decoration: InputDecoration(
                //     hintText: 'Password',
                //     suffix: InkWell(
                //       onTap: obscure,
                //       child: Icon( Icons.visibility),
                //     ),
                //   ),
                // ),
                signInSignUpButton(context, true, () async{
                  print("object ::::::::::::::::::");
                  // emailController.text = "amnarehman3759@gmail.com";
                  // passwordController.text = "Amna3759";
                  if(emailController.text == "busportsadmin@bukc.com" && passwordController.text == "@Admin"){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => MyAdminHomePage(title: "Admin")));
                  }else{
                    var loginCheck = await dbmanager.LoginAuth(emailController.text, passwordController.text);
                    print(loginCheck);
                    if (loginCheck ==  'Successfully login'){
                      print(loginCheck);
                      Navigator.push(context, MaterialPageRoute(builder: (context) =>  MyHomePage(title: '',)));
                    }else if (loginCheck == "Poor Internet Connection"){
                      showAlertDialog(context,"Verification Failed", "Your email or password is incorrect. Please try again.");
                    }
                  }
                }),

                signUpOption(),
                const SizedBox(height: 30,),
              ],
            ),
          ),
        ),
      ),
    );
  }
  // void obscure() {
  //   setState(() {
  //     _isHidden = !_isHidden;
  //   });
  // }
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
        // const SizedBox(
        //   height: 10,
        //
        // ),
        // Text("Login With Google", style: TextStyle(color: Colors.white70)),
        // const SizedBox(
        //   height: 10,
        //
        // ),
        // GestureDetector(
        //   onTap:() async {
        //     await FirebaseServices().signInWithGoogle();
        //     Navigator.push(context,
        //         MaterialPageRoute(
        //             builder: (context) => MyHomePage(title: '',)));
        // },
        //   child:
        //   Image.asset('assets/images/googlecolor.png', width: 40, height: 40,),
        // )

      ],
    );


  }
}


    //   child: Scaffold(
    //
    //  //   backgroundColor:
    //    // const Color(0xFF163ABB),
    //     body:
    //
    //     ListView(
    //       children: [ Container(
    //         decoration: BoxDecoration(gradient: LinearGradient(colors: [
    //           hexStringColor("163ABB"),
    //           hexStringColor("061A62")
    //           //  hexStringColor("69EFF8")
    //
    //         ]),),
    //         child: const SizedBox(
    //
    //             height:100),
    //
    //       ),
    //         Container(decoration: BoxDecoration(gradient: LinearGradient(colors: [
    //           hexStringColor("163ABB"),
    //           hexStringColor("061A62")
    //         //  hexStringColor("69EFF8")
    //
    //         ]),),
    //
    //         child: SizedBox(
    //           width: double.infinity,
    //           height: MediaQuery.of(context).size.height / 5,
    //          // child: Image.asset('lib/images/facebook.png'),
    //         ),),
    //         Expanded(
    //           child: Container(
    //
    //             width: double.infinity,
    //             decoration:  BoxDecoration(
    //               // borderRadius: const BorderRadius.only(
    //               //   topLeft: Radius.circular(30),
    //               //   topRight: Radius.circular(30),
    //               // ),
    //               gradient: LinearGradient(colors: [
    //                 hexStringColor("163ABB"),
    //                 hexStringColor("061A62")
    //               //  hexStringColor("69EFF8")
    //
    //               ]
    //
    //
    //             ),),
    //             child: Padding(
    //               padding: const EdgeInsets.all(20.0),
    //               child: SingleChildScrollView(
    //                 child: Column(
    //                   crossAxisAlignment: CrossAxisAlignment.start,
    //                   children: [
    //
    //                     // const Text(
    //                     //   'Email',
    //                     //   style: TextStyle(
    //                     //     color: Colors.black,
    //                     //     fontSize: 20,
    //                     //     fontWeight: FontWeight.bold,
    //                     //   ),
    //                     // ),
    //                     const SizedBox(height: 10),
    //
    //                     Container(
    //                       decoration: BoxDecoration(
    //                         borderRadius: BorderRadius.circular(12),
    //                         color: Colors.black,
    //                       ),
    //
    //                       child: TextField(
    //                         controller: emailController,
    //                         style: const TextStyle(color: Colors.white),
    //                         decoration: const InputDecoration(
    //                           border: InputBorder.none,
    //                           prefixIcon: Icon(
    //                             Icons.email,
    //                             color: Colors.white,
    //                           ),
    //
    //                           hintText: 'Email',
    //                           hintStyle: TextStyle(color: Colors.white),
    //
    //                        //   validator: (String? value) {
    //
    //                          // }
    //                         ),
    //                       ),
    //                     ),
    //                     // const SizedBox(height: 15),
    //                     // const Text(
    //                     //   'Password',
    //                     //   style: TextStyle(
    //                     //     color: Colors.black,
    //                     //     fontSize: 20,
    //                     //     fontWeight: FontWeight.bold,
    //                     //
    //                     //   ),
    //                     // ),
    //                     const SizedBox(height: 15),
    //                     Container(
    //                       decoration: BoxDecoration(
    //                         borderRadius: BorderRadius.circular(12),
    //                         color: Colors.black,
    //                       ),
    //                       child: TextFormField(
    //                         controller: passwordController,
    //                         style: const TextStyle(color: Colors.white),
    //                         decoration: const InputDecoration(
    //                           border: InputBorder.none,
    //                           prefixIcon: Icon(
    //                             Icons.lock,
    //                             color: Colors.white,
    //                           ),
    //                           // validator: (value) {
    //                           //   if (value == null || value.isEmpty) {
    //                           //     return 'Please enter some text';
    //                           //   }
    //                           //   return null;
    //                           // },
    //                           hintText: 'Password',
    //                           hintStyle: TextStyle(color: Colors.white),
    //                         ),
    //                       ),
    //                     ),
    //                     const SizedBox(height: 35),
    //                     GestureDetector(
    //                       onTap: () {
    //                        // String email = emailController.text;
    //                         // String pass = passwordController.text;
    //                       Navigator.push(context,
    //                          MaterialPageRoute(
    //
    //                             builder: (context) => const MyHomePage(title: '',)));
    //                       },
    //                       child: Container(
    //                         decoration: BoxDecoration(
    //                           borderRadius: BorderRadius.circular(30),
    //                           color: Colors.black,
    //                         ),
    //                         child: const Center(
    //                           child: Padding(
    //                             padding: EdgeInsets.all(10.0),
    //                             child: Text(
    //                               ' Log In',
    //                               style: TextStyle(
    //                                 color: Colors.white,
    //                                 fontSize: 30,
    //                                 fontWeight: FontWeight.w500,
    //                               ),
    //                             ),
    //
    //                           ),
    //                         ),
    //                       ),
    //                     ),
    //
    //                     const SizedBox(height: 30),
    //                     const Center(
    //                       child: Text(
    //                         "Don't have an account ?",
    //                         style: TextStyle(
    //                           color: Colors.black,
    //                           fontSize: 20,
    //                           fontWeight: FontWeight.w500,
    //                         ),
    //                       ),
    //                     ),
    //                     const SizedBox(height: 10),
    //                  GestureDetector(
    //                    onTap: () {
    //                      // String email = emailController.text;
    //                      // String pass = passwordController.text;
    //                      Navigator.push(context,
    //                          MaterialPageRoute(
    //
    //                              builder: (context) => const SignUp(title: '',)));
    //                    },
    //                  child: const Center(
    //                    child: Padding(
    //                      padding: EdgeInsets.all(10.0),
    //                  child: Text(
    //                    "SignUp",
    //                    style: TextStyle(
    //                      color: Color(0xFF69EFF8),
    //                      fontSize: 20,
    //                      fontWeight: FontWeight.w800,
    //
    //                    ),
    //                  ),
    //                  ),
    //
    //
    //                  ),),
    //                     Container(
    //                       decoration: BoxDecoration(gradient: LinearGradient(colors: [
    //                         hexStringColor("163ABB"),
    //                         hexStringColor("061A62")
    //                         //  hexStringColor("69EFF8")
    //
    //                       ]),),
    //                       child: const SizedBox(
    //
    //                           height:200),
    //
    //                     ),
    //                   ],
    //                 ),  ),
    //               ),
    //             ),
    //
    //           ),
    //
    //         ],
    //     ),
    //   ),
    // );
//   }
// }

// mixin InputValidationMixin {
//   bool isPasswordValid(String password) => password.length == 6;
//
//   bool isEmailValid(String email) {
//     Pattern pattern =
//         r '^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
//     RegExp regex = new RegExp(pattern);
//     return regex.hasMatch(email);
//   }
// }

import 'package:flutter/material.dart';
import 'package:fyp/homepage/homepage.dart';
import 'package:fyp/color_utils.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Signup Screen ",
      home: SignUp(title: '',),
    ),
  );
}

class SignUp extends StatefulWidget {
  const SignUp({super.key, required String title});


@override
State<SignUp> createState() => _SignUpState();

}

class _SignUpState extends State<SignUp>{
  TextEditingController fullnameController = TextEditingController();
  TextEditingController EnrollmentIdController = TextEditingController();
  TextEditingController EmailController = TextEditingController();
  TextEditingController PasswordController = TextEditingController();
  TextEditingController ConfirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {


    return SafeArea(
        child: Scaffold(
       //   backgroundColor: Color(0xFF163ABB),
          body: ListView(
            children: [
              Container(
                decoration: BoxDecoration(gradient: LinearGradient(colors: [
                  hexStringColor("163ABB"),
                  hexStringColor("061A62")
            //  hexStringColor("69EFF8")

            ]),),
              child: SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height / 5,
                // child: Image.asset('lib/images/facebook.png'),
              ),),
              //Expanded(
              Container(
//                    height: 200,
                width: double.infinity,
                decoration:   BoxDecoration(
                  gradient: LinearGradient(colors: [
                    hexStringColor("163ABB"),
                    hexStringColor("061A62")
                    //  hexStringColor("69EFF8")

                  ]


                  ),
                  // borderRadius: const BorderRadius.only(
                  //   topLeft: Radius.circular(30),
                  //   topRight: Radius.circular(30),
                  // ),

                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Text(
                        //   'Full Name',
                        //   style: TextStyle(
                        //     color: Colors.black,
                        //     fontSize: 20,
                        //     fontWeight: FontWeight.bold,
                        //   ),
                        // ),
                        const SizedBox(height: 10),

                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.black,
                          ),

                          child: TextField(
                            controller: fullnameController,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              prefixIcon: Icon(
                                Icons.perm_identity_rounded,
                                color: Colors.white,
                              ),

                              hintText: 'Full Name',
                              hintStyle: TextStyle(color: Colors.white),
                              //   validator: (String? value) {

                              // }
                            ),
                          ),
                        ),

                        //<----------------------->//
                        // SizedBox(height: 15),
                        // const Text(
                        //   'Password',
                        //   style: TextStyle(
                        //     color: Colors.black,
                        //     fontSize: 20,
                        //     fontWeight: FontWeight.bold,
                        //
                        //   ),
                        // ),
                        const SizedBox(height: 15),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.black,
                          ),
                          child: TextField(
                            controller: EnrollmentIdController,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              prefixIcon: Icon(
                                Icons.badge_outlined,
                                color: Colors.white,
                              ),
                              hintText: 'Enrollment Id',
                              hintStyle: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        //<--------------------->//
                        const SizedBox(height: 15),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.black,
                          ),
                          child: TextField(
                            controller: EmailController,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              prefixIcon: Icon(
                                Icons.email_outlined,
                                color: Colors.white,
                              ),
                              hintText: 'Email',
                              hintStyle: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.black,
                          ),
                          child: TextField(
                            controller: PasswordController,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              prefixIcon: Icon(
                                Icons.lock,
                                color: Colors.white,
                              ),
                              hintText: 'Password',
                              hintStyle: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.black,
                          ),
                          child: TextField(
                            controller: ConfirmPasswordController,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              prefixIcon: Icon(
                                Icons.lock_clock,
                                color: Colors.white,
                              ),
                              hintText: 'Confirm Password',
                              hintStyle: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),


              ),
           //   const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(gradient: LinearGradient(colors: [
                  hexStringColor("163ABB"),
                  hexStringColor("061A62")
                  //  hexStringColor("69EFF8")

                ]),),
              child: GestureDetector(


                onTap: () {
                  // String email = emailController.text;
                  // String pass = passwordController.text;
                  Navigator.push(context,
                      MaterialPageRoute(

                          builder: (context) => const MyHomePage(title: '',)));
                },
                child: Container(

                  margin: const EdgeInsets.only(left: 10, top: 30, right: 10, bottom: 5),

                  decoration: BoxDecoration(


                    borderRadius: BorderRadius.circular(30),
                    color: Colors.black,
                  ),
                  child: const Center(
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        ' Sign Up',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                    ),
                  ),
                ),
              ),),
           Container(
           decoration: BoxDecoration(gradient: LinearGradient(colors: [
    hexStringColor("163ABB"),
    hexStringColor("061A62")
    //  hexStringColor("69EFF8")

    ]),),
               child: const SizedBox(

                 height:200),

           ),
            ],
          )
    ));
  }
}

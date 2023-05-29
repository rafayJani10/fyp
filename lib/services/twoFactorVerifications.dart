import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class VerificationCodeScreen extends StatefulWidget {
  final String verificationId;
  final String userid;
  final String phoneno;

  const VerificationCodeScreen({ required this.verificationId, required this.userid, required this.phoneno});

  @override
  _VerificationCodeScreenState createState() => _VerificationCodeScreenState();
}

class _VerificationCodeScreenState extends State<VerificationCodeScreen> {
  TextEditingController codeController = TextEditingController();


  Future updaetnumber()async{
    await FirebaseFirestore.instance.collection('users').doc(widget.userid).update(
        {
          "phoneNumber":widget.phoneno,

        }).then((value) {
      print("no added successfully");
    });
  }

  void verifyCode() async {
    String smsCode = codeController.text.trim();
    if (smsCode.isNotEmpty) {
      // Build the credential using the verification ID and SMS code
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: smsCode,
      );

      try {
        // Sign in the user with the credential
        FirebaseAuth auth = FirebaseAuth.instance;
        await auth.signInWithCredential(credential);
        // Handle authentication success
        updaetnumber();
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
      } catch (e) {
        // Handle authentication failure
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Phone authentication failed. ${e.toString()}'),
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
    } else {
      // Handle empty verification code input
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Please enter the verification code.'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verification Code'),
        backgroundColor: Colors.teal[900],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: codeController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Verification Code',
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: verifyCode,
              child: Text('Verify Code'),
            ),
          ],
        ),
      ),
    );
  }
}


import 'package:flutter/material.dart';

Container reusableTextField(String text, IconData icon, bool isPasswordType, TextEditingController controller) {

   return Container(
      width: double.infinity,
      height: 50,
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
        child:
        TextField(
        controller: controller,
        obscureText: isPasswordType,
        enableSuggestions: !isPasswordType,
        autocorrect: !isPasswordType,
        cursorColor: Colors.white,
        style: TextStyle(color: Colors.white.withOpacity(0.9)),
        decoration: InputDecoration(
          focusColor: Colors.white,

          prefixIcon: Icon(
            icon,
            color: Colors.white70,
          ),
          labelText: text,
          labelStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
          floatingLabelBehavior: FloatingLabelBehavior.never,
        ),
        keyboardType: isPasswordType
        ? TextInputType.visiblePassword
        : TextInputType.emailAddress,
      ),
      );
}


Container signInSignUpButton(
      BuildContext context, bool isLogin, Function onTap) {
    return Container(
      width:150,
      height: 40,
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
      child: ElevatedButton(
        onPressed: () {
          onTap();
        },
        child: Text(
        isLogin ? 'LOG IN ' : 'SIGN UP',
        style: const TextStyle(
          color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 16
        ),
      ),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.pressed)) {
              return Colors.black26;
            }
            return Colors.white;
          }),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))
            )  ),

      ),
    );
}



import 'package:flutter/material.dart';

void showAlertDialog(context, String title, String desc) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(desc),
        actions: <Widget>[
          ElevatedButton(
            child: Text("OK"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

Future no_data_alert(String imageName, String desc) async{
   return Center(
    child: Container(
      height: 400,
      width: 300,
      //color: Colors.teal,
      child: Column(
        children: [
          Container(
            height: 300,
            width: 300,
            child: Image.asset('assets/images/no_data.png'),
          ),
          SizedBox(height: 40,),
          Text("No data Found", style: TextStyle(fontSize: 20,  color: Colors.grey),)
        ],
      ),
    ),
  );
}
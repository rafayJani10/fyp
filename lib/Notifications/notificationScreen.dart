
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../services/NotificationServices.dart';

class Notifications_Screen extends StatefulWidget {
  const Notifications_Screen({Key? key}) : super(key: key);

  @override
  State<Notifications_Screen> createState() => _Notifications_ScreenState();
}
class _Notifications_ScreenState extends State<Notifications_Screen> {

  NotificationServices notificationServices = NotificationServices();

  var d_token = "";

  Future getDeviceToken() async{
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
    String? token = await _firebaseMessaging.getToken();
    setState(() {
      d_token = token!;

    });
    print(d_token);
  }


  Future sendMessage()async{
    // notificationServices.getDeviceToken().then((value) async{
    //   print(value);
    //   var data = {
    //     'to': 'dPJMcbhwS6aRMXfFH9VZyH:APA91bEw41Rxc9b8daV5Aoj9wm4lADf1ufHOLMsHUvAMuxspDvZLWLdPlBYBeVqVlnyoCo1y4INSVgWyiIWl1HdEBvcIVTzRHzye8PuNkI7FcHTZCRajgs-ybi_Q5tZqmSSMYTer07zh',
    //     'priority': 'high',
    //     'notification' : {
    //       'title' : 'Asif',
    //       'body' : 'Subscribe my channel,'
    //     }
    //   };
    //   await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
    //       body: jsonEncode(data) ,
    //       headers: {
    //         'Content-Type' : 'application/json; character=UTF-8',
    //         'Authorization' : 'key=AAAA4vnms68:APA91bHEf5AiZNGMPVT4jhpwG-ch-xibl1bHViNssWa21fYTsCCs0AMuLGPVqzDnhNOcwGTc_YvGrUqAyKSf2VU-jAJZ70I8J6vhHbZMd2WK898FjxZJ2pJAUv6H_MBF4-lUridh9q8P'
    //       }
    //   );
    // });
  }






  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   // _setupFirebaseMessaging();
    notificationServices.requestNotificationPermission();
    notificationServices.firebaseinit();

    notificationServices.getDeviceToken().then((value) async{
      print(value);
      var data = {
        'to': 'dPJMcbhwS6aRMXfFH9VZyH:APA91bEw41Rxc9b8daV5Aoj9wm4lADf1ufHOLMsHUvAMuxspDvZLWLdPlBYBeVqVlnyoCo1y4INSVgWyiIWl1HdEBvcIVTzRHzye8PuNkI7FcHTZCRajgs-ybi_Q5tZqmSSMYTer07zh',
        'priority': 'high',
        'notification' : {
          'title' : 'Asif',
          'body' : 'Subscribe my channel,'
        }
      };
      await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
          body: jsonEncode(data) ,
          headers: {
            'Content-Type' : 'application/json; character=UTF-8',
            'Authorization' : 'key=AAAA4vnms68:APA91bHEf5AiZNGMPVT4jhpwG-ch-xibl1bHViNssWa21fYTsCCs0AMuLGPVqzDnhNOcwGTc_YvGrUqAyKSf2VU-jAJZ70I8J6vhHbZMd2WK898FjxZJ2pJAUv6H_MBF4-lUridh9q8P'
          }
      );
    });

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //drawer: SideMenueBar(),
        appBar: AppBar(
          title: const Text("Notification List"),
          backgroundColor: Colors.teal[900],

        ),
        body: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: 10,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 70,
                        child: Row(
                          children: [
                            Flexible(
                                flex: 1,
                                child: Container(
                                  height: 300,
                                  //color: Colors.orange,
                                  child: Container(
                                    height: 80,
                                    width: 80,
                                    child: CircleAvatar(
                                      child: Image.network("https://firebasestorage.googleapis.com/v0/b/bukc-sports-hub.appspot.com/o/imgPh.jpeg?alt=media&token=e41c5f50-8ccb-4276-9538-bacf349f24ba",fit: BoxFit.fitHeight,),
                                    ),
                                  )
                                )),
                            Flexible(
                                flex: 4,
                                child: Container(

                                  height: 300,
                                  //color: Colors.red,
                                  child: Text(
                                    "akjhdakhjadkasjhdakhdkhadkhsdjkhsdkhkahakha skdhksfhskdhksfhksf lwjlfjljw  ljewfljewlfj jewljwflj ejwlfjlwejfl ",
                                    style: TextStyle(
                                      fontSize: 17,
                                    ),
                                    maxLines: 3,
                                  ),
                                ))
                          ],
                        ),
                      ),
                      Divider(color: Colors.grey[400],)
                    ],
                  )
                );
              })
    );
  }
}












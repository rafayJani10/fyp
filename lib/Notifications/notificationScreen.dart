
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Notifications_Screen extends StatefulWidget {
  const Notifications_Screen({Key? key}) : super(key: key);

  @override
  State<Notifications_Screen> createState() => _Notifications_ScreenState();
}
class _Notifications_ScreenState extends State<Notifications_Screen> {

  var d_token = "";
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  String? _message;

  Future getDeviceToken() async{
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
    String? token = await _firebaseMessaging.getToken();
    setState(() {
      d_token = token!;

    });
    print(d_token);
  }

  // Future<void> _setupFirebaseMessaging() async {
  //   NotificationSettings settings = await _firebaseMessaging.requestPermission(
  //     alert: true,
  //     badge: true,
  //     sound: true,
  //   );
  //   if (settings.authorizationStatus == AuthorizationStatus.authorized) {
  //     print('User granted permission for notifications');
  //   } else {
  //     print('User did not grant permission for notifications');
  //   }
  //
  //   _firebaseMessaging.getToken().then((token) {
  //     print('Device token: $token');
  //   });
  //
  //   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //     setState(() {
  //       _message = message.notification?.body;
  //     });
  //   });
  // }

  static Future<bool> sendFcmMessage(String title, String message, token) async {
    try {
      var url = 'https://fcm.googleapis.com/fcm/send';
      var header = {
        "Content-Type": "application/json",
        "Authorization": "key=AAAA4vnms68:APA91bHEf5AiZNGMPVT4jhpwG-ch-xibl1bHViNssWa21fYTsCCs0AMuLGPVqzDnhNOcwGTc_YvGrUqAyKSf2VU-jAJZ70I8J6vhHbZMd2WK898FjxZJ2pJAUv6H_MBF4-lUridh9q8P",
      };
      var request = {
        'notification': {'title': title, 'body': message, "sound" : "default",},
        'data': {'click_action': 'FLUTTER_NOTIFICATION_CLICK', 'type': 'COMMENT'},
        'to': '$token'
      };

      var response = await http.post(
        Uri.parse(url),
        headers: header,
        body: json.encode(request),
      );

      if (response.statusCode == 200) {
        print("status code 200");
        return true;
      } else {
        print('FCM request failed with status: ${response.statusCode}.');
        return false;
      }
    } catch (e, s) {
      print("errorrr");
      print(e);
      return false;
    }
  }





  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   // _setupFirebaseMessaging();
    FirebaseMessaging.instance.getToken().then((token) {
      print("Device token: $token");
      sendFcmMessage("demo","ggggg", token);
    });



    //getUserData();
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












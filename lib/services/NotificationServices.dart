import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:math';
import 'package:http/http.dart' as http;

import 'NavigationServices.dart';

class NotificationServices {

  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin  _flutterLocalfotificationsplugin = FlutterLocalNotificationsPlugin();



  void requestNotificationPermission()async{
    NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        badge: true,
        announcement: true,
        carPlay: true,
        criticalAlert: true,
        provisional: true,
        sound: true
    );
    if(settings.authorizationStatus == AuthorizationStatus.authorized){
      print("user granded permission");
    }else if(settings.authorizationStatus == AuthorizationStatus.authorized){
      print("user gramnded provisional permission");
    }else{
      print("user not give a permissionf");
    }
  }

  void initialLocalNotififcation(BuildContext context, RemoteMessage message)async{
    var androidInitialSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosInitializationSettings = DarwinInitializationSettings();
    var initialSetting = InitializationSettings(
        android: androidInitialSettings,
        iOS: iosInitializationSettings

    );

    await _flutterLocalfotificationsplugin.initialize(
        initialSetting,
        onDidReceiveNotificationResponse: (payload){

        }
    );
  }

  void firebaseinit(){
    FirebaseMessaging.onMessage.listen((message) async {

      print(message.notification!.title.toString());
      print(message.notification!.body.toString());

      showNotification(message);
    });
  }

  Future<void> showNotification(RemoteMessage message)async{
    AndroidNotificationChannel channel = AndroidNotificationChannel(
        Random.secure().nextInt(10000).toString(),
        'high_importance_channel',
        importance: Importance.max);
    AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
        channel.id.toString(),
        channel.name.toString(),
        channelDescription: 'your channel descriptions',
        importance: Importance.high,
        priority: Priority.high,
        ticker: 'ticker',
        icon: '@mipmap/ic_launcher',
        largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher')

    );

    DarwinNotificationDetails darwinNotificationDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true
    );

    NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails,
        iOS: darwinNotificationDetails
    );

    Future.delayed(Duration.zero, (){
      _flutterLocalfotificationsplugin.show(
          0,
          message.notification!.title.toString(),
          message.notification!.body.toString(),
          notificationDetails);
    });
  }

  Future<String?> getDeviceToken()async{
    String? token = await messaging.getToken();
    print('Device Token : $token');
    return token!;
  }

  Future<String?> isTokenRefresh()async{
    messaging.onTokenRefresh.listen((event) {
      event.toString();
    });
  }

  Future sendMessage(senderToken, title, body)async{
    var data = {
      'to': senderToken,
      'priority': 'high',
      'notification' : {
        'title' : title,
        'body' : body
      }
    };
    await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
        body: jsonEncode(data) ,
        headers: {
          'Content-Type' : 'application/json; character=UTF-8',
          'Authorization' : 'key=AAAAewzBF1Y:APA91bGggBe2ZiDlTZgk2jCLHuL9UeOabXeeKC9VpfLWyo60P12fMX3jSBTdEQlqWtp7QXQI5HS7zY-HQeL44vhe0jZrsYeKyh41QLqUy0l1tylb_bp1HSPK-Xrr8YlWVJ15KY7C9vqZ'
        }
    );
  }

  Future<void> backgroundMessageHandler(RemoteMessage message) async {
    // Handle background message
    print('Handling a background message: ${message.messageId}');

    // Navigate to a specific screen when the user taps on the notification
    // In this example, we're navigating to the home screen
    NavigationService navigationService = NavigationService();
    navigationService.navigateTo('/home');
  }

}
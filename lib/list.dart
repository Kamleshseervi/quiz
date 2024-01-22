import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:untitled/widgets/imagelist.dart';
import 'package:untitled/widgets/quizwidget.dart';

import 'Utils/colors.dart';

class PhotoList extends StatefulWidget {
  const PhotoList({Key? key});

  @override
  State<PhotoList> createState() => _PhotoListState();
}

class _PhotoListState extends State<PhotoList> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.instance.subscribeToTopic('newImage');
    //final fcmToken = await FirebaseMessaging.instance.getToken();
    //var log = log("FCMToken $fcmToken");

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Message recieved and app is in foreground');
      print('Title: ${message.notification?.title}');
      print('Body: ${message.notification?.body}');

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        RemoteNotification? notification = message.notification;
        AndroidNotification? android = message.notification?.android;

        if (notification != null && android != null) {
          showDialog(
            context: context,
            builder: (BuildContext) {
              return AlertDialog(
                title: Text(notification.title ?? ''),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: [Text(notification.body ?? '')],
                  ),
                ),
                actions: [
                  TextButton(
                    child: const Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }
      });
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Message from system tray:');
      print('Title: ${message.notification?.title}');
      print('Body: ${message.notification?.body}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Center(
        child: Column(
          children: [
            SizedBox(height: 20,),
            Container(
              child: Row(
                children: [
                  SizedBox(width: 20,),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.fromLTRB(20, 10, 0, 20),
                      child: Column(
                        children: [
                          Text("My Quizzes", style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w500), ),
                          QuizzesListWidget(),
                        ],
                      ),
                      alignment: Alignment.centerRight,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(40), bottomLeft:  Radius.circular(40)),
                        color: AppColors.iconColor1,
                      ),
                    ),
                  )
                ],
              ),
            ),

            SizedBox(height: 20,),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("    Recent Quiz",),
            QuizzesListWidget(),
            Text("    Popular quiz"),
            QuizzesListWidget(),
          ],
        )
          ],
        ),
      ),
    );










  }
}

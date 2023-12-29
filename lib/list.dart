import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:untitled/widgets/quizwidget.dart';

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
    return Column(
      children: [
        Text("Recent Quiz"),
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('images').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              List<DocumentSnapshot> docs = snapshot.data!.docs;

              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: docs.map((doc) {
                    String title = doc['title'] as String;
                    String imageUrl = doc['url'] as String;

                    return Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Stack(
                            children: [
                              Container(
                                width: 120,
                                height: 150,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(21),
                                  image: DecorationImage(
                                    image: NetworkImage(imageUrl),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 42, vertical: 4),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(21),
                                      color: Colors.yellow.shade900
                                          .withOpacity(1.0),
                                    ),
                                    child: Text(
                                      title,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 8,
                                right: 8,
                                child: Container(
                                  width: 30,
                                  height: 30,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 4,
                                    value:
                                        0.7, // Replace with your progress value
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.blue),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              );
            }
          },
        ),
        Text("Popular quiz"),
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('images').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              List<DocumentSnapshot> docs = snapshot.data!.docs;

              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: docs.map((doc) {
                    String title = doc['title'] as String;
                    String imageUrl = doc['url'] as String;

                    return Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Stack(
                            children: [
                              Container(
                                width: 120,
                                height: 150,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(21),
                                  image: DecorationImage(
                                    image: NetworkImage(imageUrl),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 42, vertical: 4),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(21),
                                      color: Colors.yellow.shade900
                                          .withOpacity(1.0),
                                    ),
                                    child: Text(
                                      title,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 8,
                                right: 8,
                                child: Container(
                                  width: 30,
                                  height: 30,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 4,
                                    value:
                                        0.7, // Replace with your progress value
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.blue),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              );
            }
          },
        ),
      ],
    );
  }
}

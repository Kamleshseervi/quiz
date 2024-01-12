import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'list.dart';
import 'notification_firebase.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  NotificationServices notificationServices = NotificationServices();
  int _selectedTab = 2;

  List _pages = [
    Center(
      child: Text("About"),
    ),
    ProfileScreen(),
    PhotoList(),
    Center(
      child: Text("Contact"),
    ),
    Center(
      child: Text("Settings"),
    ),
  ];

  _changeTab(int index) {
    setState(() {
      _selectedTab = index;
    });
  }

  @override
  void initState() {
    super.initState();
    notificationServices.requestNotificationPermission();
    _retrieveAndSaveToken();
  }

  // Function to retrieve device token and save to Firestore
  Future<void> _retrieveAndSaveToken() async {
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

    // Request permission to receive notifications
    await _firebaseMessaging.requestPermission();

    // Get the device token
    String? token = await _firebaseMessaging.getToken();
    if (token != null) {
      // Get the current user
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Save the token to Firestore with the user's ID
        await FirebaseFirestore.instance
            .collection('tokens')
            .doc(user.uid)
            .set({
          'device_token': token,
          'timestamp': FieldValue.serverTimestamp(),
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Quiz'),
          backgroundColor: Colors.orange,
        ),
        body: _pages[_selectedTab],
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedTab,
          onTap: (index) => _changeTab(index),
          selectedItemColor: Colors.red,
          unselectedItemColor: Colors.grey,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "About"),
            BottomNavigationBarItem(
              label: "Home",
              icon: Container(
                padding: EdgeInsets.fromLTRB(4, 8, 8, 8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.orange,
                ),
                child: FlutterLogo(
                  size: 38.0,
                ),
              ),
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.contact_mail), label: "Contact"),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings), label: "Settings"),
          ],
        ),
      ),
    );
  }
}

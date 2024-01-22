

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled/utils/colors.dart';
import 'package:untitled/widgets/imagelist.dart';
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

    ProfileScreen(),
    Center(
      child: Text("Articles"),
    ),
    PhotoList(),
    Center(
      child: Text("Database"),
    ),
    Center(
      child: Text("Statistics"),
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
        shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
        bottomLeft:  Radius.circular(20),
        bottomRight:  Radius.circular(20),
    ),),
          leading: Icon(Icons.account_circle, color: Colors.white, size: 36,),
          actions: [Icon(Icons.notifications_active, color:  Colors.yellow[700],),Text("     ")],
          title: Container(

            padding: EdgeInsets.fromLTRB(15, 0 , 15, 0),
            child: Row(

                children: [

                  Icon(Icons.search),
                  Text("|"),

                  InputChip(label: Text("ExaQ"), backgroundColor: Colors.white, shape: LinearBorder.none, labelPadding: EdgeInsets.all(0),),
                ],
            ),
            width:220,
            height: 40,

            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,

            ),
          ),
          backgroundColor: AppColors.mainColor,
          
        ),
        body:  _pages[_selectedTab],





        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedTab,
          onTap: (index) => _changeTab(index),
          selectedItemColor: AppColors.mainColor,
          unselectedItemColor: Colors.grey,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: "About"),
            BottomNavigationBarItem(icon: Icon(Icons.newspaper), label: "Articles"),
            BottomNavigationBarItem(
              label: "Home",
              icon: Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.mainColor,
                ),
                child: Image.asset('lib/assets/menu.png', width: 20, height: 20,),
              ),
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.storage), label: "Database"),
            BottomNavigationBarItem(
                icon: Icon(Icons.stacked_bar_chart), label: "Statistics"),
          ],
        ),
      ),
    );
  }
}

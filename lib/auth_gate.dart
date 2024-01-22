import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:untitled/HomeScreen.dart';
import 'package:untitled/registration.dart';

class LoginPage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<UserCredential> _signInWithGoogle() async {
    try {
      GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
      GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;
      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      return await _auth.signInWithCredential(credential);
    } catch (error) {
      print(error);
      return Future.error(error.toString());
    }
  }

  Future<Object> _signInWithEmailAndPassword(
      String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (error) {
      print(error);
      return Future.error(error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Implement email/password login
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen(  )),
                );
              },
              child: Text('Login'),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  UserCredential userCredential = await _signInWithGoogle();
                  print(
                      'Signed in with Google: ${userCredential.user!.displayName}');
                } catch (error) {
                  print('Google Sign In Error: $error');
                }
              },
              child: Text('SignIn withGoogle'),
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () {
                // Navigate to registration screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignupPage()),
                );
              },
              child: Text('Create a new account'),
            ),
          ],
        ),
      ),
    );
  }
}

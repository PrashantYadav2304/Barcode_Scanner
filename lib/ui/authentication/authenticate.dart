import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Signin extends StatefulWidget {
  @override
  _SigninState createState() => _SigninState();
}

class _SigninState extends State<Signin> {

  Future<UserCredential> signInWithGoogle() async {
  // Trigger the authentication flow
  final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

  // Obtain the auth details from the request
  final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );

  // Once signed in, return the UserCredential
  UserCredential user = await FirebaseAuth.instance.signInWithCredential(credential);
  print("success $user");
  return user;
}

 Future<void> signOut() async {
    final googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    await FirebaseAuth.instance.signOut();
    print("Logout successful");
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home")
        
      ),
      body: Container(
      color: Colors.white,
      padding: EdgeInsets.all(4),
      child: OutlinedButton.icon(
        onPressed: signInWithGoogle,
         icon: Icon(Icons.mail_outline),
          label: Text("Sign In with Google",
      style: TextStyle(fontWeight: FontWeight.bold)
      ),
      ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: signOut, child:Text("Logout")),
    );
  }
}
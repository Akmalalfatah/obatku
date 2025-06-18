import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:obatku/auth/login_or_signup.dart';

class PersonalInfoPage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Personal Information')),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await _auth.signOut();
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => LoginOrRegister()),
              (route) => false,
            );
          },
          child: Text("Log Out"),
        ),
      ),
    );
  }
}

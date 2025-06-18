import 'package:flutter/material.dart';
import 'package:obatku/pages/sign_in.dart';
import 'package:obatku/pages/sign_up.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  bool showloginapage = true;

  void togglePage() {
    setState(() {
      showloginapage = !showloginapage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showloginapage) {
      return SignIn(onTap: togglePage);
    } else {
      return SignUp(onTap: togglePage);
    }
  }
}

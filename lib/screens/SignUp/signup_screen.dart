import 'package:flutter/material.dart';
import 'package:lab4/Screens/Signup/body.dart';

class SignUpScreen extends StatefulWidget {
  @override
  SignUpScreenState createState() {
    return new SignUpScreenState();
  }
}

class SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.keyboard_backspace_rounded),
          onPressed: () {
            //页面路由
            Navigator.of(context).pop(true);
          }),
      body: Body(),
    );
  }
}

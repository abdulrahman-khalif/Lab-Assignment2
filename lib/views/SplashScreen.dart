import 'dart:async';

import 'package:flutter/material.dart';

import '../models/user.dart';
import 'MainScreen.dart';

class MySplaschScreen extends StatefulWidget {
  const MySplaschScreen({super.key});

  @override
  State<MySplaschScreen> createState() => _MySplaschScreen();
}

class _MySplaschScreen extends State<MySplaschScreen> {
  @override
  void initState() {
    super.initState();

    User user = User(
        id: "0",
        email: "unregistered",
        name: "unregistered",
        address: "na",
        phone: " - ",
        regdate: "0");

    Timer(
        const Duration(seconds: 6),
        () => Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (content) => MainScreen(user: user))));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: const [
        Text("Home Stay",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            )),
        CircularProgressIndicator(),
        Text("Version 1.0.0b"),
      ],
    )));
  }
}

import 'package:flutter/material.dart';

import '../models/user.dart';
import 'LoginScreen.dart';
import 'MainManue.dart';
import 'RegistrationScreen.dart';

class MainScreen extends StatefulWidget {
  final User user;
  const MainScreen({super.key, required this.user});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Screen"),
        actions: [
          IconButton(
              onPressed: _RegistrationScreen,
              icon: const Icon(Icons.app_registration)),
          IconButton(onPressed: _loginScreen, icon: const Icon(Icons.login))
        ],
      ),
      body: Center(
          child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,

            // ignore: prefer_const_constructors
            children: [
              const Text("Homestay Raya",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.red)),
              const SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'search and book homestays around Malaysia',
                    hintStyle: TextStyle(color: Colors.red),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0))),
              ),
              ElevatedButton(
                onPressed: null,
                child: const Text("Search"),
              ),
            ],
          ),
        ),
      )),
      drawer: MainManue(user: widget.user),
    );
  }

  void _RegistrationScreen() {
    Navigator.push(context,
        MaterialPageRoute(builder: (content) => const registration002()));
  }

  void _loginScreen() {
    Navigator.push(
        context, MaterialPageRoute(builder: (content) => const LoginScreen()));
  }
}

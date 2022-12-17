import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../models/user.dart';
import 'MainScreen.dart';

class MainManue extends StatefulWidget {
  final User user;
  const MainManue({super.key, required this.user});

  @override
  State<MainManue> createState() => _MainManueState();
}

class _MainManueState extends State<MainManue> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 250,
      elevation: 10,
      child: ListView(children: [
        UserAccountsDrawerHeader(
          accountEmail: Text(widget.user.email.toString()),
          accountName: Text(widget.user.name.toString()),
          currentAccountPicture: const CircleAvatar(
            radius: 30.0,
          ),
        ),
      ]),
    );
  }
}

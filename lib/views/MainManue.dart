import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:homestay/views/homestay.dart';

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
            accountName: Text(widget.user.name.toString()),
            accountEmail: Text(widget.user.email.toString())),
        ListTile(
          title: const Text('Home Stay'),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (content) => MainScreen(
                          user: widget.user,
                        )));
          },
        ),
        ListTile(
          title: const Text('Oner page'),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (content) => HomeStay(user: widget.user)));
          },
        ),
      ]),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:homestay/views/OnerScreen.dart';

import '../ServerConfig.dart';
import '../models/user.dart';
import '../utils/mycolor.dart';
import 'MainScreen.dart';
import 'profilescreen.dart';

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
      backgroundColor: AppColors.kBgColor,
      width: 250,
      elevation: 10,
      child: ListView(children: [
        UserAccountsDrawerHeader(
          accountName: Text(widget.user.name.toString()),
          accountEmail: Text(widget.user.email.toString()),
          currentAccountPicture: CircleAvatar(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
              child: CachedNetworkImage(
                imageUrl:
                    "${ServerConfig.SERVER}/assets/profileimages/${widget.user.id}.png",
                imageBuilder: (context, imageProvider) => Container(
                  width: 350.0,
                  height: 350.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: imageProvider, fit: BoxFit.cover),
                  ),
                ),
                placeholder: (context, url) => const LinearProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(
                  Icons.image_not_supported,
                  size: 128,
                ),
              ),
            ),
          ),
        ),
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
          title: const Text('Oner'),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (content) => OnerScreen(user: widget.user)));
          },
        ),
        ListTile(
          title: const Text('profile'),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (content) => ProfileScreen(user: widget.user)));
          },
        ),
      ]),
    );
  }
}

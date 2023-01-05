import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:homestay/models/home.dart';

import '../models/user.dart';
import 'LoginScreen.dart';
import 'MainManue.dart';
import 'RegistrationScreen.dart';
import 'package:ndialog/ndialog.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'newHome.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

class HomeStay extends StatefulWidget {
  final User user;
  const HomeStay({super.key, required this.user});

  @override
  State<HomeStay> createState() => _HomeStay();
}

class _HomeStay extends State<HomeStay> {
  late Position _position;
  List<Homes> homelist = <Homes>[];
  var placemarks;
  String titlecenter = "No data";
  final df = DateFormat('dd/MM/yyyy hh:mm a');
  @override
  void initState() {
    super.initState();
    _loadhome();
  }

  @override
  void dispose() {
    homelist = [];
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Oner Page"), actions: [
        IconButton(
            onPressed: _RegistrationScreen,
            icon: const Icon(Icons.app_registration)),
        IconButton(onPressed: _loginScreen, icon: const Icon(Icons.login)),
        PopupMenuButton(
            // add icon, by default "3 dot" icon
            // icon: Icon(Icons.book)
            itemBuilder: (context) {
          return [
            const PopupMenuItem<int>(
              value: 0,
              child: Text("New HomeStay"),
            ),
            const PopupMenuItem<int>(
              value: 1,
              child: Text("My Order"),
            ),
          ];
        }, onSelected: (value) {
          if (value == 0) {
            _gotoNewHomeStay();
            print("My account menu is selected.");
          } else if (value == 1) {
            print("Settings menu is selected.");
          } else if (value == 2) {
            print("Logout menu is selected.");
          }
        }),
      ]),
      body: homelist.isEmpty
          ? Center(
              child: Text(titlecenter,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold)))
          : Column(children: [
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  children: List.generate(homelist.length, (index) {
                    return Card(
                      child: Column(children: [
                        Flexible(
                          flex: 6,
                          child: CachedNetworkImage(
                            width: 150,
                            fit: BoxFit.cover,
                            imageUrl:
                                "http://10.19.42.192/homestay/assets/home_images/${homelist[index].homeId}.png",
                            placeholder: (context, url) =>
                                const LinearProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(homelist[index].homeDesc.toString()),
                        Text("RM ${homelist[index].price.toString()} per day"),
                        Text(df.format(
                            DateTime.parse(homelist[index].date.toString()))),
                      ]),
                    );
                  }),
                ),
              ),
            ]),
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

  Future<void> _gotoNewHomeStay() async {
    if (widget.user.id == "0") {
      Fluttertoast.showToast(
          msg: "Please login/register",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      return;
    }

    ProgressDialog progressDialog = ProgressDialog(
      context,
      blur: 10,
      message: const Text("Searching your current location"),
      title: null,
    );

    progressDialog.show();
    if (await _checkPermissionGetLoc()) {
      progressDialog.dismiss();
      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (content) => NewHome(
                    user: widget.user,
                    position: _position,
                  )));
      _loadhome();
    } else {
      Fluttertoast.showToast(
          msg: "Please allow the app to access the location",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
    }
  }

  Future<bool> _checkPermissionGetLoc() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Fluttertoast.showToast(
            msg: "Please allow the app to access the location",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14.0);
        Geolocator.openLocationSettings();
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      Fluttertoast.showToast(
          msg: "Please allow the app to access the location",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      Geolocator.openLocationSettings();
      return false;
    }
    _position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);

    return true;
  }

  void _loadhome() {
    if (widget.user.id == "0") {
      //check if the user is registered or not
      Fluttertoast.showToast(
          msg: "Please register an account first", //Show toast
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      return; //exit method if true
    }
    http
        .get(
      Uri.parse(
          "http://10.19.42.192/homestay/php/loadhome.php?userid=${widget.user.id}"),
    )
        .then((response) {
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
          var extractdata = jsondata['data'];
          if (extractdata['homes'] != null) {
            homelist = <Homes>[];
            extractdata['homes'].forEach((v) {
              homelist.add(Homes.fromJson(v));
            });
            titlecenter = "Found";
          } else {
            titlecenter = "No Home Available";
            homelist.clear();
          }
        }
      } else {
        titlecenter = "No Home Available";
        homelist.clear();
      }

      setState(() {});
    });
  }
}

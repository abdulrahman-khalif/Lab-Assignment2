import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:homestay/models/home.dart';

import '../ServerConfig.dart';
import '../models/user.dart';
import '../utils/mycolor.dart';
import 'LoginScreen.dart';
import 'MainManue.dart';
import 'RegistrationScreen.dart';
import 'package:ndialog/ndialog.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'UpdateDetailsScreen.dart';
import 'newHome.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

import 'profilescreen.dart';

class OnerScreen extends StatefulWidget {
  final User user;
  const OnerScreen({super.key, required this.user});

  @override
  State<OnerScreen> createState() => _OnerScreen();
}

class _OnerScreen extends State<OnerScreen> {
  late Position _position;
  List<Homes> homelist = <Homes>[];
  var placemarks;
  String titlecenter = "No Home yet Uploaded to the database";

  final df = DateFormat('dd/MM/yyyy hh:mm a');
  late double screenHeight, screenWidth, resWidth;
  int rowcount = 2;
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
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 600) {
      resWidth = screenWidth;
      rowcount = 2;
    } else {
      resWidth = screenWidth * 0.75;
      rowcount = 3;
    }
    return Scaffold(
      backgroundColor: AppColors.kBgColor,
      appBar: AppBar(
          title: const Text("Oner Page",
              style: TextStyle(
                color: Colors.black,
              )),
          actions: [
            PopupMenuButton(
                // add icon, by default "3 dot" icon
                // icon: Icon(Icons.book)
                itemBuilder: (context) {
              return [
                const PopupMenuItem<int>(
                  value: 0,
                  child: Text("New HomeStay"),
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
              child: Container(
                height: 64,
                child: Column(children: [
                  Text(titlecenter),
                ]),
              ),
            )
          : Column(children: [
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  children: List.generate(homelist.length, (index) {
                    return Card(
                      elevation: 8,
                      child: InkWell(
                        onTap: () {
                          _showDetails(index);
                        },
                        onLongPress: () {
                          _deleteDialog(index);
                        },
                        child: Column(children: [
                          const SizedBox(
                            height: 8,
                          ),
                          Flexible(
                            flex: 6,
                            //image data:
                            child: CachedNetworkImage(
                              width: resWidth / 2,
                              fit: BoxFit.cover,
                              imageUrl:
                                  "${ServerConfig.SERVER}/assets/home_images/${homelist[index].homeId}.png",
                              placeholder: (context, url) =>
                                  const LinearProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                          ),
                          // other data
                          Flexible(
                              flex: 4,
                              child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(children: [
                                    Text(
                                      truncateString(
                                          homelist[index].name.toString(), 15),
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                        "RM ${double.parse(homelist[index].price.toString())..toStringAsFixed(2)} par day",
                                        style: const TextStyle(
                                          fontSize: 12,
                                        )),
                                    Text(
                                        df.format(DateTime.parse(
                                            homelist[index].date.toString())),
                                        style: const TextStyle(
                                          fontSize: 12,
                                        )),
                                  ])))
                        ]),
                      ),
                    );
                  }),
                ),
              ),
            ]),
      drawer: MainManue(user: widget.user),
    );
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
          "${ServerConfig.SERVER}/php/loadhome.php?userid=${widget.user.id}"),
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

  Future<void> _showDetails(int index) async {
    Homes home = Homes.fromJson(homelist[index].toJson());

    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (content) => UpdateDetailsHome(
                  home: home,
                  user: widget.user,
                )));
    _loadhome();
  }

  void _deleteDialog(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: Text(
              truncateString("Delete ${(homelist[index].name.toString())}", 15),
            ),
            content: const Text("Are you sure?", style: TextStyle()),
            actions: <Widget>[
              TextButton(
                child: const Text(
                  "Yes",
                  style: TextStyle(),
                ),
                onPressed: () async {
                  Navigator.of(context).pop();
                  _deleteHomestay(index);
                },
              ),
              TextButton(
                child: const Text(
                  "No",
                  style: TextStyle(),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  void _deleteHomestay(int index) {
    try {
      http.post(Uri.parse("${ServerConfig.SERVER}/php/delete_homestay.php"),
          body: {
            "homeid": homelist[index].homeId,
          }).then((response) {
        var data = jsonDecode(response.body);
        if (response.statusCode == 200 && data['status'] == "success") {
          Fluttertoast.showToast(
              msg: "Success",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              fontSize: 14.0);
          _loadhome();
          return;
        } else {
          Fluttertoast.showToast(
              msg: "Failed",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              fontSize: 14.0);
          return;
        }
      });
    } catch (e) {
      print(e.toString());
    }
  }

  String truncateString(String str, int size) {
    if (str.length > size) {
      str = str.substring(0, size);
      return "$str...";
    } else {
      return str;
    }
  }
}

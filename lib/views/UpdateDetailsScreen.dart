import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:homestay/models/home.dart';
import 'package:http/http.dart' as http;

import '../ServerConfig.dart';
import '../models/user.dart';
import '../utils/mycolor.dart';
import 'OnerScreen.dart';

class UpdateDetailsHome extends StatefulWidget {
  final Homes home;
  final User user;
  const UpdateDetailsHome({super.key, required this.home, required this.user});

  @override
  State<UpdateDetailsHome> createState() => _UpdateDetailsHomeState();
}

class _UpdateDetailsHomeState extends State<UpdateDetailsHome> {
  late double screenHeight, screenWidth, resWidth;
  int rowcount = 2;
  File? _imageone;
  File? _imagetwo;
  File? _imagetree;
  bool _isChecked = false;
  var m1 = false, m2 = false, m3 = false;
  var pathAsset = "assets/images/camera.png";
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _decController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _localController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void initState() {
    super.initState();
    _nameController.text = widget.home.name.toString();
    _decController.text = widget.home.homeDesc.toString();
    _priceController.text = widget.home.price.toString();
    _stateController.text = widget.home.states.toString();
    _localController.text = widget.home.local.toString();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 600) {
      resWidth = screenWidth;
    } else {
      resWidth = screenWidth * 0.75;
    }
    return Scaffold(
        backgroundColor: AppColors.kBgColor,
        appBar: AppBar(
            title: const Text("Details/Update",
                style: TextStyle(
                  color: Colors.black,
                ))),
        body: SingleChildScrollView(
            child: Column(children: [
          SizedBox(
            height: 250,
            child: ListView(scrollDirection: Axis.horizontal, children: [
              Card(
                elevation: 8,
                child: Container(
                  height: screenHeight / 3,
                  width: resWidth,
                  child: CachedNetworkImage(
                    width: resWidth,
                    fit: BoxFit.cover,
                    imageUrl:
                        "${ServerConfig.SERVER}/assets/home_images/${widget.home.homeId}.png",
                    placeholder: (context, url) =>
                        const LinearProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
              ),

              //show image 2

              Card(
                elevation: 8,
                child: Container(
                  height: screenHeight / 3,
                  width: resWidth,
                  child: CachedNetworkImage(
                    width: resWidth,
                    fit: BoxFit.cover,
                    imageUrl:
                        "${ServerConfig.SERVER}/assets/home_images/${widget.home.homeId}_2.png",
                    placeholder: (context, url) =>
                        const LinearProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
              ),

              //show image 3

              Card(
                elevation: 8,
                child: Container(
                  height: screenHeight / 3,
                  width: resWidth,
                  child: CachedNetworkImage(
                    width: resWidth,
                    fit: BoxFit.cover,
                    imageUrl:
                        "${ServerConfig.SERVER}/assets/home_images/${widget.home.homeId}_3.png",
                    placeholder: (context, url) =>
                        const LinearProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
              ),
            ]),
          ),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                  child: Column(children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "HomeStay Detailes",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                    margin: EdgeInsets.all(16),
                    child: Form(
                      key: _formKey,
                      child: Column(children: [
                        // user start register

                        TextFormField(
                            controller: _nameController,
                            textInputAction: TextInputAction.next,
                            validator: (val) => val!.isEmpty || (val.length < 3)
                                ? " Home stay name must be longer than 3"
                                : null,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                                labelText: 'Home stay Name:',
                                labelStyle: TextStyle(),
                                icon: Icon(Icons.person),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 2.0),
                                ))),
                        TextFormField(
                            controller: _decController,
                            textInputAction: TextInputAction.next,
                            validator: (val) => val!.isEmpty
                                ? "home description must be not empty"
                                : null,
                            maxLines: 4,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                                labelText: 'HomeStay Description:',
                                alignLabelWithHint: true,
                                labelStyle: TextStyle(),
                                icon: Icon(
                                  Icons.person,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 2.0),
                                ))),

                        Row(
                          children: [
                            Flexible(
                                flex: 5,
                                child: TextFormField(
                                    textInputAction: TextInputAction.next,
                                    validator: (val) =>
                                        val!.isEmpty ? "Current State" : null,
                                    enabled: false,
                                    controller: _stateController,
                                    keyboardType: TextInputType.text,
                                    decoration: const InputDecoration(
                                        labelText: 'Current States',
                                        labelStyle: TextStyle(),
                                        icon: Icon(Icons.flag),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(width: 2.0),
                                        )))),
                            Flexible(
                              flex: 5,
                              child: TextFormField(
                                  textInputAction: TextInputAction.next,
                                  enabled: false,
                                  validator: (val) =>
                                      val!.isEmpty ? "Current Locality" : null,
                                  controller: _localController,
                                  keyboardType: TextInputType.text,
                                  decoration: const InputDecoration(
                                      labelText: 'Current Locality',
                                      labelStyle: TextStyle(),
                                      icon: Icon(Icons.map),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(width: 2.0),
                                      ))),
                            )
                          ],
                        ),
                        Row(children: [
                          Flexible(
                            flex: 5,
                            child: TextFormField(
                                controller: _priceController,
                                textInputAction: TextInputAction.next,
                                validator: (val) => val!.isEmpty
                                    ? "Home price must contain value"
                                    : null,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                    labelText: 'Home Price per Day',
                                    labelStyle: TextStyle(),
                                    icon: Icon(Icons.money),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(width: 2.0),
                                    ))),
                          ),
                          Flexible(
                              flex: 5,
                              child: CheckboxListTile(
                                title: const Text(
                                    "Accept agreement?"), //    <‐‐ label
                                value: _isChecked,
                                onChanged: (bool? value) {
                                  setState(() {
                                    _isChecked = value!;
                                  });
                                },
                              )),
                        ]),
                        SizedBox(
                          width: 200,
                          child: ElevatedButton(
                            child: const Text('Update HomeStay'),
                            onPressed: () => {UpdateHomeDialog()},
                          ),
                        ),
                      ]),
                    )),
              ])))
        ])));
  }

  UpdateHomeDialog() {
    if (!_formKey.currentState!.validate()) {
      Fluttertoast.showToast(
          msg: "Please complete the form first",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      return;
    }
    if (!_isChecked) {
      Fluttertoast.showToast(
          msg: "Please check agree checkbox",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      return;
    }
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: const Text(
              "Update this Home Stay?",
              style: TextStyle(),
            ),
            content: const Text("Are you sure?", style: TextStyle()),
            actions: <Widget>[
              TextButton(
                child: const Text(
                  "Yes",
                  style: TextStyle(),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  UpdateHomeStay();
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

  void UpdateHomeStay() {
    String name = _nameController.text;
    String homedesc = _decController.text;
    String price = _priceController.text;
    http.post(Uri.parse("${ServerConfig.SERVER}/php/updatehome.php"), body: {
      "homeid": widget.home.homeId,
      "userid": widget.user.id,
      "name": name,
      "homedesc": homedesc,
      "price": price,
    }).then((response) {
      var data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['status'] == "success") {
        Fluttertoast.showToast(
            msg: "Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14.0);
        Navigator.of(context).pop();
        MaterialPageRoute(builder: (content) => OnerScreen(user: widget.user));
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
  }
}

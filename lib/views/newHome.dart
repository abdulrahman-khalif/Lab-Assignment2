import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:homestay/models/user.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;

import 'homestay.dart';

class NewHome extends StatefulWidget {
  final User user;
  final Position position;
  const NewHome({super.key, required this.user, required this.position});

  @override
  State<NewHome> createState() => _NewHome();
}

class _NewHome extends State<NewHome> {
  File? _imageone;
  File? _imagetwo;
  File? _imagetree;
  bool _isChecked = false;
  var m1 = false;
  var m2 = false;
  var m3 = false;
  var pathAsset = "assets/images/camera.png";

  final TextEditingController _OnerNameController = TextEditingController();
  final TextEditingController _DecController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _localController = TextEditingController();

//
  final _formKey = GlobalKey<FormState>();
  var _lat;
  var _lng;
  late Position _position;
  @override
  void initState() {
    super.initState();
    _lat = widget.position.latitude.toString();
    _lng = widget.position.longitude.toString();
    _getAddress();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("homestay registration form"),
        ),
        body: SingleChildScrollView(
            // show image 1
            child: Column(children: [
          SizedBox(
            height: 250,
            child: ListView(scrollDirection: Axis.horizontal, children: [
              GestureDetector(
                onTap: _1selectImage,
                child: Card(
                  elevation: 8,
                  child: Container(
                    height: 250,
                    width: 250,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                      image: _imageone == null
                          ? AssetImage(pathAsset)
                          : FileImage(_imageone!) as ImageProvider,
                      fit: BoxFit.cover,
                    )),
                  ),
                ),
              ),

              //show image 2

              GestureDetector(
                onTap: _2selectImage,
                child: Card(
                  elevation: 8,
                  child: Container(
                    height: 250,
                    width: 250,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                      image: _imagetwo == null
                          ? AssetImage(pathAsset)
                          : FileImage(_imagetwo!) as ImageProvider,
                      fit: BoxFit.cover,
                    )),
                  ),
                ),
              ),

              //show image 3

              GestureDetector(
                onTap: _3selectImage,
                child: Card(
                  elevation: 8,
                  child: Container(
                    height: 250,
                    width: 250,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                      image: _imagetree == null
                          ? AssetImage(pathAsset)
                          : FileImage(_imagetree!) as ImageProvider,
                      fit: BoxFit.cover,
                    )),
                  ),
                ),
              ),
            ]),
          ),

          // start text form
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
                child: Column(children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Add New HomeStay",
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
                          controller: _OnerNameController,
                          textInputAction: TextInputAction.next,
                          validator: (val) => val!.isEmpty || (val.length < 3)
                              ? " oner name must be longer than 3"
                              : null,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                              labelText: 'Oner Name:',
                              labelStyle: TextStyle(),
                              icon: Icon(Icons.person),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 2.0),
                              ))),
                      TextFormField(
                          controller: _DecController,
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
                                  labelText: 'Product Price',
                                  labelStyle: TextStyle(),
                                  icon: Icon(Icons.money),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 2.0),
                                  ))),
                        ),
                        Flexible(
                            flex: 5,
                            child: CheckboxListTile(
                              title:
                                  const Text("Lawfull Item?"), //    <‐‐ label
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
                          child: const Text('Add HomeStay'),
                          onPressed: () => {
                            _newProductDialog(),
                          },
                        ),
                      ),
                    ]),
                  )),
            ])),
          ),
        ])));
  }

// start select image 1
  void _1selectImage() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
            title: const Text(
              "Select image from",
              style: TextStyle(),
            ),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                    onPressed: _1oncamra, icon: const Icon(Icons.camera)),
                IconButton(
                    onPressed: _1ongallrye,
                    icon: const Icon(Icons.browse_gallery))
              ],
            ));
      },
    );
  }

  Future<void> _1oncamra() async {
    m1 = true;
    Navigator.pop(context);
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      maxHeight: 800,
      maxWidth: 800,
    );
    if (pickedFile != null) {
      _imageone = File(pickedFile.path);
      cropImage();
      setState(() {});
    } else {
      print('No image selected.');
    }
  }

  Future<void> _1ongallrye() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 800,
      maxWidth: 800,
    );

    if (pickedFile != null) {
      _imageone = File(pickedFile.path);
      cropImage();
    } else {
      print('No image selected.');
    }
  }
// end of select image 1

// Start select image 2
  void _2selectImage() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
            title: const Text(
              "Select image from",
              style: TextStyle(),
            ),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                    onPressed: _2oncamra, icon: const Icon(Icons.camera)),
                IconButton(
                    onPressed: _2ongallrye,
                    icon: const Icon(Icons.browse_gallery))
              ],
            ));
      },
    );
  }

  Future<void> _2oncamra() async {
    m2 = true;
    Navigator.pop(context);
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      maxHeight: 800,
      maxWidth: 800,
    );
    if (pickedFile != null) {
      _imagetwo = File(pickedFile.path);
      cropImage();
      setState(() {});
    } else {
      print('No image selected.');
    }
  }

  Future<void> _2ongallrye() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 800,
      maxWidth: 800,
    );

    if (pickedFile != null) {
      _imagetwo = File(pickedFile.path);
      cropImage();
    } else {
      print('No image selected.');
    }
  }
// end of select image 2

// start select image 3
  void _3selectImage() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
            title: const Text(
              "Select image from",
              style: TextStyle(),
            ),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                    onPressed: _3oncamra, icon: const Icon(Icons.camera)),
                IconButton(
                    onPressed: _3ongallrye,
                    icon: const Icon(Icons.browse_gallery))
              ],
            ));
      },
    );
  }

  Future<void> _3oncamra() async {
    m3 = true;
    Navigator.pop(context);
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      maxHeight: 800,
      maxWidth: 800,
    );
    if (pickedFile != null) {
      _imagetree = File(pickedFile.path);
      cropImage();
      setState(() {});
    } else {
      print('No image selected.');
    }
  }

  Future<void> _3ongallrye() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 800,
      maxWidth: 800,
    );

    if (pickedFile != null) {
      _imagetree = File(pickedFile.path);
      cropImage();
    } else {
      print('No image selected.');
    }
  }
// end of select image 3

// crop image for image 1 and image 2 and image 3
  Future<void> cropImage() async {
    if (m1 == true) {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: _imageone!.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
        ],
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: Color.fromARGB(255, 159, 34, 255),
              toolbarWidgetColor: Color.fromARGB(255, 22, 6, 21),
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          IOSUiSettings(
            title: 'Cropper image 1',
          ),
        ],
      );
      if (croppedFile != null) {
        File imageFile = File(croppedFile.path);
        _imageone = imageFile;
        setState(() {});
      }
      m1 = false;
      return;
    }

    if (m2 == true) {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: _imagetwo!.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
        ],
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: Color.fromARGB(255, 255, 34, 170),
              toolbarWidgetColor: Color.fromARGB(255, 22, 6, 21),
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          IOSUiSettings(
            title: 'Cropper image 2',
          ),
        ],
      );
      if (croppedFile != null) {
        File imageFile = File(croppedFile.path);
        _imagetwo = imageFile;
        setState(() {});
      }
      m2 = false;
      return;
    }

    if (m3 == true) {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: _imagetree!.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
        ],
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: Color.fromARGB(255, 34, 60, 255),
              toolbarWidgetColor: Color.fromARGB(255, 22, 6, 21),
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          IOSUiSettings(
            title: 'Cropper image 3',
          ),
        ],
      );
      if (croppedFile != null) {
        File imageFile = File(croppedFile.path);
        _imagetree = imageFile;
        setState(() {});
      }
      m3 = false;
      return;
    }
  }

  _getAddress() async {
    List<Placemark> placemarks = await placemarkFromCoordinates(
        widget.position.latitude, widget.position.longitude);
    setState(() {
      _stateController.text = placemarks[0].administrativeArea.toString();

      _localController.text = placemarks[0].locality.toString();
    });
  }

  _newProductDialog() {
    if (_imageone == null || _imagetwo == null || _imagetree == null) {
      Fluttertoast.showToast(
          msg: "Please take picture of your HomeStay",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      return;
    }
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
              "Insert this New Home Stay?",
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
                  insertHomeStay();
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

  void insertHomeStay() {
    String onername = _OnerNameController.text;
    String homedesc = _DecController.text;
    String price = _priceController.text;
    String state = _stateController.text;
    String local = _localController.text;
    String base64_Imageone = base64Encode(_imageone!.readAsBytesSync());
    String base64_Imagetwo = base64Encode(_imagetwo!.readAsBytesSync());
    String base64_Imagetree = base64Encode(_imagetree!.readAsBytesSync());
    http.post(Uri.parse("http://10.19.42.192/homestay/php/home.php"), body: {
      "userid": widget.user.id,
      "name": onername,
      "homedesc": homedesc,
      "price": price,
      "state": state,
      "local": local,
      "lat": _lat,
      "lon": _lng,
      "image_one": base64_Imageone,
      "image_two": base64_Imagetwo,
      "image_tree": base64_Imagetree,
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
        MaterialPageRoute(builder: (content) => HomeStay(user: widget.user));
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

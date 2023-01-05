import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:homestay/models/User.dart';
import 'package:homestay/views/LoginScreen.dart';
import 'package:http/http.dart' as http;

import 'MainScreen.dart';

class registration002 extends StatefulWidget {
  const registration002({super.key});

  @override
  State<registration002> createState() => _registration002State();
}

class _registration002State extends State<registration002> {
  @override
  void initState() {
    super.initState();
    loadEola();
  }

  bool _isChecked = false;
  String eula = "";
  bool _passwordVisible = false;
  bool _passwordVisible2 = false;
  TextEditingController name_input = TextEditingController();
  TextEditingController email_input = TextEditingController();

  TextEditingController phon_input = TextEditingController();

  TextEditingController pass_input = TextEditingController();

  TextEditingController repass_input = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Registration")),
      body: Center(
          child: SingleChildScrollView(
        child: Card(
          margin: const EdgeInsets.all(10),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Form(
                key: _formKey,
                child: Column(children: [
                  TextFormField(
                      controller: name_input,
                      validator: (val) => val!.isEmpty || (val.length < 3)
                          ? "name must be longer than 3"
                          : null,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                          labelText: 'Name',
                          labelStyle: TextStyle(),
                          icon: Icon(Icons.person),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 2.0),
                          ))),
                  TextFormField(
                      controller: email_input,
                      textInputAction: TextInputAction.next,
                      validator: (val) => val!.isEmpty ||
                              !val.contains("@") ||
                              !val.contains(".")
                          ? "enter a valid email"
                          : null,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                          labelText: 'Email',
                          icon: Icon(Icons.email),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 2.0),
                          ))),
                  TextFormField(
                      controller: phon_input,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                          labelText: 'Phone',
                          icon: Icon(Icons.phone),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 2.0),
                          ))),
                  TextFormField(
                      controller: pass_input,
                      validator: (val) => validatePassword(val.toString()),
                      keyboardType: TextInputType.emailAddress,
                      obscureText: _passwordVisible,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        icon: const Icon(Icons.password),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(width: 2.0),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          },
                        ),
                      )),
                  TextFormField(
                      controller: repass_input,
                      validator: (val) => validatePassword(val.toString()),
                      keyboardType: TextInputType.emailAddress,
                      obscureText: _passwordVisible2,
                      decoration: InputDecoration(
                        labelText: 'Re-Password',
                        icon: const Icon(Icons.password),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(width: 2.0),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _passwordVisible2
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _passwordVisible2 = !_passwordVisible2;
                            });
                          },
                        ),
                      )),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Checkbox(
                        value: _isChecked,
                        onChanged: (bool? value) {
                          setState(() {
                            _isChecked = value!;
                          });
                        },
                      ),
                      Flexible(
                        child: GestureDetector(
                          onTap: _showEULA,
                          child: const Text('Agree with terms',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              )),
                        ),
                      ),
                      MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        minWidth: 115,
                        height: 50,
                        color: Theme.of(context).colorScheme.primary,
                        child: const Text('Register'),
                        elevation: 10,
                        onPressed: _registerAccount,
                      ),
                    ],
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text(" alrady have account? ",
                            style: TextStyle(
                              fontSize: 16.0,
                            )),
                        GestureDetector(
                            onTap: () => {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              const LoginScreen()))
                                },
                            child: const Text(
                              " Click here",
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ))
                      ]),
                ])),
          ),
        ),
      )),
    );
  }

  String? validatePassword(String value) {
    String pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{4,}$';
    RegExp regex = RegExp(pattern);
    if (value.isEmpty) {
      return 'Please enter password';
    } else {
      if (!regex.hasMatch(value)) {
        return 'Password should contain at least one Uper case, Lower case, at least Ten digit,';
      } else {
        return null;
      }
    }
  }

  void _registerAccount() {
    String _name = name_input.text;
    String _email = email_input.text;
    String _password = pass_input.text;
    String _phone = phon_input.text;

    if (!_formKey.currentState!.validate() && !_isChecked) {
      Fluttertoast.showToast(
          msg: "Please complete the registration form first",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      return;
    } else {
      if (!_isChecked) {
        Fluttertoast.showToast(
            msg: "Please accept the terms and conditions",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14.0);
        return;
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: const Text(
            "Register new account?",
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
                _registeruser(_name, _email, _phone, _password);
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (content) => const LoginScreen()));
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
      },
    );
  }

  loadEola() async {
    WidgetsFlutterBinding.ensureInitialized();

    eula = await rootBundle.loadString('assets/images/eula.txt');
  }

  void _showEULA() {
    loadEola();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "EULA",
            style: TextStyle(),
          ),
          content: SizedBox(
            //  height: screenHeight / 1.5,
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: SingleChildScrollView(
                      child: RichText(
                    softWrap: true,
                    textAlign: TextAlign.justify,
                    text: TextSpan(
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 12.0,
                        ),
                        text: eula),
                  )),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Close",
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  void _registeruser(String name, String email, String phone, String password) {
    http.post(Uri.parse("http://10.19.42.192/homestay/php/register_user.php"),
        body: {
          "name": name,
          "email": email,
          "password": password,
          "phone": phone,
          "register": "register"
        }).then((response) {
      var data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['status'] == 'success') {
        Fluttertoast.showToast(
            msg: "Registration Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14.0);
        return;
      } else {
        Fluttertoast.showToast(
            msg: "Registration Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14.0);
        return;
      }
    });
  }
}

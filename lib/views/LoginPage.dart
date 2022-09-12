import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:solar_recap_app/model/api.dart';
import 'package:solar_recap_app/views/DashboardAdmin.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

enum LoginStatus { notSignIn, signIn }

class _LoginPageState extends State<LoginPage> {
  LoginStatus _loginStatus = LoginStatus.notSignIn;
  String username, password;
  final _key = new GlobalKey<FormState>();
  bool _secureText = true;

  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  var _autoValidate = false;

  check() async {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      login();
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  login() async {
    final response = await http.post(Uri.parse(BaseUrl.urlLogin),
        body: {"username": username, "password": password});
    final data = jsonDecode(response.body);
    int value = data['success'];
    String pesan = data['message'];

    String usernameAPI = data['username'];
    String userIdApi = data['id_user'];
    String namaAPI = data['nama'];
    if (value == 1) {
      setState(() {
        showDialog(
            context: context,
            builder: (context) {
              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Container(
                  height: 150,
                  width: 150,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.white70,
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(top: 20.0),
                            child: Text(
                              "Login Berhasil",
                              style: TextStyle(fontSize: 20.0),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: RaisedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          color: Color(0xff5aa897),
                          child: Text(
                            "OK",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            });
        // showDialog(
        //     context: context,
        //     builder: (BuildContext context) {
        //       return AlertDialog(
        //         title: Text(""),
        //         content: Text("Login Berhasil"),
        //         actions: [
        //           FlatButton(
        //               onPressed: () {
        //                 Navigator.pop(context);
        //               },
        //               child: Text("OK")),
        //         ],
        //       );
        //     });
        _loginStatus = LoginStatus.signIn;
        savePref(value, usernameAPI, userIdApi, namaAPI);
      });
      print(pesan);
    } else {
      print(pesan);
    }
  }

  savePref(int value, String usernameAPI, String namaAPI, userIdApi) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", value);
      preferences.setString("username", usernameAPI);
      preferences.setString("id_user", userIdApi);
      preferences.commit();
    });
  }

  var value;
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      value = preferences.getInt("value");
      if (value == 1) {
        _loginStatus = LoginStatus.signIn;
      } else {
        _loginStatus = LoginStatus.notSignIn;
      }
    });
  }

  signOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", 0);
      preferences.commit();
      _loginStatus = LoginStatus.notSignIn;
    });
  }

  @override
  void initState() {
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    switch (_loginStatus) {
      case LoginStatus.notSignIn:
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            automaticallyImplyLeading: false,
            elevation: 0.0,
            backgroundColor: Color(0xff9aacb8),
            title: Image.asset(
              "assets/img/clariant_logo.png",
              width: 175,
            ),
            centerTitle: true,
          ),
          body: Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            key: _key,
            child: ListView(
              padding: EdgeInsets.symmetric(vertical: 200, horizontal: 100),
              children: [
                Center(
                  child: Text(
                    "Login Admin",
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 15.0,
                ),
                TextFormField(
                  validator: (e) {
                    if (e.isEmpty) {
                      return "Silahkan isi username";
                    } else {
                      return null;
                    }
                  },
                  onSaved: (e) => username = e,
                  decoration: InputDecoration(
                      hintText: "Masukkan Username",
                      hintStyle: TextStyle(color: Colors.grey),
                      labelText: "Username",
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5))),
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  obscureText: _secureText,
                  onSaved: (e) => password = e,
                  decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: Icon(_secureText
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: showHide,
                      ),
                      hintText: "Masukkan Password",
                      hintStyle: TextStyle(color: Colors.grey),
                      labelText: "Password",
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5))),
                ),
                SizedBox(
                  height: 15.0,
                ),
                RaisedButton(
                  padding: EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  child: Text(
                    "LOGIN",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    check();
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => new DashboardAdmin(signOut)));
                  },
                  color: Color(0xff5aa897),
                ),
              ],
            ),
          ),
        );
        break;
      case LoginStatus.signIn:
        return DashboardAdmin(signOut);
        break;
    }
  }
}

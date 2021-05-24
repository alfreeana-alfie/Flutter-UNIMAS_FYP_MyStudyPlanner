import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/animation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:MyUni/auth/sign_up.dart';
import 'package:MyUni/auth/verify_email.dart';
import 'package:MyUni/models/User.dart';
import 'package:MyUni/models/Verify.dart';
import 'package:MyUni/pages/main_screen.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with TickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animationFadeIn;

  User user;
  List userList;
  Map<String, dynamic> userMap;
  Map<String, dynamic> verifyMap;
  String matricNo = "";
  String password = "";

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(duration: Duration(seconds: 2), vsync: this);
    animationFadeIn = CurvedAnimation(parent: controller, curve: Curves.easeIn);
    controller.forward();
  }

  // Methods
  void login() async {
    final prefs = await SharedPreferences.getInstance();

    Uri loginURL =
        Uri.parse("https://hawkingnight.com/planner/public/api/login");
    final response = await http.post(loginURL,
        headers: {"Accept": "application/json"},
        body: {"matric_no": matricNo, "password": password});
    if (response.statusCode == 200) {
      verifyMap = jsonDecode(response.body);
      var verifyData = Verify.fromJSON(verifyMap);

      if (verifyData.status == 'Success') {
        print('Sucess');
        userMap = jsonDecode(response.body);
        var userData = User.fromJSON(userMap);

        prefs.setInt('userID', userData.id);
        prefs.setString('userName', userData.name);
        prefs.setString('userMatricNo', userData.matric_no);
        prefs.setString('userImageURL', userData.image);
        prefs?.setBool("isLoggedIn", true);

        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Sign In Successfully!")));

        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MainScreen()));
      } else {
        print('Failed to fetch');
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Incorrect Matric No or Password")));
      }
    } else {
      throw Exception('Unable to fetch data from the REST API');
    }
  }

  Widget newForm() {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.red, Colors.red[900]])),
      child: FadeTransition(
          opacity: animationFadeIn,
          child: Center(
              child: Material(
                  elevation: 5,
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0),
                  child: Form(
                    key: _formKey,
                    child: Container(
                        width: 360,
                        height: 360,
                        child: Column(
                          children: [
                            // Matric No.
                            matricNoField(),
                            Container(
                                margin: EdgeInsets.fromLTRB(10, 5, 10, 10),
                                decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(40.0)),
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                                  child: TextFormField(
                                      style: TextStyle(
                                          fontFamily: 'Open Sans',
                                          fontSize: 16),
                                      decoration: InputDecoration(
                                          contentPadding:
                                              EdgeInsets.fromLTRB(0, 0, 0, 0),
                                          labelText: 'Password',
                                          icon: Icon(Icons.lock_rounded),
                                          border: InputBorder.none),
                                      onChanged: (value) {
                                        setState(() {
                                          password = value;
                                        });
                                      },
                                      obscureText: true,
                                      validator: (val) {
                                        if (val.isEmpty) {
                                          return 'Pasword is empty!';
                                        }
                                        return null;
                                      }),
                                )),
                            Container(
                                margin: EdgeInsets.fromLTRB(10, 20, 10, 0),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(40.0)),
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                                  child: RichText(
                                      text: TextSpan(
                                          style: TextStyle(
                                              fontFamily: 'Open Sans',
                                              fontWeight: FontWeight.w700,
                                              fontSize: 16,
                                              color: Colors.grey[500]),
                                          children: <TextSpan>[
                                        TextSpan(
                                          text: 'Forgot Password?',
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              // print('button is clicked');
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        Verification()),
                                              );
                                            },
                                        )
                                      ])),
                                )),
                            Container(
                                margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(40.0)),
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: Size(150, 45),
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(30))),
                                    ),
                                    onPressed: () {
                                      if (_formKey.currentState.validate()) {
                                        login();
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text("Error!")));
                                      }
                                    },
                                    child: Text('SIGN IN',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontFamily: 'Open Sans')),
                                  ),
                                )),
                            Container(
                                margin: EdgeInsets.fromLTRB(10, 5, 10, 0),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(40.0)),
                                child: Padding(
                                    padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                    child: RichText(
                                        text: TextSpan(
                                            style: TextStyle(
                                                fontFamily: 'Open Sans',
                                                fontWeight: FontWeight.w700,
                                                fontSize: 20,
                                                color: Colors.blue),
                                            children: <TextSpan>[
                                          TextSpan(
                                            text: 'SIGNUP',
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {
                                                // print('button is clicked');
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          Register()),
                                                );
                                              },
                                          )
                                        ])))),
                            // Password
                            // TextFormField(),
                          ],
                        )),
                  )))),
    );
  }

  // Inner Widget
  Widget matricNoField() {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 30, 10, 10),
      decoration: BoxDecoration(
          color: Colors.grey[200], borderRadius: BorderRadius.circular(40.0)),
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
        child: TextFormField(
          style: TextStyle(fontFamily: 'Open Sans', fontSize: 16),
          decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              labelText: 'Matric No',
              icon: Icon(Icons.account_circle),
              border: InputBorder.none),
          onChanged: (value) {
            setState(() {
              matricNo = value;
            });
          },
          validator: (val) {
            if (val.isEmpty) {
              return 'Matric No is empty!';
            }
            return null;
          }
        ),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return OKToast(child: Scaffold(body: newForm()));
  }
}

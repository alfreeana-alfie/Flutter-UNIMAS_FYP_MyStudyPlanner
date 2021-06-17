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
  Animation<double> animation;

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
    animation = CurvedAnimation(parent: controller, curve: Curves.easeIn);
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

  // Inner Widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SingleChildScrollView(child: buildMainContainer()));
  }
  
  Widget buildMainContainer() {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.red[800], Colors.red[300]])),
      child: Stack(
        children: [
          buildTitle(),
          buildCard()
        ],
      ),
    );
  }

  Widget buildCard() {
    return Container(
        margin: EdgeInsets.fromLTRB(0, 250, 0, 0),
        child: Material(
            elevation: 5,
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
            child: Form(
              key: _formKey,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 700,
                  child: Column(
                    children: [
                      buildMatricNo(),
                      buildPassword(),
                      buildForgotPassword(),
                      buildSignIn(),
                      buildSignUp()
                    ],
                  ))
              )
            )));
  }

  Widget buildTitle() {
    return Container(
      margin: EdgeInsets.fromLTRB(20, 110, 30, 0),
      child: Column(

        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text('Login',
              style: TextStyle(
                  fontFamily: 'Metropolis',
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  fontSize: 52)),),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 20, 0),
            child: Align(
            alignment: Alignment.centerLeft,
            child: Text('Enter a beautiful world',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24, 
                fontFamily: 'Metropolis'))  
            ),
          )
        ],
    ));
  }

  
  Widget buildMatricNo() {
    return Container(
        margin: EdgeInsets.fromLTRB(20, 140, 20, 10),
        decoration: BoxDecoration(
            color: Colors.grey[200], borderRadius: BorderRadius.circular(10.0)),
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
              }),
        ));
  }

  Widget buildPassword() {
    return Container(
        margin: EdgeInsets.fromLTRB(20, 10, 20, 5),
        decoration: BoxDecoration(
            color: Colors.grey[200], borderRadius: BorderRadius.circular(10.0)),
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
          child: TextFormField(
              style: TextStyle(fontFamily: 'Open Sans', fontSize: 16),
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
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
        ));
  }

  Widget buildForgotPassword() {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
          margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(40.0)),
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
                              builder: (context) => Verification()),
                        );
                      },
                  )
                ])),
          )),
    );
  }

  Widget buildSignIn() {
    return Container(
        margin: EdgeInsets.fromLTRB(10, 50, 10, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
              child: ElevatedButton(
                
                style: ElevatedButton.styleFrom(
                  primary: Colors.red[600],
                  minimumSize: Size(600, 45),
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                ),
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    login();
                  } else {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text("Error!")));
                  }
                },
                child: Text('LOGIN',
                    style: TextStyle(fontSize: 18, fontFamily: 'Open Sans')),
              ),
            )
          ],
        ));
  }

  Widget buildSignUp() {
    return Align(
      alignment: Alignment.center,
      child: Container(
          margin: EdgeInsets.fromLTRB(10, 120, 10, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Text(
                    'Don\'t Have An Account? ',
                    style: TextStyle(
                        fontFamily: 'Open Sans',
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: Colors.grey),
                  )),
              Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: RichText(
                      text: TextSpan(
                          style: TextStyle(
                              fontFamily: 'Open Sans',
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              color: Colors.red[600]),
                          children: <TextSpan>[
                        TextSpan(
                          text: 'Register Now',
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              // print('button is clicked');
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Register()),
                              );
                            },
                        )
                      ])))
            ],
          )),
    );
  }

  
}

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:MyUni/auth/sign_up.dart';
import 'package:MyUni/auth/verify_email.dart';
import 'package:oktoast/oktoast.dart';
import 'package:http/http.dart' as http;
import 'package:MyUni/models/User.dart';
import 'package:MyUni/pages/main_screen.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String matricNo = "";
  String password = "";

  final _formKey = GlobalKey<FormState>();

  User user;
  List userList;
  Map<String, dynamic> userMap;

  // Methods
  void login() async {
    final prefs = await SharedPreferences.getInstance();
    String postURL = "https://hawkingnight.com/planner/public/api/login";
    Uri postURI = Uri.parse(postURL);
    await http.post(postURI, headers: {
      "Accept": "application/json"
    }, body: {
      "matric_no": matricNo,
      "password": password,
    }).then((value) {
      userMap = jsonDecode(value.body);
      var user = User.fromJSON(userMap);

      prefs.setInt('userID', user.id);
      prefs.setString('name', "${user.name}");
      prefs.setString('email', "${user.email}");
      prefs.setString('phone_no', "${user.phone_no}");
      prefs.setString('matric_no', "${user.matric_no}");
      prefs.setString('image', "${user.image}");

      // ScaffoldMessenger.of(context)
      //     .showSnackBar(SnackBar(content: Text("Sign In Successfully!")));
      // if (value.statusCode == 200) {
      //   Navigator.push(
      //       context, MaterialPageRoute(builder: (context) => MainScreen()));
      // }
    });
  }

  // Widgets
  Widget form() {
    return Form(
      key: _formKey,
      child: Container(
          margin: EdgeInsets.fromLTRB(50, 10, 50, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Matric No',
                  icon: Icon(Icons.person),
                ),
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
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Password',
                  icon: Icon(Icons.lock),
                ),
                onChanged: (value) {
                  setState(() {
                    password = value;
                    // print(password);
                  });
                },
                obscureText: true,
                validator: (val) {
                  if (val.isEmpty) {
                    return 'Password is empty!';
                  }
                  return null;
                },
              ),
              Container(
                  margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: RichText(
                      text: TextSpan(
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: Colors.blue[600]),
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
                      ]))),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    login();
                  } else {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text("Error!")));
                  }
                },
                child: Text('SIGN IN',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    )),
              ),
              Container(
                  margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RichText(
                            text: TextSpan(
                                text: 'Don\'t have an account? ',
                                style: TextStyle(
                                    fontSize: 14, color: Colors.grey[600]),
                                children: <TextSpan>[
                              TextSpan(
                                text: 'SIGN UP HERE',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Colors.blue[600]),
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
                            ]))
                      ])),
            ],
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return OKToast(
        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
                backgroundColor: Colors.red[900],
                elevation: 0.0,
                title: Center(
                  child: Text('SIGN IN'),
                )),
            body: form()));
  }
}

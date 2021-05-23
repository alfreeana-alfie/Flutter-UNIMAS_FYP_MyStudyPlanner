import 'dart:convert';
import 'package:MyUni/auth/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:oktoast/oktoast.dart';

import 'package:MyUni/models/Verify.dart';

class ForgotPassword extends StatefulWidget {
  String matric_no;
  String email;

  ForgotPassword({Key key, this.matric_no, this.email}) : super(key: key);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {

  // Variables
  String password = "";
  String password_confirm = "";
  String userID;

  final _formKey = GlobalKey<FormState>();
  Map<String, dynamic> verifyMap;

  // Methods
  void getData() async {
    Uri loginURI =
        Uri.parse("https://hawkingnight.com/planner/public/api/forgot");

    final response = await http
        .post(
          loginURI, 
          headers: {"Accept": "application/json"}, 
          body: {
            "email": widget.email,
            "matric_no": widget.matric_no,
            "password": password
          });

    if(response.statusCode == 200) {
      verifyMap = jsonDecode(response.body);

      var verifyData = Verify.fromJSON(verifyMap);
      if (verifyData.status == "Success") {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Reset Successfully")));
            
        Navigator.push(
          context, MaterialPageRoute(builder: (context) => Login()));
      }else{
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Incorrect Password/Confirm Password")));
      }
    }else{
      throw Exception('Unable to fetch data from the REST API');
    }
  }

  // Widgets
  Widget form() {
    return Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Password',
                icon: Icon(Icons.lock),
              ),
              onChanged: (value) {
                setState(() {
                  password = value;
                });
              },
              validator: (val) {
                if (val.isEmpty) {
                  return 'Password is empty!';
                }
                return null;
              },
            ),
            TextFormField(
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  icon: Icon(Icons.lock),
                ),
                onChanged: (value) {
                  setState(() {
                    password_confirm = value;
                  });
                },
                obscureText: true,
                validator: (val) {
                  if (val.isEmpty) {
                    return 'Confirm Password is empty!';
                  } else if (val == password) {
                    return 'Confirm Password does not match!';
                  }
                  return null;
                }),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  getData();
                } else {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text("Error!")));
                }
              },
              child: Text('RESET NEW PASSWORD',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  )),
            ),
          ],
        ));
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
            child: Text('FORGOT PASSWORD?'),
          )),
      body: form(),
    ));
  }
}

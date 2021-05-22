import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:http/http.dart' as http;

import 'package:MyUni/models/Verify.dart';

import 'forgot_password.dart';

class Verification extends StatefulWidget {
  @override
  _VerificationState createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {
  // Variables
  final _formKey = GlobalKey<FormState>();

  String matricNo = "";
  String email = "";
  Map<String, dynamic> verifyMap;

  // Methods
  void verify() async {
    Uri getVerifyURL =
        Uri.parse("https://hawkingnight.com/planner/public/api/verify");
    final response = await http.post(getVerifyURL,
        headers: {"Accept": "application/json"},
        body: {"matric_no": matricNo, "email": email});

    if (response.statusCode == 200) {
      print('Succcess Verified');
      verifyMap = jsonDecode(response.body);

      var verifyData = Verify.fromJSON(verifyMap);

      if (verifyData.status == "Success") {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ForgotPassword(
              matric_no: matricNo,
              email: email
            )));
      }
    } else {
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
                  labelText: 'Email Address',
                  icon: Icon(Icons.lock),
                ),
                onChanged: (value) {
                  setState(() {
                    email = value;
                  });
                },
                obscureText: true,
                validator: (val) {
                  if (val.isEmpty) {
                    return 'Email Address is empty!';
                  }
                  return null;
                }),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  verify();
                } else {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text("Error!")));
                }
              },
              child: Text('VERIFY',
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
                  child: Text('VERIFICATION'),
                )),
            body: form()));
  }
}

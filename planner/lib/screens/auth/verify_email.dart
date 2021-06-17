import 'dart:convert';
import 'package:MyUni/screens/auth/sign_up.dart';
import 'package:flutter/gestures.dart';
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
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ForgotPassword(matric_no: matricNo, email: email)));
      }
    } else {
      throw Exception('Unable to fetch data from the REST API');
    }
  }

  // Widgets
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

  Widget buildTitle() {
    return Container(
      margin: EdgeInsets.fromLTRB(20, 110, 30, 0),
      child: Column(

        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text('Forgot Password? ',
              style: TextStyle(
                  fontFamily: 'Metropolis',
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  fontSize: 48)),),
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
                      buildEmail(),
                      buildVerifyButton(),
                      buildSignUp()
                    ],
                  ))
              )
            )));
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

  Widget buildEmail() {
    return Container(
        margin: EdgeInsets.fromLTRB(20, 0, 20, 10),
        decoration: BoxDecoration(
            color: Colors.grey[200], borderRadius: BorderRadius.circular(10.0)),
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
          child: TextFormField(
              style: TextStyle(fontFamily: 'Open Sans', fontSize: 16),
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  labelText: 'Email',
                  border: InputBorder.none),
              onChanged: (value) {
                setState(() {
                  email = value;
                });
              },
              validator: (val) {
                if (val.isEmpty) {
                  return 'Email is empty!';
                }
                return null;
              }),
        ));
  }

  Widget buildVerifyButton() {
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
                    verify();
                  } else {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text("Error!")));
                  }
                },
                child: Text('VERIFY',
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
            children: [
              Padding(
                  padding: EdgeInsets.fromLTRB(40, 0, 10, 0),
                  child: Text(
                    'Don\'t Have An Account? ',
                    style: TextStyle(
                        fontFamily: 'Open Sans',
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: Colors.grey),
                  )),
              Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 50, 0),
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

  @override
  Widget build(BuildContext context) {
    return OKToast(child: Scaffold(body: buildMainContainer()));
  }
}

import 'dart:convert';
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

    final response = await http.post(loginURI, headers: {
      "Accept": "application/json"
    }, body: {
      "email": widget.email,
      "matric_no": widget.matric_no,
      "password": password
    });

    if (response.statusCode == 200) {
      verifyMap = jsonDecode(response.body);

      var verifyData = Verify.fromJSON(verifyMap);
      if (verifyData.status == "Success") {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Reset Successfully")));

        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Login()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Incorrect Password/Confirm Password")));
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
                      buildPassword(),
                      buildConfirmPassword(),
                      buildSubmitButton()
                    ],
                  ))
              )
            )));
  }

  Widget buildPassword() {
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
                  labelText: 'Password',
                  border: InputBorder.none),
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
              }),
        ));
  }

  Widget buildConfirmPassword() {
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
                  labelText: 'Confirm Password',
                  border: InputBorder.none),
              onChanged: (value) {
                setState(() {
                  password_confirm = value;
                });
              },
              validator: (val) {
                if (val.isEmpty) {
                    return 'Confirm Password is empty!';
                  } else if (val != password) {
                    return 'Confirm Password does not match!';
                  }
                  return null;
              }),
        ));
  }

  Widget buildSubmitButton() {
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
                    getData();
                  } else {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text("Error!")));
                  }
                },
                child: Text('SUBMIT',
                    style: TextStyle(fontSize: 18, fontFamily: 'Open Sans')),
              ),
            )
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return OKToast(child: Scaffold(body: buildMainContainer()));
  }
}

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:oktoast/oktoast.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  String password = "";
  String password_confirm = "";
  String userID;

  final _formKey = GlobalKey<FormState>();

  // Methods
  void getData() async {
    String loginString = "http://hawkingnight.com/my-uni/public/api/forgot";
    Uri loginURI = Uri.parse(loginString);
    await http.post(loginURI, headers: {
      "Accept": "application/json"
    }, body: {
      "id": userID,
      "password": password,
    }).then((value) => print("Response Status : ${value.statusCode}"));
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
                  if(val.isEmpty){
                    return 'Confirm Password is empty!';
                  }else if (val == password){
                    return 'Confirm Password does not match!'; 
                  }
                  return null;
                }
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    getData();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error!")));
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
        )
    );
  }
}
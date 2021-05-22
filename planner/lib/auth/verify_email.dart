import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:http/http.dart' as http;

class Verification extends StatefulWidget {
  @override
  _VerificationState createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {
  String matricNo = "";
  String email = "";

  final _formKey = GlobalKey<FormState>();

  // Methods 
  void verify() async {
    String loginString = "http://hawkingnight.com/my-uni/public/api/verify";
    Uri loginURI = Uri.parse(loginString);
    await http.post(loginURI, headers: {
      "Accept": "application/json"
    }, body: {
      "matric_no": matricNo,
      "email": email,
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
                  if(val.isEmpty){
                    return 'Email Address is empty!';
                  }
                  return null;
                }
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    verify();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error!")));
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
          body: form()
        )
    );
  }
}
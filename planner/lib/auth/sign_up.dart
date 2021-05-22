import 'package:flutter/material.dart';
import 'package:MyUni/auth/sign_up_address.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String name = "";
  String email = "";
  String password = "";
  String passwordConfirm = "";
  String matricNo = "";
  String phoneNo = "";

  // Variables
  final _formKey = GlobalKey<FormState>();

  // Widget
  Widget form(){
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
                    labelText: 'Full Name',
                  ),
                  onChanged: (value) {
                    setState(() {
                      name = value;
                    });
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Full Name is empty!';
                    }
                    return null;
                  }),
              TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Email Address',
                  ),
                  onChanged: (value) {
                    setState(() {
                      email = value;
                    });
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Email Address is empty!';
                    }
                    return null;
                  }),
              TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Password',
                  ),
                  onChanged: (value) {
                    setState(() {
                      password = value;
                    });
                  },
                  obscureText: true,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Password is empty!';
                    }
                    return null;
                  }),
              TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                  ),
                  onChanged: (value) {
                    setState(() {
                      passwordConfirm = value;
                    });
                  },
                  obscureText: true,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Confirm Password is empty!';
                    } else if (value != password) {
                      return 'Not match with Password!';
                    }
                    return null;
                  }),
              TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Phone No',
                  ),
                  onChanged: (value) {
                    setState(() {
                      phoneNo = value;
                    });
                  },
                  
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Phone No is empty!';
                    }
                    return null;
                  }),
              TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Matric No',
                  ),
                  onChanged: (value) {
                    setState(() {
                      matricNo = value;
                    });
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Matric No is empty!';
                    }
                    return null;
                  }),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RegisterAddress(
                              name: name,
                              email: email,
                              password: password,
                              matricNo: matricNo,
                              phoneNo: phoneNo)),
                    );
                  } else {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text("Error!")));
                  }
                },
                child: Text('NEXT',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              )
            ],
          )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.red[900],
            elevation: 0.0,
            title: Center(
              child: Text('SIGN UP'),
            )),
        body: form());
  }
}

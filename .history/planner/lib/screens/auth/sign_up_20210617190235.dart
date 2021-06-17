import 'package:MyUni/auth/sign_in.dart';
import 'package:MyUni/screens/auth/sign_in.dart';
import 'package:MyUni/screens/auth/sign_up_address.dart';
import 'package:flutter/material.dart';
import 'package:MyUni/auth/sign_up_address.dart';
import 'package:oktoast/oktoast.dart';
import 'package:flutter/gestures.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> with TickerProviderStateMixin {

  // Variables
  AnimationController controller;
  Animation<double> animation;

  String name = "";
  String email = "";
  String password = "";
  String passwordConfirm = "";
  String matricNo = "";
  String phoneNo = "";

  final _formKey = GlobalKey<FormState>();

  // Methods
  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(duration: Duration(seconds: 2), vsync: this);
    animation = CurvedAnimation(parent: controller, curve: Curves.easeIn);
    controller.forward();
  }

  // Inner Widget
  // build
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
              colors: [Colors.red[800], Colors.red[300]]),
        ),
        child: Stack(
          children: [
            buildTitle(),
            buildCard(),
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
              child: Column(
                children: [
                  buildName(),
                  buildEmail(),
                  buildPassword(),
                  buildConfirmPassword(),
                  buildPhoneNo(),
                  buildMatricNo(),
                  buildNextButton(),
                  buildSignIn(),
                ],
              ),
            )
          )
        ),
      ),
    );
  }

  Widget buildName() {
    return Container(
        margin: EdgeInsets.fromLTRB(20, 50, 20, 10),
        decoration: BoxDecoration(
            color: Colors.grey[200], borderRadius: BorderRadius.circular(10.0)),
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
          child: TextFormField(
              style: TextStyle(fontFamily: 'Open Sans', fontSize: 16),
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  labelText: 'Full Name',
                  border: InputBorder.none),
              onChanged: (value) {
                setState(() {
                  name = value;
                });
              },
              validator: (val) {
                if (val.isEmpty) {
                  return 'Full Name is empty!';
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

  Widget buildPassword() {
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
                  passwordConfirm = value;
                });
              },
              validator: (value) {
                if (value.isEmpty) {
                  return 'Confirm Password is empty!';
                } else if (value != password) {
                  return 'Not match with Password!';
                }
                return null;
              }),
        ));
  }

  Widget buildPhoneNo() {
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
                  labelText: 'Phone No',
                  border: InputBorder.none),
              onChanged: (value) {
                setState(() {
                  phoneNo = value;
                });
              },
              validator: (val) {
                if (val.isEmpty) {
                  return 'Phone No is empty!';
                }
                return null;
              }),
        ));
  }

  Widget buildMatricNo() {
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

  Widget buildNextButton() {
    return Container(
      margin: EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.red[600],
                minimumSize: Size(150, 45),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5))),
              ),
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
                  style: TextStyle(fontSize: 18, fontFamily: 'Open Sans')),
            ),
          )
        ],
      )
    );
  }

  Widget buildTitle() {
    return Container(
      margin: EdgeInsets.fromLTRB(20, 110, 30, 0),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text('Create an Account',
              style: TextStyle(
                fontFamily: 'Metropolis',
                fontWeight: FontWeight.w800,
                color: Colors.white,
                fontSize: 42
              )
            ),
          ),
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

  Widget buildSignIn() {
    return Align(
      alignment: Alignment.center,
      child: Container(
          margin: EdgeInsets.fromLTRB(40, 20, 40, 50),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Text(
                    'Already Have an Account? ',
                    style: TextStyle(
                        fontFamily: 'Open Sans',
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: Colors.grey),
                  )),
              Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                  child: RichText(
                      text: TextSpan(
                          style: TextStyle(
                              fontFamily: 'Open Sans',
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              color: Colors.red[600]),
                          children: <TextSpan>[
                        TextSpan(
                          text: 'Login',
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              // print('button is clicked');
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Login()),
                              );
                            },
                        )
                      ])))
            ],
          )),
    );
  }

}
import 'package:flutter/material.dart';
import 'package:MyUni/auth/sign_up_address.dart';
import 'package:oktoast/oktoast.dart';

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

  // Widget
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

  Widget buildMainContainer() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.red, Colors.red[900]]),
      ),
      child: FadeTransition(
          opacity: animation,
          child: Center(
            child: Material(
              elevation: 5,
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
              child: Form(
                  key: _formKey,
                  child: Container(
                    width: 360,
                    height: 520,
                    child: Column(
                      children: [
                        buildName(),
                        buildEmail(),
                        buildPassword(),
                        buildConfirmPassword(),
                        buildPhoneNo(),
                        buildMatricNo(),
                        buildNextButton()
                      ],
                    ),
                  )),
            ),
          )),
    );
  }

  // Inner Widget
  Widget buildName() {
    return Container(
        margin: EdgeInsets.fromLTRB(10, 30, 10, 10),
        decoration: BoxDecoration(
            color: Colors.grey[200], borderRadius: BorderRadius.circular(40.0)),
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
        margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
        decoration: BoxDecoration(
            color: Colors.grey[200], borderRadius: BorderRadius.circular(40.0)),
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
        margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
        decoration: BoxDecoration(
            color: Colors.grey[200], borderRadius: BorderRadius.circular(40.0)),
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
        margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
        decoration: BoxDecoration(
            color: Colors.grey[200], borderRadius: BorderRadius.circular(40.0)),
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
        margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
        decoration: BoxDecoration(
            color: Colors.grey[200], borderRadius: BorderRadius.circular(40.0)),
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
        margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
        decoration: BoxDecoration(
            color: Colors.grey[200], borderRadius: BorderRadius.circular(40.0)),
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
        margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(40.0)),
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: Size(150, 45),
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30))),
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
        ));
  }

  // build
  @override
  Widget build(BuildContext context) {
    return OKToast(child: Scaffold(body: buildMainContainer()));
  }
}

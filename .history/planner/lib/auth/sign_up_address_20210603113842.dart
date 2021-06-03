import 'package:flutter/material.dart';
import 'package:MyUni/auth/sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:oktoast/oktoast.dart';
import 'package:flutter/gestures.dart';

class RegisterAddress extends StatefulWidget {
  //User Part
  String name;
  String email;
  String password;
  String matricNo;
  String phoneNo;

  RegisterAddress(
      {Key key,
      this.name,
      this.email,
      this.password,
      this.matricNo,
      this.phoneNo})
      : super(key: key);

  @override
  _RegisterAddressState createState() => _RegisterAddressState();
}

class _RegisterAddressState extends State<RegisterAddress> {
  //Address Part
  String address = "";
  String otherAddress = "";
  String postcode = "";
  String city = "";
  String state = "";
  String country = "";

  // Variables
  final _formKey = GlobalKey<FormState>();

  // Methods

  // build
  @override
  Widget build(BuildContext context) {
    return OKToast(child: Scaffold(body: buildMainContainer()));
  }
  void register() async {
    Uri register =
        Uri.parse("https://hawkingnight.com/planner/public/api/register");
    final response = await http.post(register, headers: {
      "Accept": "application/json"
    }, body: {
      'name': widget.name,
      'email': widget.email,
      'password': widget.password,
      'matric_no': widget.matricNo,
      'phone_no': widget.phoneNo,
      'image': 'https://hawkingnight.com/planner/assets/user.png',
      'address': address,
      'other_address': otherAddress,
      'postcode': postcode,
      'city': city,
      'state': state,
      'country': country
    });

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Success!")));
      Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
    } else {
      // print(response.statusCode);
      // print(response.body);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(response.body)));
    }
  }

  // Widget
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
                      buildAddress(),
                      buildOtherAddress(),
                      buildCity(),
                      buildState(),
                      buildCountry(),
                      buildNextButton(),
                      buildSignIn(),
                    ],
                  ),
                ))),
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
              child: Text('Create an Account',
                  style: TextStyle(
                      fontFamily: 'Metropolis',
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      fontSize: 42)),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 10, 20, 0),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Enter a beautiful world',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontFamily: 'Metropolis'))),
            )
          ],
        ));
  }

  Widget buildAddress() {
    return Container(
        margin: EdgeInsets.fromLTRB(10, 50, 10, 10),
        decoration: BoxDecoration(
            color: Colors.grey[200], borderRadius: BorderRadius.circular(10.0)),
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
          child: TextFormField(
              style: TextStyle(fontFamily: 'Open Sans', fontSize: 16),
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  labelText: 'Address',
                  border: InputBorder.none),
              onChanged: (value) {
                setState(() {
                  address = value;
                });
              },
              validator: (val) {
                if (val.isEmpty) {
                  return 'Address is empty!';
                }
                return null;
              }),
        ));
  }

  Widget buildOtherAddress() {
    return Container(
        margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
        decoration: BoxDecoration(
            color: Colors.grey[200], borderRadius: BorderRadius.circular(10.0)),
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
          child: TextFormField(
              style: TextStyle(fontFamily: 'Open Sans', fontSize: 16),
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  labelText: 'Other Address',
                  border: InputBorder.none),
              onChanged: (value) {
                setState(() {
                  otherAddress = value;
                });
              },
              validator: (val) {
                if (val.isEmpty) {
                  return 'Other Address is empty!';
                }
                return null;
              }),
        ));
  }

  Widget buildCity() {
    return Container(
        margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
        decoration: BoxDecoration(
            color: Colors.grey[200], borderRadius: BorderRadius.circular(10.0)),
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
          child: TextFormField(
              style: TextStyle(fontFamily: 'Open Sans', fontSize: 16),
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  labelText: 'City',
                  border: InputBorder.none),
              onChanged: (value) {
                setState(() {
                  city = value;
                });
              },
              validator: (val) {
                if (val.isEmpty) {
                  return 'City is empty!';
                }
                return null;
              }),
        ));
  }

  Widget buildState() {
    return Container(
        margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
        decoration: BoxDecoration(
            color: Colors.grey[200], borderRadius: BorderRadius.circular(10.0)),
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
          child: TextFormField(
              style: TextStyle(fontFamily: 'Open Sans', fontSize: 16),
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  labelText: 'State',
                  border: InputBorder.none),
              onChanged: (value) {
                setState(() {
                  state = value;
                });
              },
              validator: (val) {
                if (val.isEmpty) {
                  return 'State is empty!';
                }
                return null;
              }),
        ));
  }

  Widget buildCountry() {
    return Container(
        margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
        decoration: BoxDecoration(
            color: Colors.grey[200], borderRadius: BorderRadius.circular(10.0)),
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
          child: TextFormField(
              style: TextStyle(fontFamily: 'Open Sans', fontSize: 16),
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  labelText: 'Country',
                  border: InputBorder.none),
              onChanged: (value) {
                setState(() {
                  country = value;
                });
              },
              validator: (val) {
                if (val.isEmpty) {
                  return 'Country is empty!';
                }
                return null;
              }),
        ));
  }

  Widget buildNextButton() {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
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
                  register();
                } else {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text("Error!")));
                }
              },
              child: Text('SIGN UP',
                  style: TextStyle(fontSize: 18, fontFamily: 'Open Sans')),
            ),
          )
        ],
      )
    );
  }

  Widget buildSignIn() {
    return Align(
      alignment: Alignment.center,
      child: Container(
          margin: EdgeInsets.fromLTRB(40, 50, 40, 0),
          child: Row(
            children: [
              Padding(
                  padding: EdgeInsets.fromLTRB(50, 0, 10, 0),
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

import 'package:flutter/material.dart';
import 'package:MyUni/auth/sign_in.dart';
import 'package:http/http.dart' as http;

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
                      labelText: 'First Address',
                    ),
                    onChanged: (value) {
                      setState(() {
                        address = value;
                      });
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'First Address is empty!';
                      }
                      return null;
                    }),
                TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Second Address',
                    ),
                    onChanged: (value) {
                      setState(() {
                        otherAddress = value;
                      });
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Other Address is empty!';
                      }
                      return null;
                    }),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'City',
                  ),
                  onChanged: (value) {
                    setState(() {
                      city = value;
                    });
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'City is empty!';
                    }
                    return null;
                  },
                ),
                TextFormField(
                    decoration: InputDecoration(labelText: 'Postcode'),
                    onChanged: (value) {
                      setState(() {
                        postcode = value;
                      });
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Postcode is empty!';
                      }
                      return null;
                    }),
                TextFormField(
                    decoration: InputDecoration(labelText: 'State'),
                    onChanged: (value) {
                      setState(() {
                        state = value;
                      });
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'State is empty!';
                      }
                      return null;
                    }),
                TextFormField(
                    decoration: InputDecoration(labelText: 'Country'),
                    onChanged: (value) {
                      setState(() {
                        country = value;
                      });
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Country is empty!';
                      }
                      return null;
                    }),
                ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        register();
                      } else {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text('Error!')));
                      }
                    },
                    child: Text('SIGN UP',
                        style: TextStyle(fontWeight: FontWeight.bold)))
              ],
            )),
      );
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
      body: form()
    );
  }
}

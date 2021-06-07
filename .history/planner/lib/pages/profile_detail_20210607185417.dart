import 'dart:convert';

import 'package:MyUni/models/User.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:MyUni/models/Verify.dart';

class ProfileDetail extends StatefulWidget {
  @override
  _ProfileDetailState createState() => _ProfileDetailState();
}

class _ProfileDetailState extends State<ProfileDetail> {
  // Variables
  int userID = 0;
  String imageURL = '';
  String name = "";
  String nameStatic;
  String email = "";
  String matricNo = "";
  String phoneNo = "";
  String address = "";
  String otherAddress = "";
  String postcode = "";
  String city = "";
  String state = "";
  String country = "";

  Map<String, dynamic> verifyMap;
  Map<String, dynamic> userMap;

  final _formKey = GlobalKey<FormState>();

  // Methods
  Future getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (this.mounted) {
      setState(() {
        userID = prefs.getInt('userID');
        nameStatic = prefs.getString('userName');

        getDataAPI();
      });
    }
  }

  Future getDataAPI() async {
    Uri getAPILink =
        Uri.parse("https://hawkingnight.com/planner/public/api/user/$userID");

    final response =
        await http.get(getAPILink, headers: {"Accept": "application/json"});

    if (response.statusCode == 200) {
      verifyMap = jsonDecode(response.body);
      var verifyData = Verify.fromJSON(verifyMap);

      if (verifyData.status == "SUCCESS") {
        userMap = jsonDecode(response.body);
        var userData = User.fromJSON(userMap);

        if (this.mounted) {
          setState(() {
            name = userData.name;
            email = userData.email;
            phoneNo = userData.phone_no;
            matricNo = userData.matric_no;
            imageURL = userData.image;
          });
        }
      } else {
        print('FAILED');
      }
    } else {
      throw Exception('Unable to fetch data from the REST API');
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  // Widgets
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [],
        title: Text('My Detail(s)'),
        backgroundColor: Colors.blue,
        elevation: 0.0,
      ),
      body: buildMainContainer(),
    );
  }

  Widget buildMainContainer() {
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              buildImage(),
              buildName(),
              buildEmail(),
              buildMatricNo(),
              buildPhoneNo(),
              buildAddress(),
              buildOtherAddress(),
              buildPostcode(),
              buildCity(),
              buildState(),
              buildCountry(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildImage() {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Center(
          // alignment: Alignment.centerLeft,
          child: CircleAvatar(
        radius: 50,
        backgroundImage: NetworkImage(imageURL),
      )),
    );
  }

  Widget buildName() {
    return Container(
      margin: EdgeInsets.fromLTRB(20, 50, 20, 10),
      decoration: BoxDecoration(
          color: Colors.grey[200], borderRadius: BorderRadius.circular(10.0)),
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
        child: TextField(
            initialValue: ,
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
      ),
    );
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
      ),
    );
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
      ),
    );
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
      ),
    );
  }

  Widget buildAddress() {
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
      ),
    );
  }

  Widget buildOtherAddress() {
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
      ),
    );
  }

  Widget buildPostcode() {
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
                labelText: 'Postcode',
                border: InputBorder.none),
            onChanged: (value) {
              setState(() {
                postcode = value;
              });
            },
            validator: (val) {
              if (val.isEmpty) {
                return 'Postcode is empty!';
              }
              return null;
            }),
      ),
    );
  }

  Widget buildCity() {
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
      ),
    );
  }

  Widget buildState() {
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
      ),
    );
  }

  Widget buildCountry() {
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
      ),
    );
  }
}

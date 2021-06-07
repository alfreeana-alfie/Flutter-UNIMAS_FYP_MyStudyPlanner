import 'package:flutter/material.dart';

class ProfileDetail extends StatefulWidget {
  @override
  _ProfileDetailState createState() => _ProfileDetailState();
}

class _ProfileDetailState extends State<ProfileDetail> {
  String name = "";
  String email = "";
  String matricNo = "";
  String phoneNo = "";
  String address = "";
  String otherAddress = "";
  String postcode = "";
  String city = "";
  String state = "";
  String country = "";
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Detail(s)'),
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: buildMainContainer(),
    );
  }

  Widget buildMainContainer() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildName(),
          buildEmail(),
        ],
      ),
    );
  }

  Widget buildImage() {}

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
      margin: EdgeInsets.fromLTRB(20, 50, 20, 10),
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
      margin: EdgeInsets.fromLTRB(20, 50, 20, 10),
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
      margin: EdgeInsets.fromLTRB(20, 50, 20, 10),
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
      margin: EdgeInsets.fromLTRB(20, 50, 20, 10),
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
                name = value;
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

  Widget buildPostcode() {}

  Widget buildCity() {}

  Widget buildState() {}

  Widget buildCountry() {}
}

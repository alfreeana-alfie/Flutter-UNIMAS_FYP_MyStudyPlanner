import 'dart:convert';

import 'package:MyUni/models/Address.dart';
import 'package:MyUni/models/User.dart';
import 'package:MyUni/screens/auth/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
  String email = "";
  String matricNo = "";
  String phoneNo = "";
  String address = "";
  String otherAddress = "";
  String postcode = "";
  String city = "";
  String state = "";
  String country = "";

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController matricNoController = TextEditingController();
  TextEditingController phoneNoController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController otherAddressController = TextEditingController();
  TextEditingController postcodeController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController countryController = TextEditingController();

  Map<String, dynamic> verifyMap;
  Map<String, dynamic> userMap;
  Map<String, dynamic> addressMap;

  final _formKey = GlobalKey<FormState>();

  bool isEnabled = false;
  // final icons = isEnabled == true ? Icon(Icons.edit) : Icon(Icons.save);

  // Methods
  Future getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (this.mounted) {
        userID = prefs.getInt('userID');

        getDataAPI();
        getAddress();
      // setState(() {
      // });
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
            nameController.text = userData.name;
            emailController.text = userData.email;
            phoneNoController.text = userData.phone_no;
            matricNoController.text = userData.matric_no;

            name = userData.name;
            email = userData.email;
            phoneNo = userData.phone_no;
            matricNo = userData.matric_no;
            imageURL = userData.image;
          // setState(() {
          // });
        }
      } else {
        print('FAILED');
      }
    } else {
      throw Exception('Unable to fetch data from the REST API');
    }
  }

  Future getAddress() async {
    Uri getAPILink =
        Uri.parse("https://hawkingnight.com/planner/public/api/fetch/$userID");

    final response =
        await http.get(getAPILink, headers: {"Accept": "application/json"});

    if (response.statusCode == 200) {
      verifyMap = jsonDecode(response.body);
      var verifyData = Verify.fromJSON(verifyMap);

      if (verifyData.status == "SUCCESS") {
        addressMap = jsonDecode(response.body);
        var addressData = Address.fromJSON(addressMap);

        if (this.mounted) {
          setState(() {
            addressController.text = addressData.address;
            otherAddressController.text = addressData.other_address;
            postcodeController.text = addressData.postcode;
            stateController.text = addressData.state;
            cityController.text = addressData.city;
            countryController.text = addressData.country;

            address = addressData.address;
            otherAddress = addressData.other_address;
            postcode = addressData.postcode;
            city = addressData.city;
            state = addressData.state;
            country = addressData.country;
          });
        }
      } else {
        print('FAILED');
      }
    } else {
      throw Exception('Unable to fetch data from the REST API');
    }
  }

  void updateProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userID = prefs.getInt('userID');
    var _userID = userID.toString();

    Uri saveDataURI =
        Uri.parse("https://hawkingnight.com/planner/public/api/user/update");

    final response = await http.post(saveDataURI, headers: {
      "Accept": "application/json"
    }, body: {
      'user_id': _userID,
      'name': nameController.text,
      'phone_no': phoneNoController.text,
      'address': addressController.text,
      'other_address': otherAddressController.text,
      'city': cityController.text,
      'state': stateController.text,
      'postcode': postcodeController.text,
      'country': countryController.text
    });

    if (response.statusCode == 200) {
      // ScaffoldMessenger.of(context)
      //     .showSnackBar(SnackBar(content: Text("Success!")));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Failed to Save!")));
      print(response.statusCode);
    }
  }

  void logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('userID');
    prefs.remove('userName');
    prefs.remove('userMatricNo');
    prefs.remove('userImageURL');
    prefs?.setBool("isLoggedIn", false);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (BuildContext ctx) => Login()));
  }

  // @override
  // void initState() {
  //   super.initState();
  //   getData();
  // }

  // Widgets
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(
          width: 45,
          height: 45,
          margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: IconButton(
              icon: Icon(
                Icons.chevron_left,
                color: Colors.blue[800],
                size: 32,
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.blue[800]),
          ),
        ),
        leadingWidth: 100,
        actions: [
          Container(
              margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Material(
                color: Colors.white,
                child: Center(
                  child: Ink(
                    decoration: ShapeDecoration(
                      color: Colors.blue[800],
                      shape: CircleBorder(),
                    ),
                    child: IconButton(
                      icon: isEnabled == false
                          ? Icon(Icons.edit)
                          : Icon(Icons.save),
                      color: Colors.white,
                      onPressed: () {
                        setState(() {
                          isEnabled = !isEnabled;
                          if (isEnabled == false) {
                            updateProfile();
                          }
                        });
                      },
                    ),
                  ),
                ),
              )),
        ],
        title: Text(
          'My Detail(s)',
          style: GoogleFonts.openSans(
            textStyle: TextStyle(
                color: Colors.blue[800],
                fontWeight: FontWeight.w700,
                fontSize: 24),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: getForm(),
    );
  }

  Widget getForm() {
    return FutureBuilder(
      future: getData(),
      builder: (context, snapshot) {
        print(snapshot.toString());
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              color: Colors.green[800],
            ),
            
          );
        } else {
          if (snapshot.hasError)
            return Center(child: Text('Error: ${snapshot.error}'));
          else
            return buildMainContainer();
        }
      },
    );
  }


  Widget buildMainContainer() {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 60),
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
              buildLogout()
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
      margin: EdgeInsets.fromLTRB(20, 30, 20, 10),
      decoration: BoxDecoration(
          color: Colors.grey[200], borderRadius: BorderRadius.circular(10.0)),
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
        child: TextFormField(
            enabled: isEnabled,
            controller: nameController,
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
            enabled: false,
            controller: emailController,
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
            enabled: false,
            controller: matricNoController,
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
            enabled: isEnabled,
            controller: phoneNoController,
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
            enabled: isEnabled,
            controller: addressController,
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
            enabled: isEnabled,
            controller: otherAddressController,
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
            enabled: isEnabled,
            controller: postcodeController,
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
            enabled: isEnabled,
            controller: cityController,
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
            enabled: isEnabled,
            controller: stateController,
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
            enabled: isEnabled,
            controller: countryController,
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

  Widget buildLogout() {
    return Container(
      margin: EdgeInsets.only(top: 10.00),
      child: ElevatedButton(
        onPressed: () {
          logout();
        },
        child: Text(
          'LOGOUT',
          textAlign: TextAlign.left,
          style: GoogleFonts.openSans(
            textStyle: TextStyle(
                letterSpacing: 1,
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.white),
          ),
        ),
        style: ElevatedButton.styleFrom(
          elevation: 0,
          primary: Colors.red[800],
          minimumSize: Size(350, 50),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(40),
            ),
          ),
        ),
      ),
    );
  }
}

import 'dart:convert';
import 'package:MyUni/auth/sign_in.dart';
import 'package:MyUni/pages/profile_detail.dart';
import 'package:MyUni/pages/progression.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:MyUni/models/Verify.dart';
import 'package:MyUni/models/User.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  // Variables
  int userID = 0;
  String name = '';
  String email = '';
  String matricNo = '';
  String address = '';
  String imageURL = '';

  Map<String, dynamic> verifyMap;
  Map<String, dynamic> userMap;

  // Methods
  // Future getData() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   if (this.mounted) {
  //     setState(() {
  //       userID = prefs.getInt('userID');

  //       getDataAPI();
  //     });
  //   }
  // }

  Future getDataAPI() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userID = prefs.getInt('userID');

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
            // phoneNo = userData.phone_no;
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

  @override
  void initState() {
    super.initState();
    getDataAPI();
  }

  // Widgets
  Widget buildMainContainer() {
    return FutureBuilder(
        future: getDataAPI(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }else{
            if(snapshot.hasError){
              return Center(child)
            }
          }
        });
  }

  Widget buildTitle() {
    return Container(
      margin: EdgeInsets.fromLTRB(15, 80, 0, 0),
      // child: Align(
      //   alignment: Alignment.topLeft,
      //   child: Text('Profile',
      //       style: GoogleFonts.nunito(
      //           textStyle: TextStyle(
      //               fontSize: 42,
      //               fontWeight: FontWeight.w900,
      //               color: Colors.green[800]))),
      // ),
    );
  }

  Widget buildProfileImage() {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Center(
          // alignment: Alignment.centerLeft,
          child: CircleAvatar(
        backgroundColor: Colors.red[800],
        radius: 50,
        backgroundImage: NetworkImage(imageURL),
      )),
    );
  }

  Widget buildNameEmail() {
    return Column(
      children: [
        Center(
          child: Container(
            margin: EdgeInsets.fromLTRB(0, 10, 0, 1),
            child: SizedBox(
              width: 250,
              child: Text(name,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                  style: GoogleFonts.openSans(
                      textStyle: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w800))),
            ),
          ),
        ),
        Center(
          child: Container(
            margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
            child: SizedBox(
              width: 250,
              child: Text(email,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                  style:
                      GoogleFonts.openSans(textStyle: TextStyle(fontSize: 14))),
            ),
          ),
        )
      ],
    );
  }

  Widget buildButton() {
    return Container(
        margin: EdgeInsets.fromLTRB(30, 5, 30, 5),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                margin: EdgeInsets.only(top: 5.00),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext ctx) => ProfileDetail()));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('My Detail(s)',
                          textAlign: TextAlign.left,
                          style: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black))),
                      Icon(
                        Icons.chevron_right,
                        color: Colors.black,
                      )
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    primary: Color.fromRGBO(234, 237, 237, 0.5),
                    minimumSize: Size(350, 50),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(40))),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10.00),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext ctx) => Progression()));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Academic Progression',
                          textAlign: TextAlign.left,
                          style: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black))),
                      Icon(
                        Icons.chevron_right,
                        color: Colors.black,
                      )
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    primary: Color.fromRGBO(234, 237, 237, 0.5),
                    minimumSize: Size(350, 50),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(40))),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10.00),
                child: ElevatedButton(
                  onPressed: () {
                    logout();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Logout',
                          textAlign: TextAlign.left,
                          style: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black))),
                      Icon(
                        Icons.chevron_right,
                        color: Colors.black,
                      )
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    primary: Color.fromRGBO(234, 237, 237, 0.5),
                    minimumSize: Size(350, 50),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(40))),
                  ),
                ),
              )
            ]));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: buildMainContainer());
  }
}

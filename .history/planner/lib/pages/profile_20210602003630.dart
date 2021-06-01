import 'dart:convert';
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
  Future getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (this.mounted) {
      setState(() {
        userID = prefs.getInt('userID');

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

  @override
  void initState() {
    super.initState();
    getData();
  }

  // Widgets
  Widget buildMainContainer() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          buildTitle(),
          buildProfileImage(),
          buildNameEmail(),
          buildButton(),
        ],
      )
    );
  }

  Widget buildTitle() {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 70, 0, 0),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text('Profile',
            style: GoogleFonts.nunito(
                textStyle: TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.w900,
                    color: Colors.green[800]))),
      ),
    );
  }

  Widget buildProfileImage() {
    return Container(
      margin: EdgeInsets.fromLTRB(0,10,0,0),
      child: Center(
        // alignment: Alignment.centerLeft,
        child: CircleAvatar(
          radius: 50,
          backgroundImage: NetworkImage(imageURL),
        )
      ),
    );
  }

  Widget buildNameEmail(){
    return Column(
      children: [
        Center(
          child: Container(
            margin: EdgeInsets.fromLTRB(0, 10, 0, 1),
            child: SizedBox(
              width: 250,
              child: Text(
                name,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
                style: GoogleFonts.openSans(
                  textStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800
                  )
                )
              ),
            ),
          ),
        ),
        Center(
          child: Container(
            margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
            child: SizedBox(
              width: 250,
              child: Text(
                email,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
                style: GoogleFonts.openSans(
                  textStyle: TextStyle(
                    fontSize: 14
                  )
                )
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget buildButton(){
    return Container(
      margin: EdgeInsets.fromLTRB(30, 5, 30, 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            margin: EdgeInsets.only(top: 5.00),
            child: ElevatedButton(
              onPressed: () {}, 
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'My Detail(s)',
                    textAlign: TextAlign.left,
                      style: GoogleFonts.openSans(
                        textStyle: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.black
                        )
                      )
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: Colors.black,
                  )
                ],
              ),
              style: ElevatedButton.styleFrom(
                elevation: 0,
                primary: Color.fromRGBO(237, 244, 255, 0.5),
                minimumSize: Size(350, 50),
                shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.all(Radius.circular(40))),
              ),
            ),
          ), 
          Container(
            margin: EdgeInsets.only(top: 10.00),
            child: ElevatedButton(
              onPressed: () {}, 
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Academic Progression',
                    textAlign: TextAlign.left,
                      style: GoogleFonts.openSans(
                        textStyle: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.black
                        )
                      )
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: Colors.black,
                  )
                ],
              ),
              style: ElevatedButton.styleFrom(
                elevation: 0,
                primary: Color.fromRGBO(234, 237, 255, 0.5),
                minimumSize: Size(350, 50),
                shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.all(Radius.circular(40))),
              ),
            ),
          ), 
          Container(
            margin: EdgeInsets.only(top: 10.00),
            child: ElevatedButton(
              onPressed: () {}, 
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Logout',
                    textAlign: TextAlign.left,
                      style: GoogleFonts.openSans(
                        textStyle: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.black
                        )
                      )
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: Colors.black,
                  )
                ],
              ),
              style: ElevatedButton.styleFrom(
                elevation: 0,
                primary: Color.fromRGBO(237, 244, 255, 0.5),
                minimumSize: Size(350, 50),
                shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.all(Radius.circular(40))),
              ),
            ),
          )
        ]
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: buildMainContainer());
    //   return Scaffold(
    //       appBar: AppBar(
    //           backgroundColor: Colors.green[900],
    //           title: Center(child: Text('My Profile'))),
    //       body: Padding(
    //         padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
    //         child: Column(
    //           crossAxisAlignment: CrossAxisAlignment.stretch,
    //           children: [
    //             Container(
    //               margin: EdgeInsets.fromLTRB(0, 50, 0, 0),
    //               child: CircleAvatar(
    //                 radius: 80,
    //                 backgroundImage: NetworkImage(imageURL),
    //               ),
    //             ),
    //             // Name
    //             Container(
    //                 padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
    //                 child: Center(
    //                   child: Row(children: [
    //                     Expanded(
    //                       flex: 1,
    //                       child: Text('Name',
    //                           style: TextStyle(
    //                               fontSize: 16,
    //                               fontWeight: FontWeight.w900,
    //                               fontFamily: 'Nunito')),
    //                     ),
    //                     Expanded(
    //                         flex: 2,
    //                         child: Container(
    //                             width: 200,
    //                             child: Card(
    //                                 child: Padding(
    //                                     padding:
    //                                         EdgeInsets.fromLTRB(20, 10, 20, 10),
    //                                     child: ConstrainedBox(
    //                                       constraints:
    //                                           BoxConstraints(minHeight: 20),
    //                                       child: Text('$name',
    //                                           style: TextStyle(
    //                                               fontSize: 14,
    //                                               fontFamily: 'Nunito')),
    //                                     )))))
    //                   ]),
    //                 )),
    //             // Matric No
    //             Container(
    //               padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
    //               child: Row(children: [
    //                 Expanded(
    //                   flex: 1,
    //                   child: Text('Matric No',
    //                       style: TextStyle(
    //                           fontSize: 16, fontWeight: FontWeight.bold)),
    //                 ),
    //                 Expanded(
    //                     flex: 2,
    //                     child: Container(
    //                         width: 200,
    //                         child: Card(
    //                             child: Padding(
    //                                 padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
    //                                 child: ConstrainedBox(
    //                                   constraints: BoxConstraints(minHeight: 20),
    //                                   child: Text('$matricNo',
    //                                       style: TextStyle(
    //                                           fontSize: 14,
    //                                           fontFamily: 'Nunito')),
    //                                 )))))
    //               ]),
    //             ),
    //             // Email
    //             Container(
    //               padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
    //               child: Row(children: [
    //                 Expanded(
    //                   flex: 1,
    //                   child: Text('Email',
    //                       style: TextStyle(
    //                           fontSize: 16, fontWeight: FontWeight.bold)),
    //                 ),
    //                 Expanded(
    //                     flex: 2,
    //                     child: Container(
    //                         width: 200,
    //                         child: Card(
    //                             child: Padding(
    //                                 padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
    //                                 child: ConstrainedBox(
    //                                   constraints: BoxConstraints(minHeight: 20),
    //                                   child: Text('$email',
    //                                       style: TextStyle(
    //                                           fontSize: 14,
    //                                           fontFamily: 'Nunito')),
    //                                 )))))
    //               ]),
    //             ),
    //             // Course
    //             Container(
    //               padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
    //               child: Row(children: [
    //                 Expanded(
    //                   flex: 1,
    //                   child: Text('Course',
    //                       style: TextStyle(
    //                           fontSize: 16, fontWeight: FontWeight.bold)),
    //                 ),
    //                 Expanded(
    //                     flex: 2,
    //                     child: Container(
    //                         width: 200,
    //                         child: Card(
    //                             child: Padding(
    //                                 padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
    //                                 child: ConstrainedBox(
    //                                   constraints: BoxConstraints(minHeight: 20),
    //                                   child: Text('WC09 - Multimedia Computing',
    //                                       style: TextStyle(
    //                                           fontSize: 14,
    //                                           fontFamily: 'Nunito')),
    //                                 )))))
    //               ]),
    //             ),
    //             // Faculty
    //             Container(
    //               padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
    //               child: Row(children: [
    //                 Expanded(
    //                   flex: 1,
    //                   child: Text('Faculty',
    //                       style: TextStyle(
    //                           fontSize: 16,
    //                           fontWeight: FontWeight.bold,
    //                           fontFamily: 'Nunito')),
    //                 ),
    //                 Expanded(
    //                     flex: 2,
    //                     child: Container(
    //                         width: 200,
    //                         child: Card(
    //                             child: Padding(
    //                                 padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
    //                                 child: ConstrainedBox(
    //                                   constraints: BoxConstraints(minHeight: 20),
    //                                   child: Text(
    //                                       'Faculty of Computer Science and Information Tecnology',
    //                                       style: TextStyle(
    //                                           fontSize: 14,
    //                                           fontFamily: 'Nunito')),
    //                                 )))))
    //               ]),
    //             ),
    //             // Years of Studies & Semester
    //             Container(
    //               padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
    //               child: Row(children: [
    //                 Expanded(
    //                   flex: 2,
    //                   child: Text('Year of Studies',
    //                       style: TextStyle(
    //                           fontSize: 16, fontWeight: FontWeight.bold)),
    //                 ),
    //                 Expanded(
    //                   flex: 1,
    //                   child: SizedBox(
    //                       width: 45,
    //                       height: 45,
    //                       child: Card(
    //                           child: Padding(
    //                               padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
    //                               child: Text('4',
    //                                   style: TextStyle(
    //                                       fontSize: 14, fontFamily: 'Nunito'))))),
    //                 ),
    //                 Expanded(
    //                     flex: 1,
    //                     child: SizedBox(
    //                       width: 5,
    //                     )),
    //                 Expanded(
    //                     flex: 2,
    //                     child: Text('Semester',
    //                         style: TextStyle(
    //                             fontSize: 16,
    //                             fontWeight: FontWeight.bold,
    //                             fontFamily: 'Nunito'))),
    //                 Expanded(
    //                     flex: 0,
    //                     child: SizedBox(
    //                         width: 50,
    //                         height: 45,
    //                         child: Card(
    //                             child: Padding(
    //                                 padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
    //                                 child: Text('2',
    //                                     style: TextStyle(
    //                                         fontSize: 14,
    //                                         fontFamily: 'Nunito'))))))
    //               ]),
    //             ),
    //             // MoreDetails
    //             Container(
    //                 padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
    //                 child: Row(children: [
    //                   Text('More Detail(s)',
    //                       style: TextStyle(
    //                           fontSize: 16,
    //                           fontWeight: FontWeight.bold,
    //                           fontFamily: 'Nunito')),
    //                 ])),
    //             ElevatedButton(
    //               onPressed: () {},
    //               child: Text('My Academic Progression'),
    //             ),
    //           ],
    //         ),
    //       ));
  }
}

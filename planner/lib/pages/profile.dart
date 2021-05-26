import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:MyUni/models/Verify.dart';
import 'package:MyUni/models/User.dart';
import 'dart:convert';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  int userID = 0;
  String name = '';
  String email = '';
  // String phoneNo = '';
  String matricNo = '';
  String address = '';
  String imageURL = '';

  Map<String, dynamic> verifyMap;
  Map<String, dynamic> userMap;

  Future getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(this.mounted) {
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

        if(this.mounted) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.green[900],
            title: Center(child: Text('My Profile'))),
        body: Padding(
          padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(0, 50, 0, 0),
                child: CircleAvatar(
                  radius: 80,
                  backgroundImage: NetworkImage(imageURL),
                ),
              ),
              // Name
              Container(
                  padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
                  child: Center(
                    child: Row(children: [
                      Expanded(
                        flex: 1,
                        child: Text('Name',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                fontFamily: 'Nunito')),
                      ),
                      Expanded(
                          flex: 2,
                          child: Container(
                              width: 200,
                              child: Card(
                                  child: Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(20, 10, 20, 10),
                                      child: ConstrainedBox(
                                        constraints:
                                            BoxConstraints(minHeight: 20),
                                        child: Text('$name',
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontFamily: 'Nunito')),
                                      )))))
                    ]),
                  )),
              // Matric No
              Container(
                padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                child: Row(children: [
                  Expanded(
                    flex: 1,
                    child: Text('Matric No',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                  Expanded(
                      flex: 2,
                      child: Container(
                          width: 200,
                          child: Card(
                              child: Padding(
                                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(minHeight: 20),
                                    child: Text('$matricNo',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'Nunito')),
                                  )))))
                ]),
              ),
              // Email
              Container(
                padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                child: Row(children: [
                  Expanded(
                    flex: 1,
                    child: Text('Email',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                  Expanded(
                      flex: 2,
                      child: Container(
                          width: 200,
                          child: Card(
                              child: Padding(
                                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(minHeight: 20),
                                    child: Text('$email',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'Nunito')),
                                  )))))
                ]),
              ),
              // Course
              Container(
                padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                child: Row(children: [
                  Expanded(
                    flex: 1,
                    child: Text('Course',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                  Expanded(
                      flex: 2,
                      child: Container(
                          width: 200,
                          child: Card(
                              child: Padding(
                                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(minHeight: 20),
                                    child: Text('WC09 - Multimedia Computing',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'Nunito')),
                                  )))))
                ]),
              ),
              // Faculty
              Container(
                padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                child: Row(children: [
                  Expanded(
                    flex: 1,
                    child: Text('Faculty',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Nunito')),
                  ),
                  Expanded(
                      flex: 2,
                      child: Container(
                          width: 200,
                          child: Card(
                              child: Padding(
                                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(minHeight: 20),
                                    child: Text(
                                        'Faculty of Computer Science and Information Tecnology',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'Nunito')),
                                  )))))
                ]),
              ),
              // Years of Studies & Semester
              Container(
                padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                child: Row(children: [
                  Expanded(
                    flex: 2,
                    child: Text('Year of Studies',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                  Expanded(
                    flex: 1,
                    child: SizedBox(
                        width: 45,
                        height: 45,
                        child: Card(
                            child: Padding(
                                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                child: Text('4',
                                    style: TextStyle(
                                        fontSize: 14, fontFamily: 'Nunito'))))),
                  ),
                  Expanded(
                      flex: 1,
                      child: SizedBox(
                        width: 5,
                      )),
                  Expanded(
                      flex: 2,
                      child: Text('Semester',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Nunito'))),
                  Expanded(
                      flex: 0,
                      child: SizedBox(
                          width: 50,
                          height: 45,
                          child: Card(
                              child: Padding(
                                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                  child: Text('2',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: 'Nunito'))))))
                ]),
              ),
              // MoreDetails
              Container(
                  padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                  child: Row(children: [
                    Text('More Detail(s)',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Nunito')),
                  ])),
              ElevatedButton(
                onPressed: () {},
                child: Text('My Academic Progression'),
              ),
            ],
          ),
        ));
  }
}

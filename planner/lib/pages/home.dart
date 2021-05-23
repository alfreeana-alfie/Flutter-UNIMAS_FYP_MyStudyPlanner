import 'package:MyUni/models/Verify.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int _selectedIndex = 0;
  int userID;
  String name;
  String matric_no;
  String imageURL = "";

  List data = [];
  Map<String, dynamic> verifyMap;

  Future getUserID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      userID = prefs.getInt('userID');

      name = prefs.getString('userName');
      matric_no = prefs.getString('userMatricNo');
      imageURL = prefs.getString('userImage');

      getLesson();
    });
  }

  Future getLesson() async {
    var userIDStr = userID.toString();
    print(userID.toString());

    Uri getLessonURI = Uri.parse(
        "https://hawkingnight.com/planner/public/api/get-lesson/$userIDStr");

    final response =
        await http.get(getLessonURI, headers: {'Accept': 'application/json'});

    if (response.statusCode == 200) {
      verifyMap = jsonDecode(response.body);
      var verifyData = Verify.fromJSON(verifyMap);

      if (verifyData.status == "SUCCESS") {
        print('Got Data');
      }else{
        print('No Data');
      }
    } else {
      throw Exception('Unable to fetch products from the REST API');
    }
  }

  @override
  void initState() {
    super.initState();
    getUserID();
  }

  // List<Lesson> lessons = [
  //   Lesson(
  //       id: 1,
  //       user_id: '1',
  //       name: 'Multimedia Computing',
  //       abbr: 'TMT4142',
  //       startTime: '10:00 AM',
  //       endTime: '11:00 AM',
  //       day: 'Monday',
  //       color: '#000000'),
  //   Lesson(
  //       id: 2,
  //       user_id: '1',
  //       name: 'Multimedia Computing',
  //       abbr: 'TMT4142',
  //       startTime: '10:00 AM',
  //       endTime: '11:00 AM',
  //       day: 'Monday',
  //       color: '#000000')
  // ];

  // List<Announcement> announcements = [
  //   Announcement(
  //       id: 1,
  //       title: 'TMI4013 - DATA MINING',
  //       description: 'Lecture class will be held on Tue, 14 Nov 2020.',
  //       created_at: '10-10-2020'),
  //   Announcement(
  //       id: 2,
  //       title: 'TMI4013 - DATA MINING',
  //       description: 'Lecture class will be held on Tue, 14 Nov 2020.',
  //       created_at: '10-10-2020')
  // ];

  Widget userOverview() {
    return Padding(
        padding: EdgeInsets.fromLTRB(10, 30, 10, 10),
        child: ListTile(
          leading: CircleAvatar(
            radius: 40,
            backgroundImage: NetworkImage('${imageURL}'),
          ),
          title: Text('${name}'),
          subtitle: Text('${matric_no}'),
        ));
  }

  Widget lessonOverview(Lesson) {
    return Padding(
        padding: EdgeInsets.all(0.0),
        child: Padding(
            padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
            child: Column(children: [
              Row(
                children: [
                  Column(
                    children: [Text(Lesson.startTime), Text(Lesson.endTime)],
                  ),
                  Container(
                      height: 45,
                      child: VerticalDivider(
                        color: Colors.red,
                      )),
                  Column(
                    children: [Text(Lesson.name), Text(Lesson.abbr)],
                  ),
                ],
              ),
              Container(
                  child: Divider(
                color: Colors.black,
                height: 10,
              )),
            ])));
  }

  Widget announcementOverview(Announcement) {
    return Padding(
      padding: EdgeInsets.all(0.0),
      child: Padding(
          padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
          child: Column(children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              Column(children: [
                Text(Announcement.title),
                Text(Announcement.description),
                Text(Announcement.created_at)
              ]),
              IconButton(
                onPressed: () {
                  print('Annnouncement clicked');
                },
                icon: Icon(Icons.arrow_right),
              ),
            ]),
            Container(
                child: Divider(
              color: Colors.black,
              height: 10,
            )),
          ])),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.red[900],
            elevation: 0.0,
            title: Center(
              child: Text('Homepage'),
            )),
        body: Container(
          margin: EdgeInsets.fromLTRB(15, 10, 15, 10),
          child: Column(children: [
            Expanded(
              flex: 1,
              child: Container(child: userOverview()),
            ),
            // Expanded(
            //   flex: 2,
            //   child: Card(
            //       child: Column(children: [
            //     ListTile(tileColor: Colors.red, title: Text('Monday')),
            //     ListView(
            //       shrinkWrap: true,
            //       children: lessons.map((p) {
            //         return lessonOverview(p);
            //       }).toList(),
            //     ),
            //   ])),
            // ),
            // Expanded(
            //     flex: 3,
            //     child: Card(
            //         child: Column(children: [
            //       ListTile(tileColor: Colors.red, title: Text('Announcement')),
            //       ListView(
            //           shrinkWrap: true,
            //           children: announcements.map((p) {
            //             return announcementOverview(p);
            //           }).toList()),
            //     ]))),
          ]),
        ));
  }
}

import 'package:avatar_letter/avatar_letter.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:MyUni/models/Verify.dart';
import 'package:MyUni/models/Lesson.dart';
import 'package:MyUni/models/News.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  // Variables
  int _selectedIndex = 0;
  int userID;
  String name;
  String matric_no;
  String imageURL = "";

  List<Lesson> data = [];
  List<News> dataNewsList = [];
  Map<String, dynamic> verifyMap;
  Map<String, dynamic> lessonList;
  Map<String, dynamic> newsList;

  Future getUserID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      userID = prefs.getInt('userID');

      name = prefs.getString('userName');
      matric_no = prefs.getString('userMatricNo');
      imageURL = prefs.getString('userImage');

      getLessonList(userID.toString());
      getAnnouncementList();
    });
  }

  Future getLessonList(String userIDStr) async {
    Uri getAPILink = Uri.parse(
        "https://hawkingnight.com/planner/public/api/get-lesson/$userIDStr");

    final response =
        await http.get(getAPILink, headers: {"Accept": "application/json"});

    if (response.statusCode == 200) {
      verifyMap = jsonDecode(response.body);
      var verifyData = Verify.fromJSON(verifyMap);

      if (verifyData.status == "SUCCESS") {
        lessonList = jsonDecode(response.body);
        for (var lessonMap in lessonList['lesson']) {
          final lessons = Lesson.fromMap(lessonMap);
          setState(() {
            data.add(lessons);
          });
        }
      } else {
        print('Failed to fetch!');
      }
    } else {
      throw Exception('Unable to fetch data from the REST API');
    }
  }

  Future getAnnouncementList() async {
    Uri getAPILink =
        Uri.parse("https://hawkingnight.com/planner/public/api/get-news");

    final response =
        await http.get(getAPILink, headers: {"Accept": "application/json"});

    if (response.statusCode == 200) {
      verifyMap = jsonDecode(response.body);
      var verifyData = Verify.fromJSON(verifyMap);

      if (verifyData.status == "SUCCESS") {
        newsList = jsonDecode(response.body);
        for (var newsMap in newsList['news']) {
          final news = News.fromMap(newsMap);
          setState(() {
            dataNewsList.add(news);
          });
        }
      } else {
        print('Failed to fetch!');
      }
    } else {
      throw Exception('Unable to fetch data from the REST API');
    }
  }

  @override
  void initState() {
    super.initState();
    getUserID();
  }

  Widget buildMainContainer() {
    return Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.grey[200], Colors.white])),
        child: buildSecondaryContent()

    );
  }

  Widget buildTitle() {
    return Container(
      margin: EdgeInsets.fromLTRB(20, 110, 30, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Welcome back',
                        style: TextStyle(
                            fontFamily: 'Metropolis',
                            fontWeight: FontWeight.w800,
                            color: Colors.black,
                            fontSize: 32)),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 5, 20, 0),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text('${name}.',
                            style: TextStyle(
                                color: Colors.red[400],
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                fontFamily: 'Metropolis'))),
                  )
                ],
              ),
              Align(
                alignment: Alignment.centerRight,
                child: CircleAvatar(
                  radius: 25,
                  backgroundImage: NetworkImage('${imageURL}'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildSecondaryContent() {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 250, 0, 0),
      child: Material(
        elevation: 2,
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        child: buildNewsList(),
      )
    );
  }

  Widget buildLessonContent(Lesson) {
    return Container(
        child: Column(children: [
      AvatarLetter(
          size: 85,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 48,
          upperCase: true,
          numberLetters: 2,
          letterType: LetterType.Circular,
          text: Lesson.name),
      Padding(
          padding: EdgeInsets.only(top: 2),
          child: Text(Lesson.name,
              style: TextStyle(
                  fontFamily: 'Open Sans',
                  fontSize: 24,
                  fontWeight: FontWeight.w700)))
    ]));
  }

  Widget buildLessonList() {
    return Container(
        margin: EdgeInsets.fromLTRB(15, 10, 15, 10),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Text('Subject List',
                  style: TextStyle(
                      fontFamily: 'Open Sans',
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Colors.grey[700])),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(top: 30.0),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  children: data.map((p) {
                    return buildLessonContent(p);
                  }).toList(),
                ),
              ),
            )
          ],
        ));
  }

  Widget buildNewsContent(News) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, 
        children: [
        AvatarLetter(
            size: 50,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 24,
            upperCase: true,
            numberLetters: 2,
            letterType: LetterType.Rectangle,
            text: News.title),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: 250,
              child: Text(
                News.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                  style: TextStyle(
                    fontFamily: 'Open Sans',
                    fontSize: 14,
                    fontWeight: FontWeight.w800
                    )
                  ),
            ),
            SizedBox(
              width: 250,
              child: Text(
                News.description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                  style: TextStyle(
                    fontFamily: 'Open Sans',
                    fontSize: 12,
                    )
                  ),
            ),
          ],
        ),
        IconButton(
          onPressed: () {
            print('Annnouncement clicked');
          },
          icon: Icon(Icons.arrow_right),
        ),
      ]
    );
  }

  Widget buildNewsList() {
    return Container(
        margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
        child: ListView(
          padding: EdgeInsets.all(0.0),
          children: dataNewsList.map((p) {
            return buildNewsContent(p);
          }).toList(),
        )
    );
  }

  Widget announcementOverview(News) {
    return Padding(
      padding: EdgeInsets.all(0.0),
      child: Padding(
          padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
          child: Column(children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              Column(children: [
                Text(News.title),
                Text(News.description),
                Text(News.createdAt)
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

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //       appBar: AppBar(
  //           backgroundColor: Colors.red[900],
  //           elevation: 0.0,
  //           title: Center(
  //             child: Text('Homepage'),
  //           )),
  //       body: Container(
  //         margin: EdgeInsets.fromLTRB(15, 10, 15, 10),
  //         child: Column(children: [
  //           Expanded(
  //             flex: 1,
  //             child: Container(child: userOverview()),
  //           ),
  //           Expanded(
  //             flex: 1,
  //             child: Container(
  //               margin: EdgeInsets.fromLTRB(15, 10, 15, 10),
  //               child: Stack(
  //               children: [
  //                 Align(
  //                   alignment: Alignment.topLeft,
  //                   child: Text('Subject(s):',
  //                   style: TextStyle(
  //                     fontFamily: 'Open Sans',
  //                     fontSize: 16,
  //                     fontWeight: FontWeight.w800,
  //                     letterSpacing: 1.0,
  //                     color: Colors.grey[700]
  //                   )),
  //                 ),
  //                 Align(
  //                   alignment: Alignment.centerLeft,
  //                   child: Padding(
  //                     padding: EdgeInsets.only(top: 30.0),
  //                     child: ListView(
  //                       scrollDirection: Axis.horizontal,
  //                       shrinkWrap: true,
  //                       children: data.map((p) {
  //                         return buildLessonContent(p);
  //                       }).toList(),
  //                     ),
  //                   )
  //                 ),
  //               ]
  //             )
  //             )
  //           ),
  //           Expanded(
  //               flex: 3,
  //               child: Card(
  //                   child: Column(children: [
  //                 ListTile(tileColor: Colors.red, title: Text('Announcement')),
  //                 ListView(

  //                     shrinkWrap: true,
  //                     children: dataNewsList.map((p) {
  //                       return announcementOverview(p);
  //                     }).toList()),
  //               ]))),
  //         ]),
  //       ));
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: buildMainContainer());
  }
}

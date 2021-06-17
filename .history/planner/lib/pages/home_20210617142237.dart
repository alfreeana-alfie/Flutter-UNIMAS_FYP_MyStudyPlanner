import 'dart:ui';
import 'dart:convert';

import 'package:MyUni/pages/list_lesson.dart';
import 'package:avatar_letter/avatar_letter.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

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

  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();

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
          if (this.mounted) {
            setState(() {
              data.add(lessons);
            });
          }
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
          if (this.mounted) {
            setState(() {
              dataNewsList.add(news);
            });
          }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: buildMainContainer());
  }

  Widget buildMainContainer() {
    return Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("images/white02.jpeg"), fit: BoxFit.cover),
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.grey[200], Colors.white])),
        child: Stack(
          children: [buildTitle(), buildLessonList(), buildSecondaryContent()],
        ));
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
        margin: EdgeInsets.fromLTRB(0, 350, 0, 0),
        child: Material(
          elevation: 3,
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30)),
          // borderRadius: BorderRadius.horizontal(left: Radius.circular(20), right:Radius.circular(20)),
          child: buildNewsList(),
        ));
  }

  Widget buildLessonContent(Lesson) {
    String colorString = Lesson.color;
    String valueString = colorString.split('(0x')[1].split(')')[0];
    int value = int.parse(valueString, radix: 16);
    Color lessonColor = new Color(value);

    return Container(
      margin: EdgeInsets.only(right: 10.0),
      child: Column(children: [
        AvatarLetter(
            size: 75,
            backgroundColor: lessonColor,
            textColor: Colors.white,
            fontSize: 32,
            upperCase: true,
            numberLetters: 2,
            letterType: LetterType.Circular,
            text: Lesson.name),
        Padding(
          padding: EdgeInsets.only(top: 2),
          child: SizedBox(
            width: 50,
            child: Center(
                child: Text(Lesson.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                    style: GoogleFonts.openSans(
                        textStyle: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500)))),
          ),
        ),
      ]),
    );
  }

  Widget buildLessonList() {
    return Container(
        margin: EdgeInsets.fromLTRB(20, 180, 15, 10),
        child: Stack(
          children: [
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text('Subject List',
                          style: GoogleFonts.nunito(
                              textStyle: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.w900))),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ListLesson()));
                      },
                      child: Text(
                        'See All',
                        style: TextStyle(
                            color: Colors.red[900],
                            fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        primary: Colors.red[100],
                        minimumSize: Size(80, 25),
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                      ),
                    )
                  ],
                ),
              ],
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(top: 50.0),
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
    return Padding(
        padding: EdgeInsets.fromLTRB(5, 0, 5, 20),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          AvatarLetter(
            size: 50,
            backgroundColor: Colors.blue[100],
            textColor: Colors.blue[300],
            fontSize: 24,
            upperCase: true,
            numberLetters: 2,
            letterType: LetterType.Rectangle,
            text: News.title,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 250,
                child: Text(News.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                    style: GoogleFonts.openSans(
                        textStyle: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w900))),
              ),
              SizedBox(
                width: 250,
                child: Text(News.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                    style: GoogleFonts.openSans(
                        textStyle: TextStyle(
                      fontSize: 12,
                    ))),
              )
            ],
          ),
          IconButton(
            onPressed: () {
              print('Annnouncement clicked');
            },
            icon: Icon(Icons.arrow_right),
          ),
        ]));
  }

  Widget buildNewsList() {
    return Container(
        margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
        child: Stack(
          children: [
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(0, 15, 20, 2),
                            child: Text(
                              'Announcement',
                              style: GoogleFonts.nunito(
                                textStyle: TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.w900),
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                            width: 190,
                            height: 5,
                            decoration: BoxDecoration(
                              color: Colors.red[400],
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.fromLTRB(10, 70, 10, 5),
              child: ListView(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                children: dataNewsList.map((p) {
                  return buildNewsContent(p);
                }).toList(),
              ),
            ),
          ],
        ));
  }

  Widget getNews() {
    return FutureBuilder(
      future: getAnnouncementList(),
      builder(context, )
    );
  }
}

import 'dart:ui';
import 'dart:convert';

import 'package:MyUni/pages/home_bulletin.dart';
import 'package:MyUni/pages/list_lesson.dart';
import 'package:avatar_letter/avatar_letter.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:awesome_notifications/awesome_notifications.dart';

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

    userID = prefs.getInt('userID');

    name = prefs.getString('userName');
    matric_no = prefs.getString('userMatricNo');
    imageURL = prefs.getString('userImage');
  }

  Future getLessonList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userID = prefs.getInt('userID');
    String userIDStr = userID.toString();

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
            data.add(lessons);
            // setState(() {
            // });
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
            dataNewsList.add(news);
            // setState(() {

            //   // return Future.value("Data download successfully");
            // });
          }
        }
      } else {
        print('Failed to fetch!');
      }
    } else {
      throw Exception('Unable to fetch data from the REST API');
    }

    return Future.value("Data download successfully");
  }

  void noti() {
    AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: 10,
            channelKey: 'basic_channel',
            title: 'Simple Notification',
            body: 'Simple body'));
  }

  @override
  void initState() {
    super.initState();
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
          children: [getTitle(), buildLessonList(), buildSecondaryContent()],
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
                   backgroundImage:
                    NetworkImage("$imageURL}"),
                backgroundColor: Colors.transparent,
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
            getLesson(),
          ],
        ));
  }

  Widget buildNewsContent(News) {
    return Padding(
        padding: EdgeInsets.fromLTRB(5, 0, 5, 5),
        child: Column(
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              AvatarLetter(
                  size: 50,
                  backgroundColor: Colors.blue[100],
                  textColor: Colors.blue[300],
                  fontSize: 24,
                  upperCase: true,
                  numberLetters: 2,
                  letterType: LetterType.Rectangle,
                  text: News.title),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 200,
                    child: Text(News.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                        style: GoogleFonts.openSans(
                            textStyle: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w900))),
                  ),
                  SizedBox(
                    width: 200,
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
                  // noti();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              BulletinDetails(announcements: News)));
                },
                icon: Icon(Icons.arrow_right),
              ),
            ]),
            Padding(
              padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
              child: Divider(
                height: 1,
                thickness: 1,
                color: Colors.grey[200],
              ),
            ),
          ],
        ));
  }

  Widget buildNewsList() {
    return Container(
        margin: EdgeInsets.fromLTRB(15, 5, 15, 5),
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
            getNews(),
          ],
        ));
  }

  Widget getNews() {
    return FutureBuilder(
      future: getAnnouncementList(),
      builder: (context, snapshot) {
        print(snapshot.toString());
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          if (snapshot.hasError)
            return Center(child: Text('Error: ${snapshot.error}'));
          else
            return Container(
                margin: EdgeInsets.fromLTRB(10, 65, 10, 5),
                child: ListView(
                  padding: EdgeInsets.only(top: 10.0),
                  children: dataNewsList.map((p) {
                    return buildNewsContent(p);
                  }).toList(),
                ));
        }
      },
    );
  }

  Widget getLesson() {
    return FutureBuilder(
      future: getLessonList(),
      builder: (context, snapshot) {
        print(snapshot.toString());
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: 70.0),
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          if (snapshot.hasError)
            return Center(child: Text('Error: ${snapshot.error}'));
          else
            return Align(
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
            );
        }
      },
    );
  }

  Widget getTitle() {
    return FutureBuilder(
      future: getUserID(),
      builder: (context, snapshot) {
        print(snapshot.toString());
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else {
          if (snapshot.hasError)
            return Center(child: Text('Error: ${snapshot.error}'));
          else
            return buildTitle();
        }
      },
    );
  }
}

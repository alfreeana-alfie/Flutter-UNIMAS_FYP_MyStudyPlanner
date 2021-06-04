import 'dart:convert';

import 'package:MyUni/models/Lesson.dart';
import 'package:MyUni/pages/lesson_details.dart';
import 'package:MyUni/pages/subject_details.dart';
import 'package:avatar_letter/avatar_letter.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:MyUni/models/Verify.dart';

import 'add_lesson.dart';

class ListLesson extends StatefulWidget {
  @override
  _ListLessonState createState() => _ListLessonState();
}

class _ListLessonState extends State<ListLesson> {
  // Variables
  int userID = 0;
  List<Lesson> data = [];
  Map<String, dynamic> verifyMap;
  Map<String, dynamic> lessonList;
  Color _shadeColor = Colors.blue[800];

  // Methods
  Future getUserID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      userID = prefs.getInt('userID');

      getLessonList(userID.toString());
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

  @override
  void initState() {
    super.initState();
    getUserID();
  }

  // Widgets
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 45,
              height: 45,
              margin: EdgeInsets.all(15.0),
              child: IconButton(
                  icon: Icon(
                    Icons.chevron_left,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              decoration: BoxDecoration(
                color: _shadeColor,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: _shadeColor),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Center(
                child: Text(
                  'Subject(s)',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.openSans(
                    textStyle: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: _shadeColor,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(10, 0, 15, 0),
              child: Material(
                color: Colors.white,
                child: Center(
                  child: Ink(
                    decoration: ShapeDecoration(
                      color: Colors.blue[800],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.add),
                      color: Colors.white,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddLesson()));
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: buildMainContainer(),
    );
  }

  Widget buildMainContainer() {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: Container(
              margin: EdgeInsets.fromLTRB(20, 30, 20, 0),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10))),
              child: ListView(
                shrinkWrap: true,
                children: data.map(
                  (p) {
                    return buildList(p);
                  },
                ).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildList(Lesson) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
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
            text: Lesson.name,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 250,
                child: Text(
                  Lesson.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                  style: GoogleFonts.openSans(
                    textStyle:
                        TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
                  ),
                ),
              ),
            ],
          ),
          IconButton(
            onPressed: () {
              MaterialPageRoute(builder: (context) => LessonDetails(lessons: Lesson));
            },
            icon: Icon(Icons.arrow_right),
          ),
        ]),
      ),
    );
  }
}

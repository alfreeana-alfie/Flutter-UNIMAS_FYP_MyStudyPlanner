import 'dart:convert';

import 'package:MyUni/models/Lesson.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:MyUni/models/Verify.dart';
import 'package:MyUni/models/Lesson.dart';

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
    return Container();
  }

  Widget buildMainContainer() {
    return Container(
        decoration: BoxDecoration(color: Colors.white),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(15, 60, 0, 0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text('Timetable',
                        style: GoogleFonts.nunito(
                            textStyle: TextStyle(
                                fontSize: 42,
                                fontWeight: FontWeight.w900,
                                color: Colors.blue[800]))),
                  ),
                ),
                Container(
                    margin: EdgeInsets.fromLTRB(10, 60, 15, 0),
                    child: Material(
                      color: Colors.white,
                      child: Center(
                        child: Ink(
                          decoration: ShapeDecoration(
                            color: Colors.blue[800],
                            shape: CircleBorder(),
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
                    )),
              ],
            ),
            Expanded(
              flex: 2,
              child: Container(
                margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
                decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10))),
                child: buildCalendar(),
              ),
            ),
          ],
        ));
  }

  Widget buildList() {

  }
}

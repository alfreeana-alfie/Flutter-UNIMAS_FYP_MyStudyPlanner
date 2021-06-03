import 'package:MyUni/models/Lesson.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ListLesson extends StatefulWidget {
  @override
  _ListLessonState createState() => _ListLessonState();
}

class _ListLessonState extends State<ListLesson> {
  // Variables
  String userID = '';
  List<Lesson> data = [];
  Map<String, dynamic> verifyMap;
  Map<String, dynamic> lessonList;

  // Methods
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

  // Widgets
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

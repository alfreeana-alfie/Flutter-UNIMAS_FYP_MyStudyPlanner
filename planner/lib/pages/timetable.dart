import 'package:MyUni/pages/add_lesson.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:MyUni/models/Verify.dart';
import 'package:MyUni/models/Lesson.dart';

class Timetable extends StatefulWidget {
  @override
  _TimetableState createState() => _TimetableState();
}

class _TimetableState extends State<Timetable> {
  Map<String, dynamic> verifyMap;
  Map<String, dynamic> lessonList;

  Future getSharedData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      var userID = prefs.getInt("userID");

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

        _parseLesson(lessonList);
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
    getSharedData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:
            AppBar(backgroundColor: Colors.blue[900], title: Text('Timetable')),
        body: SfCalendar(
          view: CalendarView.week,
          firstDayOfWeek: 1,
          monthViewSettings: MonthViewSettings(showAgenda: true),
          timeSlotViewSettings: TimeSlotViewSettings(
              startHour: 8, endHour: 23, timeIntervalHeight: 60),
          dataSource: MeetingDataSource(getAppointments()),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => AddLesson()));
          },
        ));
  }
}

List<Lesson> _parseLesson(Map<String, dynamic> map) {
  final lesson = <Lesson>[];
  for (var lessonMap in map['lesson']) {
    final lessons = Lesson.fromMap(lessonMap);
    lesson.add(lessons);
  }
  return lesson;
}


List<Appointment> getAppointments() {
  List<Appointment> meetings = [];
  final DateTime today = DateTime.now();
  final DateTime startTime = DateTime(2021, 05, 03, 12, 0, 0);
  final DateTime endTime = startTime.add(const Duration(hours: 2));

  final DateTime startTime02 = DateTime(2021, 05, 03, 14, 0, 0);
  final DateTime endTime02 = startTime02.add(const Duration(hours: 2));

  final DateTime startTime03 =
      DateTime(today.year, today.month, today.day, 8, 0, 0);
  final DateTime endTime03 = startTime03.add(const Duration(hours: 2));

  meetings.add(Appointment(
      startTime: startTime,
      endTime: endTime,
      subject: "TMT4013 - Computer Game Design and Development",
      color: Colors.orange,
      recurrenceRule: "FREQ=WEEKLY;BYDAY=MO"));

  meetings.add(Appointment(
      startTime: startTime02,
      endTime: endTime02,
      subject: "TMT4693 - Intelligent System",
      color: Colors.blue,
      recurrenceRule: "FREQ=WEEKLY;BYDAY=MO"));

  meetings.add(Appointment(
      startTime: startTime03,
      endTime: endTime03,
      subject: "TMF4034 - Technopreneurship and Product Developement",
      color: Colors.green,
      recurrenceRule: "FREQ=WEEKLY;BYDAY=THURS"));

  return meetings;
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Appointment> source) {
    appointments = source;
  }
}

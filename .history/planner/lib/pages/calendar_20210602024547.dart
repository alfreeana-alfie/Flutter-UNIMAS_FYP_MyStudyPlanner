import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:MyUni/models/Verify.dart';
import 'package:MyUni/models/Lesson.dart';

class Calendar extends StatefulWidget {
  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  // Variables
  Map<String, dynamic> verifyMap;
  Map<String, dynamic> lessonList;

  // Methods
  Future downloadData()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userID = prefs.getInt("userID");
    Uri getAPILink = Uri.parse(
        "https://hawkingnight.com/planner/public/api/get-lesson/$userID");

    final response =
        await http.get(getAPILink, headers: {"Accept": "application/json"});

    if (response.statusCode == 200) {
        verifyMap = jsonDecode(response.body);
        var verifyData = Verify.fromJSON(verifyMap);

        if (verifyData.status == "SUCCESS") {
          lessonList = jsonDecode(response.body);

          _parseAppointment();
        } else {
          print('Failed to fetch!');
        }
        return Future.value("Data download successfully");
      } else {
        print('Failed to fetch!');
      }
  }

  List<Appointment> _parseAppointment() {
    List<Appointment> meetings = [];
    for (var lessonMap in lessonList['lesson']) {
      final lessons = Lesson.fromMap(lessonMap);

      // Start Time 
      String _startTimeSTR = lessons.startTime;
      int _startTimeHour = int.parse(_startTimeSTR.split(":")[0]);
      int _startTimeMin = int.parse(_startTimeSTR.split(":")[1].split(" ")[0]);

      // End Time
      String _endTimeSTR = lessons.endTime;
      int _endTimeHour = int.parse(_endTimeSTR.split(":")[0]);
      int _endTimeMin = int.parse(_endTimeSTR.split(":")[1].split(" ")[0]);

      // Colour
      String colorString = lessons.color;
      String valueString = colorString.split('(0x')[1].split(')')[0];
      int value = int.parse(valueString, radix: 16);
      Color lessonColor = new Color(value);

      TimeOfDay _startTime =
          TimeOfDay(hour: _startTimeHour, minute: _startTimeMin);
      TimeOfDay _endTime = TimeOfDay(hour: _endTimeHour, minute: _endTimeMin);

      final today = new DateTime.now();
      final DateTime startTime = DateTime(today.year, 01, 31,
          _startTime.hour, _startTime.minute, 0);
      final DateTime endTime = DateTime(today.year, 01, 31,
          _endTime.hour, _endTime.minute, 0);

      meetings.add(Appointment(
          startTime: startTime,
          endTime: endTime,
          subject: lessons.name,
          color: lessonColor,
          recurrenceRule: "FREQ=WEEKLY;BYDAY=${lessons.day.toUpperCase()}"));
    }
    return meetings;
  }

  // Widgets
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
                    child: Text('Calendar',
                        style: GoogleFonts.nunito(
                            textStyle: TextStyle(
                                fontSize: 42,
                                fontWeight: FontWeight.w900,
                                color: Colors.blue[500]))),
                  ),
                ),
                Container(
                    margin: EdgeInsets.fromLTRB(10, 60, 15, 0),
                    child: Material(
                      color: Colors.white,
                      child: Center(
                        child: Ink(
                          decoration: ShapeDecoration(
                            color: Colors.blue[500],
                            shape: CircleBorder(),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.add),
                            color: Colors.white,
                            onPressed: () {
                              
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

  Widget buildCalendar() {
    return FutureBuilder(
      future: downloadData(),
      builder: (context, snapshot) {
        if( snapshot.connectionState == ConnectionState.waiting){
          // return  Center(child: Text('Please wait its loading...'));
          return SfCalendar(
                view: CalendarView.month,
                showNavigationArrow: true,
                showDatePickerButton: true,
                showCurrentTimeIndicator: true,
                monthViewSettings: MonthViewSettings(showAgenda: true),
                firstDayOfWeek: 1,
                allowedViews: <CalendarView>
                [
                  CalendarView.day,
                  CalendarView.week,
                  CalendarView.workWeek,
                  CalendarView.month
                ],
                onTap: (calendarLongPressDetails) {
                  print(calendarLongPressDetails.appointments);
                },
                timeSlotViewSettings: TimeSlotViewSettings(
                    startHour: 7, endHour: 24, timeIntervalHeight: 60)
              ); 
        }else{
            if (snapshot.hasError)
              return Center(child: Text('Error: ${snapshot.error}'));
            else
              return SfCalendar(
                view: CalendarView.month,
                showNavigationArrow: true,
                showDatePickerButton: true,
                showCurrentTimeIndicator: true,
                monthViewSettings: MonthViewSettings(showAgenda: true),
                firstDayOfWeek: 1,
                allowedViews: <CalendarView>
                [
                  CalendarView.day,
                  CalendarView.week,
                  CalendarView.workWeek,
                  CalendarView.month
                ],
                onTap: (calendarLongPressDetails) {
                  print(calendarLongPressDetails.appointments);
                },
                timeSlotViewSettings: TimeSlotViewSettings(
                    startHour: 7, endHour: 24, timeIntervalHeight: 60),
                dataSource: MeetingDataSource(_parseAppointment()),
              );  
        }
      },
    );
  }
  
  CalendarController _controller;
  Map<DateTime, List<dynamic>> _events;
  List<dynamic> _selectedEvents;
  TextEditingController _eventController;
  SharedPreferences prefs;

  _showAddDialog() async {
    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Add Events"),
              content: TextField(
                controller: _eventController,
              ),
              actions: [
                TextButton(
                  child: Text("Save"),
                  onPressed: () {
                    if (_eventController.text.isEmpty) return;
                      if (_events[_controller.selectedDay] != null) {
                        _events[_controller.selectedDay]
                            .add(_eventController.text);
                      } else {
                        _events[_controller.selectedDay] = [
                          _eventController.text
                        ];
                      }
                      prefs.setString("events", json.encode(encodeMap(_events)));
                      _eventController.clear();
                      Navigator.pop(context);
                  },
                ),
              ],
            ));
            setState(() {
      _selectedEvents = _events[_controller.selectedDay];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: buildMainContainer());
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Appointment> source) {
    appointments = source;
  }
}
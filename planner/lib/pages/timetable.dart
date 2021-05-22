import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class Timetable extends StatefulWidget {
  @override
  _TimetableState createState() => _TimetableState();
}

class _TimetableState extends State<Timetable> {
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
          onPressed: _showAddDialog,
        ));
  }

  _showAddDialog() async {
    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Add Events"),
              content: TextField(
                  // controller: _eventController,
                  ),
              actions: [
                TextButton(
                  child: Text("Save"),
                  onPressed: () {
                    // if (_eventController.text.isEmpty) return;
                    //   if (_events[_controller.selectedDay] != null) {
                    //     _events[_controller.selectedDay]
                    //         .add(_eventController.text);
                    //   } else {
                    //     _events[_controller.selectedDay] = [
                    //       _eventController.text
                    //     ];
                    //   }
                    //   prefs.setString("events", json.encode(encodeMap(_events)));
                    //   _eventController.clear();
                    //   Navigator.pop(context);
                  },
                ),
              ],
            ));
    setState(() {
      // _selectedEvents = _events[_controller.selectedDay];
    });
  }
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

import 'package:MyUni/models/Lesson.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oktoast/oktoast.dart';
import 'package:day_picker/day_picker.dart';
import 'package:time_range/time_range.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class LessonDetails extends StatefulWidget {
  Lesson lessons;

  LessonDetails({Key key, this.lessons}) : super(key: key);

  @override
  _LessonDetailsState createState() => _LessonDetailsState();
}

class _LessonDetailsState extends State<LessonDetails> {
  // Variables
  String name = '';
  String abbr = '';
  String color = '';
  String type = '';
  String teacher = '';
  String place = '';
  String day = '';
  String startTime = '';
  String endTime = '';

  final _formKey = GlobalKey<FormState>();

  Color _tempShadeColor;

  Color _shadeColor = Colors.blue[800];

  // Methods
  void saveData() async {
    print(
        '$name, $abbr, $color, $type, $teacher, $place, $startTime, $endTime');
    Uri saveDataURI =
        Uri.parse("https://hawkingnight.com/planner/public/api/add-lesson");

    final response = await http.post(saveDataURI, headers: {
      "Accept": "application/json"
    }, body: {
      'user_id': '1',
      'name': name,
      'abbr': abbr,
      'color': color,
      'type': type,
      'teacher': teacher,
      'place': place,
      'day': day,
      'startTime': startTime,
      'endTime': endTime
    });

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Success!")));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Failed to Save!")));
    }
  }

  // Widget
  @override
  Widget build(BuildContext context) {
    String colorString = widget.lessons.color;
    String valueString = colorString.split('(0x')[1].split(')')[0];
    int value = int.parse(valueString, radix: 16);
    _shadeColor = new Color(value);

    return OKToast(
      child: Scaffold(
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
                    'Add Lesson',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.openSans(
                      textStyle: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: _shadeColor,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 5),
                child: Align(
                  alignment: Alignment.topRight,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        saveData();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error!')),
                        );
                      }
                    },
                    child: Text('SAVE',
                        style: GoogleFonts.openSans(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        )),
                    style: ElevatedButton.styleFrom(
                        primary: _shadeColor,
                        side: BorderSide(width: 1, color: _shadeColor)),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: buildMainContainer(),
      ),
    );
  }

  Widget buildMainContainer() {
    return Form(
      key: _formKey,
      child: Container(
        child: Column(
          children: [
            buildMainDetails(),
            divider('Other Detail(s)'),
            buildOtherDetails(),
            divider('Select Day & Time'),
            buildDayTime()
          ],
        ),
      ),
    );
  }

  Widget buildMainDetails() {
    return Container(
      margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Column(
        children: [
          TextFormField(
            initialValue: widget.lessons.name,
            decoration: InputDecoration(
              labelText: 'Name (Eg: Subject)',
            ),
            onChanged: (value) {
              setState(() {
                name = value;
              });
            },
            validator: (val) {
              if (val.isEmpty) {
                return 'Name is empty!';
              }
              return null;
            },
          ),
          TextFormField(
            initialValue: widget.lessons.abbr,
            decoration: InputDecoration(
              labelText: 'Abbreviation (Eg: TMT1234)',
            ),
            onChanged: (value) {
              setState(() {
                abbr = value;
              });
            },
            validator: (val) {
              if (val.isEmpty) {
                return 'Abbreviation is empty!';
              }
              return null;
            },
          ),
          Container(
            margin: EdgeInsets.fromLTRB(10, 20, 10, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CircleAvatar(backgroundColor: _shadeColor, radius: 20.0),
                ElevatedButton(
                  onPressed: _openColorPicker,
                  child: Text(
                    'Choose Color',
                    style: GoogleFonts.openSans(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: _shadeColor,
                    side: BorderSide(width: 1, color: _shadeColor),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget divider(String title) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: 20),
          child: Divider(
            height: 5,
            thickness: 2,
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            margin: EdgeInsets.only(left: 10.00),
            child: Text(
              title,
              style: GoogleFonts.openSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: _shadeColor),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildOtherDetails() {
    return Container(
      margin: EdgeInsets.fromLTRB(20, 0, 20, 10),
      child: Column(
        children: [
          TextFormField(
              initialValue: widget.lessons.type,
              decoration: InputDecoration(
                labelText: 'Type (Eg: Lecture)',
              ),
              onChanged: (value) {
                setState(() {
                  type = value;
                });
              },
              validator: (val) {
                if (val.isEmpty) {
                  return 'Type is empty!';
                }
                return null;
              }),
          TextFormField(
              initialValue: widget.lessons.teacher,
              decoration: InputDecoration(
                labelText: 'Teacher (Eg: Mr. Example)',
              ),
              onChanged: (value) {
                setState(() {
                  teacher = value;
                });
              },
              validator: (val) {
                if (val.isEmpty) {
                  return 'Teacher is empty!';
                }
                return null;
              }),
          TextFormField(
              initialValue: widget.lessons.place,
              decoration: InputDecoration(
                labelText: 'Place (Eg: MM1 Lab)',
              ),
              onChanged: (value) {
                setState(() {
                  place = value;
                });
              },
              validator: (val) {
                if (val.isEmpty) {
                  return 'Place is empty!';
                }
                return null;
              }),
        ],
      ),
    );
  }

  Widget buildDayTime() {
    return Container(
      child: Column(
        children: [
          dayPicker(),
          timeRangePicker(),
        ],
      ),
    );
  }

  void _openDialog(String title, Widget content) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(6.0),
          title: Text(title),
          content: content,
          actions: [
            TextButton(
              child: Text('CANCEL'),
              onPressed: Navigator.of(context).pop,
            ),
            TextButton(
              child: Text('SUBMIT'),
              onPressed: () {
                Navigator.of(context).pop();
                // setState(() => _shadeColor = _tempShadeColor
                setState(() {
                  _shadeColor = _tempShadeColor;
                  color = _tempShadeColor.toString();
                });
              },
            ),
          ],
        );
      },
    );
  }

  void _openColorPicker() async {
    _openDialog(
      "Color picker",
      MaterialColorPicker(
        selectedColor: _shadeColor,
        onColorChange: (color) => setState(() => _tempShadeColor = color),
        onBack: () => print("Back button pressed"),
      ),
    );
  }

  Widget dayPicker() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
        child: Row(
          children: [
            Text(
              'Day: ',
              style: GoogleFonts.openSans(
                  textStyle:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.grey[600]),),
            ),
            Text(
              widget.lessons.day,
              style: GoogleFonts.openSans(
                  textStyle:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey[600]),),
            ),
          ],
        ),
      ),
    );

    // return Center(
    //   child: Padding(
    //     padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
    //     child: SelectWeekDays(
    //       border: false,
    //       boxDecoration: BoxDecoration(color: _shadeColor),
    //       onSelect: (values) {
    //         setState(() {
    //           values[0] = widget.lessons.day;
    //         });
    //         // <== Callback to handle the selected days
    //         day = values[0];
    //         print(values[0]);
    //       },
    //     ),
    //   ),
    // );
  }

  Widget timeRangePicker() {
    // Start Time
    String _startTimeSTR = widget.lessons.startTime;
    int _startTimeHour = int.parse(_startTimeSTR.split(":")[0]);
    int _startTimeMin = int.parse(_startTimeSTR.split(":")[1].split(" ")[0]);

    // End Time
    String _endTimeSTR = widget.lessons.endTime;
    int _endTimeHour = int.parse(_endTimeSTR.split(":")[0]);
    int _endTimeMin = int.parse(_endTimeSTR.split(":")[1].split(" ")[0]);

    TimeOfDay _startTime =
        TimeOfDay(hour: _startTimeHour, minute: _startTimeMin);
    TimeOfDay _endTime = TimeOfDay(hour: _endTimeHour, minute: _endTimeMin);

    return TimeRange(
      initialRange: TimeRangeResult(_startTime, _endTime),
      fromTitle: Text('From',
          style: GoogleFonts.openSans(fontSize: 14, color: Colors.black45)),
      toTitle: Text(
        'To',
        style: GoogleFonts.openSans(fontSize: 14, color: Colors.black45),
      ),
      titlePadding: 15,
      textStyle: TextStyle(fontWeight: FontWeight.normal, color: _shadeColor),
      activeTextStyle: TextStyle(
          fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
      activeBorderColor: _shadeColor,
      borderColor: _shadeColor,
      backgroundColor: Colors.transparent,
      activeBackgroundColor: _shadeColor,
      firstTime: TimeOfDay(hour: 08, minute: 00),
      lastTime: TimeOfDay(hour: 23, minute: 10),
      timeStep: 10,
      timeBlock: 10,
      onRangeCompleted: (range) {
        startTime = range.start.format(context);
        endTime = range.end.format(context);
      },
    );
  }
}

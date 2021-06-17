import 'package:MyUni/models/Lesson.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oktoast/oktoast.dart';
import 'package:day_picker/day_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  String userID = '';
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

  bool isEnabled = false;

  // Methods
  Future getUserID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    userID = prefs.getInt('userID').toString();
  }

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

  @override
  void initState() {
    super.initState();
    getUserID();
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
              Align(
                alignment: Alignment.center,
                child: Center(
                  child: Text(
                    widget.lessons.name,
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
            ],
          ),
          leading: Container(
            width: 45,
            height: 45,
            margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: IconButton(
                icon: Icon(
                  Icons.chevron_left,
                  color: _shadeColor,
                  size: 32,
                ),
                onPressed: () {
                  Navigator.pop(context);
                }),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: _shadeColor),
            ),
          ),
          leadingWidth: 100,
          actions: [
            Container(
                margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Material(
                  color: Colors.white,
                  child: Center(
                    child: Ink(
                      decoration: ShapeDecoration(
                        color: _shadeColor,
                        shape: CircleBorder(),
                      ),
                      child: IconButton(
                        icon: isEnabled == false
                            ? Icon(Icons.edit)
                            : Icon(Icons.save),
                        color: Colors.white,
                        onPressed: () {
                          setState(() {
                            isEnabled = !isEnabled;
                            if (isEnabled == false) {
                              // updateProfile();
                            }
                          });
                        },
                      ),
                    ),
                  ),
                )),
          ],
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
            buildDayTime(),
            buildDelete(),
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
            enabled: isEnabled,
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
            enabled: isEnabled,
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
                CircleAvatar(backgroundColor: _shadeColor, radius: 25.0),
                Container(
                  child: isEnabled == true
                      ? ElevatedButton(
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
                        )
                      : Container(
                        color: Colors.white,
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
            enabled: isEnabled,
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
            enabled: isEnabled,
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
            enabled: isEnabled,
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
            Card(
              color: _shadeColor,
              child: Container(
                padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                child: Text(
                  'DAY',
                  style: GoogleFonts.openSans(
                    textStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white),
                  ),
                ),
              ),
            ),
            Card(
              color: _shadeColor,
              child: Container(
                padding: EdgeInsets.fromLTRB(40, 5, 40, 5),
                child: Text(
                  widget.lessons.day,
                  style: GoogleFonts.openSans(
                    textStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget timePicker(String time) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
        child: Row(
          children: [
            Card(
              color: _shadeColor,
              child: Container(
                padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                child: Text(
                  'TIME',
                  style: GoogleFonts.openSans(
                    textStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white),
                  ),
                ),
              ),
            ),
            Card(
              color: _shadeColor,
              child: Container(
                padding: EdgeInsets.fromLTRB(40, 5, 40, 5),
                child: Text(
                  time,
                  style: GoogleFonts.openSans(
                    textStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
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

    return Container(
      child: isEnabled == true ? 
        TimeRange(
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
    ) : Column(
      children: [
        build
      ],
    ),
    );
  }

  Widget buildDelete() {
    return Container(
      margin: EdgeInsets.only(top: 15.00),
      child: ElevatedButton(
        onPressed: () {
          // logout();
        },
        child: Text(
          'DELETE',
          textAlign: TextAlign.left,
          style: GoogleFonts.openSans(
            textStyle: TextStyle(
                letterSpacing: 1,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white),
          ),
        ),
        style: ElevatedButton.styleFrom(
          elevation: 0,
          primary: Colors.red[800],
          minimumSize: Size(380, 50),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(40),
            ),
          ),
        ),
      ),
    );
  }
}

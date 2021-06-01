import 'package:MyUni/pages/timetable.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oktoast/oktoast.dart';
import 'package:day_picker/day_picker.dart';
import 'package:time_range/time_range.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:http/http.dart' as http;

class AddLesson extends StatefulWidget {
  @override
  _AddLessonState createState() => _AddLessonState();
}

class _AddLessonState extends State<AddLesson> {

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

  // Methods
  void saveData() async {
    print('$name, $abbr, $color, $type, $teacher, $place, $startTime, $endTime');
    Uri saveDataURI = Uri.parse("https://hawkingnight.com/planner/public/api/add-lesson");

    final response = await http.post(
      saveDataURI,
      headers: {"Accept": "application/json"},
      body: {
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
      }
    );

    if(response.statusCode == 201){
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Success!")));
    }else{
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Failed to Save!")));
    }
  }

  Widget textField(String title, String data) {
    return TextFormField(
        decoration: InputDecoration(
          labelText: '$title',
        ),
        onChanged: (value) {
          setState(() {
            data = value;
          });
        },
        validator: (val) {
          if (val.isEmpty) {
            return '$title is empty!';
          }
          return null;
        });
  }

  Color _tempShadeColor;
  Color _shadeColor = Colors.blue[800];

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
        padding: const EdgeInsets.all(8.0),
        child: SelectWeekDays(
          border: false,
          boxDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.0),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              colors: [const Color(0xFFE55CE4), const Color(0xFFBB75FB)],
              tileMode:
                  TileMode.repeated, // repeats the gradient over the canvas
            ),
          ),
          onSelect: (values) {
            // <== Callback to handle the selected days
            day = values[0];
            print(values[0]);
          },
        ),
      ),
    );
  }

  Widget timeRangePicker() {
    return TimeRange(
      fromTitle: Text(
        'From',
        style: TextStyle(fontSize: 18, color: Colors.grey),
      ),
      toTitle: Text(
        'To',
        style: TextStyle(fontSize: 18, color: Colors.grey),
      ),
      titlePadding: 20,
      textStyle:
          TextStyle(fontWeight: FontWeight.normal, color: Colors.black87),
      activeTextStyle:
          TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
      borderColor: Colors.black,
      backgroundColor: Colors.transparent,
      activeBackgroundColor: Colors.orange,
      firstTime: TimeOfDay(hour: 08, minute: 00),
      lastTime: TimeOfDay(hour: 23, minute: 10),
      timeStep: 10,
      timeBlock: 10,
      onRangeCompleted: (range) {
        startTime = range.start.format(context);
        endTime = range.end.format(context);

        print('${range.start.format(context)}');
        print('${range.end.format(context)}');
      },
    );
  }

  Widget form() {
    return Form(
      key: _formKey,
      child: Container(
        margin: EdgeInsets.fromLTRB(15, 10, 15, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Name',
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
              }),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Abbreviation',
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
              }),
            Row(
              children: [
                CircleAvatar(backgroundColor: _shadeColor, radius: 35.0),
                OutlinedButton(
                  onPressed: _openColorPicker,
                  child: const Text('Choose Color'),
                ),
              ],
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Type',
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
              decoration: InputDecoration(
                labelText: 'Teacher',
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
              decoration: InputDecoration(
                labelText: 'Place',
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
            dayPicker(),
            timeRangePicker(),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  saveData();
                } else {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text('Error!')
                    )
                  );
                }
              },
              child: Text('SIGN UP',
                  style: TextStyle(fontWeight: FontWeight.bold)))
          ]
        )
      )
    );
  }

  Widget buildMainContainer() {
    return Form(
      key: _formKey,
      child: Container(
        margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: Column(
          children: [
            buildMainDetails(),
            buildOtherDetails()
          ],
        ),
      )
    );
  }

  Widget buildMainDetails(){
    return Column(
      children: [
        TextFormField(
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
          }
        ),
        TextFormField(
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
          }
        ),
      ],
    );
  }

  Widget buildOtherDetails(){
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: 30),
          child: Divider(
            height: 5,
            thickness: 2,
            indent: 10,
	          endIndent: 10,
          )
        ),
        Container(
          child: Text('Other Details')
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return OKToast(
        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Colors.white,
                elevation: 0.0,
                title: Row(
                  children: [
                    Container(
                      width: 45,
                      height: 45,
                      margin: EdgeInsets.all(15.0),
                      child: IconButton(
                        icon: Icon(
                          Icons.chevron_left,
                          color: Colors.black,
                        ), 
                        onPressed: (){
                          Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Timetable()));
                        }),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.black
                        )
                      ),
                    ),
                    Center(
                      child: Text(
                        'Add Lesson',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                            
                          )
                        ),
                      )
                    )
                  ],
                )),
            body: buildMainContainer()));
  }
}

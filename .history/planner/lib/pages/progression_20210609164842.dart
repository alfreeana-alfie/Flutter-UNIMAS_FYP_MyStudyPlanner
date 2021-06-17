import 'dart:convert';

import 'package:MyUni/models/Lesson.dart';
import 'package:MyUni/models/Verify.dart';
import 'package:avatar_letter/avatar_letter.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'indicator.dart';

class Progression extends StatefulWidget {
  const Progression({Key key}) : super(key: key);

  @override
  _ProgressionState createState() => _ProgressionState();
}

class _ProgressionState extends State<Progression> {
  // Variables
  int userID = 0;
  int touchedIndex = -1;
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Progression'),
      ),
      body: buildMainContainer(),
    );
  }

  Widget buildMainContainer() {
    return Container(
      child: Column(
        children: [
          Text('Academic Overall Progression Report'),
          buildPieChart(),
          Expanded(
            flex: 1,
            child: Container(
              margin: EdgeInsets.fromLTRB(0, 200, 0, 0),
              child: Material(
                elevation: 3,
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30)),
                // borderRadius: BorderRadius.horizontal(left: Radius.circular(20), right:Radius.circular(20)),
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
          ),
        ],
      ),
    );
  }

  Widget buildPieChart() {
    return AspectRatio(
      aspectRatio: 1.5,
      child: Card(
        color: Colors.white,
        child: Column(
          children: [
            Row(children: [
              const SizedBox(
                width: 38,
              ),
              Expanded(
                child: AspectRatio(
                  aspectRatio: 0.6,
                  child: PieChart(
                    PieChartData(
                        pieTouchData:
                            PieTouchData(touchCallback: (pieTouchResponse) {
                          setState(() {
                            final desiredTouch = pieTouchResponse.touchInput
                                    is PointerExitEvent &&
                                pieTouchResponse.touchInput is! PointerUpEvent;
                            if (desiredTouch &&
                                pieTouchResponse.touchedSection != null) {
                              // touchedIndex = pieTouchResponse.touchedSection.touchedSectionIndex;
                            } else {
                              touchedIndex = -1;
                            }
                          });
                        }),
                        borderData: FlBorderData(
                          show: false,
                        ),
                        sectionsSpace: 0,
                        centerSpaceRadius: 40,
                        sections: showingSections()),
                  ),
                ),
              ),
              const SizedBox(
                width: 18,
              ),
              Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Indicator(
                    color: Color(0xff0293ee),
                    text: 'Core Subjects',
                    isSquare: true,
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Indicator(
                    color: Color(0xfff8b250),
                    text: 'Elective Subjects',
                    isSquare: true,
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Indicator(
                    color: Color(0xff845bef),
                    text: 'Remedial Subjects',
                    isSquare: true,
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Indicator(
                    color: Color(0xff13d38e),
                    text: 'General Studies Subjects',
                    isSquare: true,
                  ),
                  SizedBox(
                    height: 18,
                  ),
                ],
              ),
              const SizedBox(
                width: 20,
              ),
            ]),
          ],
        ),
      ),
    );
  }

  Widget buildList(Lesson) {
    return Card(
      elevation: 2,
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
        ]),
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(4, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: const Color(0xff0293ee),
            value: 18,
            title: '18',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 1:
          return PieChartSectionData(
            color: const Color(0xfff8b250),
            value: 3,
            title: '3',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 2:
          return PieChartSectionData(
            color: const Color(0xff845bef),
            value: 1,
            title: '1',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 3:
          return PieChartSectionData(
            color: const Color(0xff13d38e),
            value: 1,
            title: '1',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        default:
          throw Error();
      }
    });
  }
}

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildPieChart(),
          buildLineChart(),
          Expanded(
            flex: 1,
            child: Container(
              margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: Material(
                elevation: 3,
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30)),
                // borderRadius: BorderRadius.horizontal(left: Radius.circular(20), right:Radius.circular(20)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      color: Colors.blue[800]
                      margin: EdgeInsets.all(15.0),
                      child: Text(
                        'Subject(s) Taken',
                        style: GoogleFonts.openSans(
                            textStyle: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        )),
                      ),
                    ),
                    ListView(
                      shrinkWrap: true,
                      children: data.map(
                        (p) {
                          return buildList(p);
                        },
                      ).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPieChart() {
    return Card(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: Card(
              color: Colors.blue[500],
              child: Padding(
                padding: EdgeInsets.all(7.0),
                child: Text(
                  'Academic Overall Progression Report',
                  style: GoogleFonts.openSansCondensed(
                    textStyle: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 16),
                  ),
                ),
              ),
            ),
          ),
          Row(children: [
            Expanded(
              child: AspectRatio(
                aspectRatio: 1.4,
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
                      centerSpaceRadius: 12,
                      sections: showingSections()),
                ),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Indicator(
                  color: Color(0xff0293ee),
                  text: 'Core Subjects',
                  size: 12,
                  isSquare: false,
                ),
                SizedBox(
                  height: 2,
                ),
                Indicator(
                  color: Color(0xfff8b250),
                  text: 'Elective Subjects',
                  size: 12,
                  isSquare: false,
                ),
                SizedBox(
                  height: 2,
                ),
                Indicator(
                  color: Color(0xff845bef),
                  text: 'Remedial Subjects',
                  size: 12,
                  isSquare: false,
                ),
                SizedBox(
                  height: 2,
                ),
                Indicator(
                  color: Color(0xff13d38e),
                  text: 'General Studies Subjects',
                  size: 12,
                  isSquare: false,
                ),
                SizedBox(
                  height: 8,
                ),
              ],
            ),
            const SizedBox(
              width: 10,
            ),
          ]),
        ],
      ),
    );
  }

  Widget buildLineChart() {
    return AspectRatio(
      aspectRatio: 1.4,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(18)),
          gradient: LinearGradient(
            colors: [
              Colors.grey[100],
              Colors.white,
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        child: Stack(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(
                  height: 4,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: Card(
                      color: Colors.blue[500],
                      child: Container(
                        padding: EdgeInsets.all(7.0),
                        child: Text(
                          'Academic Performance Chart',
                          style: GoogleFonts.openSansCondensed(
                            textStyle: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 16),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 37,
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: 46.0, left: 6.0),
                    child: LineChart(
                      sampleData1(),
                      swapAnimationDuration: const Duration(milliseconds: 250),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Indicator(
                      color: Colors.orange[800],
                      text: 'CGPA',
                      size: 12,
                      isSquare: false,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Indicator(
                      color: Colors.blue[800],
                      text: 'GPA',
                      size: 12,
                      isSquare: false,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  LineChartData sampleData1() {
    return LineChartData(
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
        ),
        touchCallback: (LineTouchResponse touchResponse) {},
        handleBuiltInTouches: true,
      ),
      gridData: FlGridData(
        show: false,
      ),
      titlesData: FlTitlesData(
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          getTextStyles: (value) => const TextStyle(
            color: Color(0xff72719b),
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          margin: 10,
          getTitles: (value) {
            switch (value.toInt()) {
              case 1:
                return '17/18-1';
              case 2:
                return '17/18-2';
              case 3:
                return '18/19-1';
              case 4:
                return '18/19-2';
              case 5:
                return '19/20-1';
              case 6:
                return '19/20-2';
              case 7:
                return '20/21-1';
            }
            return '';
          },
        ),
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => const TextStyle(
            color: Color(0xff75729e),
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 1:
                return '1';
              case 2:
                return '2';
              case 3:
                return '3';
              case 4:
                return '4';
            }
            return '';
          },
          margin: 2,
          reservedSize: 30,
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: const Border(
          bottom: BorderSide(
            color: Color(0xff4e4965),
            width: 4,
          ),
          left: BorderSide(
            color: Colors.transparent,
          ),
          right: BorderSide(
            color: Colors.transparent,
          ),
          top: BorderSide(
            color: Colors.transparent,
          ),
        ),
      ),
      minX: 0,
      maxX: 7,
      maxY: 4,
      minY: 0,
      lineBarsData: linesBarData1(),
    );
  }

  List<LineChartBarData> linesBarData1() {
    // CGPA
    final lineChartBarData1 = LineChartBarData(
      spots: [
        FlSpot(1, 3.71),
        FlSpot(2, 3.73),
        FlSpot(3, 3.70),
        FlSpot(4, 3.69),
        FlSpot(5, 3.68),
        FlSpot(6, 3.68),
        FlSpot(7, 3.68),
      ],
      isCurved: false,
      colors: [
        Colors.orange[800],
      ],
      barWidth: 5,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: false,
      ),
      belowBarData: BarAreaData(
        show: false,
      ),
    );
    // GPA
    final lineChartBarData2 = LineChartBarData(
      spots: [
        FlSpot(1, 3.71),
        FlSpot(2, 3.75),
        FlSpot(3, 3.65),
        FlSpot(4, 3.67),
        FlSpot(5, 3.63),
        FlSpot(6, 0.0),
        FlSpot(7, 3.67),
      ],
      isCurved: false,
      colors: [
        Colors.blue[800],
      ],
      barWidth: 5,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: false,
      ),
      belowBarData: BarAreaData(show: true, colors: [
        Color(0x00aa4cfc),
      ]),
    );

    return [
      lineChartBarData1,
      lineChartBarData2,
    ];
  }

  Widget buildList(Lesson) {
    return Container(
      child: Padding(
        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          // AvatarLetter(
          //   size: 10,
          //   backgroundColor: Colors.blue[100],
          //   textColor: Colors.blue[300],
          //   fontSize: 18,
          //   upperCase: true,
          //   numberLetters: 2,
          //   letterType: LetterType.Circular,
          //   text: Lesson.name,
          // ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: SizedBox(
                  width: 200,
                  child: Text(
                    Lesson.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                    style: GoogleFonts.openSans(
                      textStyle:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
              Divider(
                color: Colors.grey[200],
                height: 2,
                thickness: 2,
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
      final fontSize = isTouched ? 25.0 : 14.0;
      final radius = isTouched ? 60.0 : 45.0;
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: const Color(0xff0293ee),
            value: 18,
            title: '18',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w500,
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
                fontWeight: FontWeight.w500,
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
                fontWeight: FontWeight.w500,
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
                fontWeight: FontWeight.w500,
                color: const Color(0xffffffff)),
          );
        default:
          throw Error();
      }
    });
  }
}

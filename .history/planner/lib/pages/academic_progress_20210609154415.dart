import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart';

class Progression extends StatefulWidget {
  @override
  _ProgressionState createState() => _ProgressionState();
}

class _ProgressionState extends State<Progression> {
  // Variables

  // Methods

  // Widgets
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Progression'),
      ),
      body: Container(
        child: Center(
          child: PieChart(
  PieChartData(
      pieTouchData: PieTouchData(touchCallback: (pieTouchResponse) {
        setState(() {
          if (pieTouchResponse.touchInput is FlLongPressEnd ||
              pieTouchResponse.touchInput is FlPanEnd) {
            touchedIndex = -1;
          } else {
            touchedIndex = pieTouchResponse.touchedSectionIndex;
          }
        });
      }),
      borderData: FlBorderData(
        show: false,
      ),
      sectionsSpace: 0,
      centerSpaceRadius: 60,
      sections: showingSections()),
),
        ),
      ),
    );
  }
}
